<template>
  <div>
    <div class="search">
      <el-select v-model="searchParams.courseId" placeholder="请选择课程" style="width: 200px; margin-right: 10px" clearable v-if="!isStudent" @change="loadScores(1)">
        <el-option v-for="item in courseOptions" :key="item.id" :label="item.name" :value="item.id"></el-option>
      </el-select>
      <el-input v-if="!isStudent" v-model="searchParams.studentName" placeholder="请输入学生姓名搜索" style="width: 200px;" clearable @input="loadScores(1)"></el-input>
      <el-button type="info" plain style="margin-left: 10px" @click="loadScores(1)">查询</el-button>
      <el-button type="warning" plain style="margin-left: 10px" @click="resetSearch" v-if="!isStudent">重置</el-button>
    </div>

    <div class="operation" v-if="isTeacher">
      <el-button type="primary" plain @click="handleAdd">录入成绩</el-button>
      <el-button type="danger" plain @click="deleteBatch" :disabled="selectedIds.length === 0">批量删除</el-button>
    </div>

    <div class="table">
      <el-table :data="tableData" stripe @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" v-if="isTeacher"></el-table-column>
        <el-table-column prop="id" label="序号" width="70" align="center" sortable></el-table-column>
        <el-table-column prop="studentName" label="学生" show-overflow-tooltip></el-table-column>
        <el-table-column prop="courseName" label="课程" show-overflow-tooltip></el-table-column>
        <el-table-column prop="teacherName" label="教师" show-overflow-tooltip v-if="!isTeacher"></el-table-column>
        <el-table-column prop="ordinaryScore" label="平时分" width="100"></el-table-column>
        <el-table-column prop="examScore" label="期末分" width="100"></el-table-column>
        <el-table-column prop="score" label="总成绩" width="100"></el-table-column>

        <el-table-column label="操作" width="180" align="center" v-if="isTeacher">
          <template v-slot="scope">
            <el-button plain type="primary" @click="handleEdit(scope.row)" size="mini">编辑</el-button>
            <el-button plain type="danger" size="mini" @click="handleDelete(scope.row.id)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>

      <div class="pagination">
        <el-pagination
            background
            @current-change="handleCurrentChange"
            :current-page="pageNum"
            :page-size="pageSize"
            layout="total, prev, pager, next"
            :total="total">
        </el-pagination>
      </div>
    </div>

    <el-dialog :title="form.id ? '编辑成绩' : '录入成绩'" :visible.sync="formVisible" width="450px" :close-on-click-modal="false" destroy-on-close @close="resetForm">
      <el-form :model="form" label-width="80px" style="padding-right: 20px" :rules="rules" ref="formRef">
        <el-form-item label="选择课程" prop="courseId" v-if="!form.id">
          <el-select v-model="form.courseId" placeholder="请选择课程" style="width: 100%" @change="handleCourseChangeForForm">
            <el-option v-for="item in teacherCourseOptions" :key="item.id" :label="item.name" :value="item.id"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="课程名称" v-if="form.id">
          <el-input :value="form.courseName" disabled></el-input>
        </el-form-item>
        <el-form-item label="选择学生" prop="studentId" v-if="!form.id">
          <el-select v-model="form.studentId" placeholder="请选择学生" filterable style="width: 100%">
            <el-option v-for="item in studentOptions" :key="item.id" :label="item.name + (item.username ? ` (${item.username})` : '')" :value="item.id"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="学生姓名" v-if="form.id">
          <el-input :value="form.studentName" disabled></el-input>
        </el-form-item>
        <el-form-item label="平时分" prop="ordinaryScore">
          <el-input-number v-model="form.ordinaryScore" :min="0" :max="100" controls-position="right" placeholder="请输入平时分" style="width: 100%"></el-input-number>
        </el-form-item>
        <el-form-item label="期末分" prop="examScore">
          <el-input-number v-model="form.examScore" :min="0" :max="100" controls-position="right" placeholder="请输入期末分" style="width: 100%"></el-input-number>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="formVisible = false">取 消</el-button>
        <el-button type="primary" @click="saveScore">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: "Score",
  data() {
    return {
      tableData: [],
      pageNum: 1,
      pageSize: 10,
      total: 0,
      user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
      searchParams: {
        courseId: null,
        studentName: null, // 用于教师/管理员按学生姓名搜索
      },
      formVisible: false,
      form: {},
      rules: {
        courseId: [
          { required: true, message: '请选择课程', trigger: 'change' }
        ],
        studentId: [
          { required: true, message: '请选择学生', trigger: 'change' }
        ],
        ordinaryScore: [
          { required: true, message: '请输入平时分', trigger: 'blur' },
          { type: 'number', message: '平时分必须为数字值'},
          { validator: (rule, value, callback) => {
              if (value < 0 || value > 100) {
                callback(new Error('分数必须在0-100之间'));
              } else {
                callback();
              }
            }, trigger: 'blur'}
        ],
        examScore: [
          { required: true, message: '请输入期末分', trigger: 'blur' },
          { type: 'number', message: '期末分必须为数字值'},
          { validator: (rule, value, callback) => {
              if (value < 0 || value > 100) {
                callback(new Error('分数必须在0-100之间'));
              } else {
                callback();
              }
            }, trigger: 'blur'}
        ]
      },
      selectedIds: [],
      courseOptions: [],      // 搜索栏用 (管理员/教师)
      teacherCourseOptions: [], // 教师弹窗用 (教师自己的课程)
      studentOptions: []        // 弹窗用
    }
  },
  computed: {
    isTeacher() {
      return this.user.role === 'TEACHER';
    },
    isStudent() {
      return this.user.role === 'STUDENT';
    },
    isAdmin() {
      return this.user.role === 'ADMIN';
    }
  },
  created() {
    this.loadInitialData(); // 加载下拉框等初始数据
    this.loadScores(1);     // 加载成绩列表
  },
  methods: {
    loadInitialData() {
      if (this.isAdmin || this.isTeacher) {
        this.loadAllCoursesForSearch();
      }
      if (this.isTeacher) {
        this.loadTeacherCoursesForForm();
      }
    },
    loadAllCoursesForSearch() {
      this.$request.get('/course/selectAll').then(res => {
        if (res.code === '200') {
          this.courseOptions = res.data;
        }
      });
    },
    loadTeacherCoursesForForm() {
      this.$request.get('/course/selectAll', { params: { teacherId: this.user.id } }).then(res => {
        if (res.code === '200') {
          this.teacherCourseOptions = res.data;
        }
      });
    },
    loadStudentsForForm() { // 当在弹窗中选择课程后调用
      // 毕业设计简化：加载所有学生。实际应加载选修了 this.form.courseId 的学生
      // 或者如果班级和课程有关联，加载对应班级的学生
      this.$request.get('/student/selectAll').then(res => {
        if (res.code === '200') {
          this.studentOptions = res.data;
        } else {
          this.studentOptions = [];
          this.$message.error('加载学生列表失败: ' + res.msg);
        }
      }).catch(err => {
        this.$message.error('加载学生列表请求失败: ' + err);
        this.studentOptions = [];
      });
    },
    handleCourseChangeForForm() {
      // 当教师在弹窗中改变课程选择时，重新加载学生列表，并清空已选学生
      this.form.studentId = null;
      if (this.form.courseId) {
        this.loadStudentsForForm();
      } else {
        this.studentOptions = [];
      }
    },
    handleAdd() {
      this.form = { teacherId: this.user.id, courseId: null, studentId: null, ordinaryScore: null, examScore: null };
      this.studentOptions = []; // 先清空，待课程选定后再加载
      this.formVisible = true;
      this.$nextTick(() => {
        this.$refs.formRef.clearValidate();
      });
    },
    handleEdit(row) {
      this.form = JSON.parse(JSON.stringify(row));
      // 编辑时不重新加载学生列表，因为学生和课程不应被修改
      this.formVisible = true;
      this.$nextTick(() => {
        this.$refs.formRef.clearValidate();
      });
    },
    saveScore() {
      this.$refs.formRef.validate((valid) => {
        if (valid) {
          // 确保 teacherId (对于新增) 和 studentId 被正确设置
          if (!this.form.id && this.isTeacher) { // 新增操作且是教师
            this.form.teacherId = this.user.id;
          }
          this.$request({
            url: this.form.id ? '/score/update' : '/score/add',
            method: this.form.id ? 'PUT' : 'POST',
            data: this.form
          }).then(res => {
            if (res.code === '200') {
              this.$message.success('操作成功');
              this.loadScores(this.form.id ? this.pageNum : 1);
              this.formVisible = false;
            } else {
              this.$message.error(res.msg);
            }
          }).catch(err => {
            this.$message.error('请求失败: ' + err);
          });
        } else {
          console.log('表单验证失败');
          return false;
        }
      });
    },
    handleDelete(id) {
      this.$confirm('您确定删除这条成绩记录吗？', '确认删除', { type: "warning" }).then(() => {
        this.$request.delete('/score/delete/' + id).then(res => {
          if (res.code === '200') {
            this.$message.success('删除成功');
            this.loadScores(this.pageNum);
          } else {
            this.$message.error(res.msg);
          }
        });
      }).catch(() => {});
    },
    handleSelectionChange(rows) {
      this.selectedIds = rows.map(v => v.id);
    },
    deleteBatch() {
      if (!this.selectedIds.length) {
        this.$message.warning('请选择要删除的成绩');
        return;
      }
      this.$confirm('您确定批量删除选中的成绩记录吗？', '确认删除', { type: "warning" }).then(() => {
        this.$request.delete('/score/delete/batch', { data: this.selectedIds }).then(res => {
          if (res.code === '200') {
            this.$message.success('批量删除成功');
            this.loadScores(1);
          } else {
            this.$message.error(res.msg);
          }
        });
      }).catch(() => {});
    },
    loadScores(pageNum) {
      if (pageNum) this.pageNum = pageNum;
      let params = {
        pageNum: this.pageNum,
        pageSize: this.pageSize,
        ...this.searchParams // 将搜索参数合并进来
      };

      if (this.isStudent) {
        params.studentId = this.user.id;
        // 学生不需要按课程或学生名搜索自己的成绩，所以移除这些搜索参数
        delete params.courseId;
        delete params.studentName;
      } else if (this.isTeacher && !this.searchParams.courseId && !this.searchParams.studentName) {
        // 如果教师没有进行任何筛选，则默认只加载与该教师相关的成绩（后端 ScoreService 已有此逻辑）
        // params.teacherId = this.user.id; // ScoreService 会自动处理
      }


      this.$request.get('/score/selectPage', { params }).then(res => {
        if (res.code === '200' && res.data) {
          this.tableData = res.data.list || [];
          this.total = res.data.total || 0;
        } else {
          this.$message.error(res.msg || '加载成绩失败');
          this.tableData = [];
          this.total = 0;
        }
      }).catch(err => {
        this.$message.error('请求成绩列表失败: ' + err);
        this.tableData = [];
        this.total = 0;
      });
    },
    resetSearch() {
      this.searchParams = {
        courseId: null,
        studentName: null,
      };
      this.loadScores(1);
    },
    resetForm() {
      if (this.$refs.formRef) {
        this.$refs.formRef.clearValidate();
        this.form = {}; // 可选：如果希望关闭时清空表单
      }
    },
    handleCurrentChange(pageNum) {
      this.loadScores(pageNum);
    }
  }
}
</script>

<style scoped>
/* 可以在这里添加一些特定的样式 */
</style>