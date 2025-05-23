<template>
  <div>
    <div class="search" v-if="!isStudent"> <el-select v-model="searchParams.courseId" placeholder="请选择课程筛选" style="width: 220px; margin-right: 10px" clearable @change="loadHomeworks(1)">
      <el-option v-for="item in courseOptions" :key="item.id" :label="item.name" :value="item.id"></el-option>
    </el-select>
      <el-input v-if="isTeacher || isAdmin" v-model="searchParams.studentName" placeholder="请输入学生姓名搜索" style="width: 200px;" clearable @input="loadHomeworks(1)"></el-input>
      <el-button type="info" plain style="margin-left: 10px" @click="loadHomeworks(1)">查询</el-button>
      <el-button type="warning" plain style="margin-left: 10px" @click="resetSearch">重置</el-button>
    </div>

    <div class="operation" v-if="isStudent">
      <el-button type="primary" plain @click="handleStudentSubmit">提交新作业</el-button>
    </div>

    <div class="table">
      <el-table :data="tableData" stripe @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" v-if="isTeacher"></el-table-column> <el-table-column prop="id" label="序号" width="70" align="center" sortable></el-table-column>
        <el-table-column prop="courseName" label="课程名称" show-overflow-tooltip></el-table-column>
        <el-table-column prop="studentName" label="学生姓名" show-overflow-tooltip v-if="!isStudent"></el-table-column>
        <el-table-column prop="content" label="作业说明/内容" show-overflow-tooltip></el-table-column>
        <el-table-column label="作业文件" width="150">
          <template v-slot="scope">
            <el-link v-if="scope.row.file" :href="scope.row.file" type="primary" target="_blank" :underline="false">
              <i class="el-icon-document"></i> 查看/下载
            </el-link>
            <span v-else>未上传</span>
          </template>
        </el-table-column>
        <el-table-column prop="score" label="得分" width="80"></el-table-column>
        <el-table-column prop="descr" label="教师评语" show-overflow-tooltip></el-table-column>

        <el-table-column label="操作" width="180" align="center">
          <template v-slot="scope">
            <el-button plain type="primary" @click="handleViewOrGrade(scope.row)" size="mini" v-if="isTeacher">批改/查看</el-button>
            <el-button plain type="primary" @click="handleViewDetails(scope.row)" size="mini" v-if="isStudent">查看详情</el-button>
            <el-button plain type="danger" size="mini" @click="handleDelete(scope.row.id)" v-if="isTeacher || (isStudent && !scope.row.score)">删除</el-button> </template>
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

    <el-dialog :title="dialogTitle" :visible.sync="formVisible" width="550px" :close-on-click-modal="false" destroy-on-close @close="resetForm">
      <el-form :model="form" label-width="100px" style="padding-right: 20px" :rules="rules" ref="formRef">
        <el-form-item label="选择课程" prop="courseId" v-if="isStudent && !form.id">
          <el-select v-model="form.courseId" placeholder="请选择课程" style="width: 100%">
            <el-option v-for="item in studentCourseOptions" :key="item.id" :label="item.name" :value="item.id"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="课程名称" v-if="form.id || (isTeacher && form.courseName)">
          <el-input :value="form.courseName" disabled></el-input>
        </el-form-item>
        <el-form-item label="学生姓名" v-if="(isTeacher || isAdmin) && form.studentName">
          <el-input :value="form.studentName" disabled></el-input>
        </el-form-item>
        <el-form-item label="作业说明" prop="content" :rules="isStudent ? rules.content : []">
          <el-input type="textarea" :rows="3" v-model="form.content" placeholder="请输入作业说明或内容" :disabled="isTeacher && form.id"></el-input>
        </el-form-item>
        <el-form-item label="上传作业" prop="file" v-if="isStudent && !form.id">
          <el-upload
              class="upload-demo"
              :action="$baseUrl + '/files/upload'"
              :headers="{ token: user.token }"
              :on-success="handleFileSuccess"
              :on-remove="handleFileRemove"
              :file-list="fileList"
              :limit="1"
              list-type="text">
            <el-button size="small" type="primary">点击上传</el-button>
            <div slot="tip" class="el-upload__tip">只能上传一个文件，大小不超过100MB</div>
          </el-upload>
        </el-form-item>
        <el-form-item label="已上传文件" v-if="form.id && form.file">
          <el-link :href="form.file" type="primary" target="_blank" :underline="false">
            {{ getFileName(form.file) }} <i class="el-icon-download"></i>
          </el-link>
        </el-form-item>

        <div v-if="isTeacher && form.id">
          <el-divider content-position="left">教师批改</el-divider>
          <el-form-item label="打分" prop="score">
            <el-input v-model="form.score" placeholder="请输入分数 (如：优秀,良好,A+,85等)"></el-input>
          </el-form-item>
          <el-form-item label="评语" prop="descr">
            <el-input type="textarea" :rows="3" v-model="form.descr" placeholder="请输入评语"></el-input>
          </el-form-item>
        </div>
        <div v-if="isStudent && form.id && form.score">
          <el-divider content-position="left">教师评阅</el-divider>
          <el-form-item label="得分">
            <el-input :value="form.score" disabled></el-input>
          </el-form-item>
          <el-form-item label="评语">
            <el-input type="textarea" :value="form.descr" disabled></el-input>
          </el-form-item>
        </div>

      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="formVisible = false">关 闭</el-button>
        <el-button type="primary" @click="saveHomework" v-if="!isStudent || (isStudent && !form.id)">提 交</el-button> <el-button type="primary" @click="saveHomework" v-if="isTeacher && form.id">保存批改</el-button> </div>
    </el-dialog>

  </div>
</template>

<script>
export default {
  name: "Homework",
  data() {
    return {
      tableData: [],
      pageNum: 1,
      pageSize: 10,
      total: 0,
      user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
      searchParams: {
        courseId: null,
        studentName: null,
      },
      formVisible: false,
      form: {}, // 表单数据
      dialogTitle: '作业信息',
      rules: { // 学生提交作业时的规则
        courseId: [ { required: true, message: '请选择课程', trigger: 'change' } ],
        content: [ { required: true, message: '请输入作业说明', trigger: 'blur' } ],
        // file 字段的校验通常由 el-upload 组件处理，或在提交前检查 this.form.file 是否为空
      },
      selectedIds: [],
      courseOptions: [],        // 教师/管理员搜索用
      studentCourseOptions: [], // 学生提交作业时选择的课程（应为学生已选课程）
      fileList: [],             // el-upload 的文件列表
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
    this.loadInitialData();
    this.loadHomeworks(1);
  },
  methods: {
    loadInitialData() {
      if (this.isTeacher || this.isAdmin) {
        this.loadAllCoursesForSearch(); // 教师和管理员加载所有课程用于筛选
      }
      if (this.isStudent) {
        this.loadStudentCoursesForSubmit(); // 学生加载可选的课程用于提交作业
      }
    },
    loadAllCoursesForSearch() {
      this.$request.get('/course/selectAll').then(res => {
        if (res.code === '200') this.courseOptions = res.data || [];
      });
    },
    loadStudentCoursesForSubmit() {
      // TODO: 学生应加载自己已选修且可以提交作业的课程列表
      // 简化：暂时加载所有课程，实际应有选课关联
      this.$request.get('/course/selectAll').then(res => {
        if (res.code === '200') this.studentCourseOptions = res.data || [];
      });
    },
    getFileName(fileUrl) {
      if (!fileUrl) return '';
      return fileUrl.substring(fileUrl.lastIndexOf('/') + 1).substring(14); // 移除时间戳前缀
    },
    handleStudentSubmit() {
      this.form = { studentId: this.user.id }; // 自动填充学生ID
      this.dialogTitle = '提交新作业';
      this.fileList = [];
      this.formVisible = true;
      this.$nextTick(() => {
        if(this.$refs.formRef) this.$refs.formRef.clearValidate();
      });
    },
    handleViewOrGrade(row) { // 教师批改或查看
      this.form = JSON.parse(JSON.stringify(row));
      this.dialogTitle = '批改作业 - ' + row.studentName + ' - ' + row.courseName;
      this.fileList = row.file ? [{ name: this.getFileName(row.file), url: row.file }] : [];
      this.formVisible = true;
    },
    handleViewDetails(row) { // 学生查看自己的作业详情
      this.form = JSON.parse(JSON.stringify(row));
      this.dialogTitle = '作业详情 - ' + row.courseName;
      this.fileList = row.file ? [{ name: this.getFileName(row.file), url: row.file }] : [];
      this.formVisible = true;
    },
    saveHomework() {
      this.$refs.formRef.validate((valid) => {
        if (valid) {
          let url = this.form.id ? '/homework/update' : '/homework/add';
          let method = this.form.id ? 'PUT' : 'POST';

          // 学生提交时，确保 file 字段有值 (如果文件是必需的)
          if (this.isStudent && !this.form.id && !this.form.file) {
            this.$message.warning('请上传作业文件');
            return;
          }

          this.$request({ url, method, data: this.form }).then(res => {
            if (res.code === '200') {
              this.$message.success('操作成功');
              this.loadHomeworks(this.form.id ? this.pageNum : 1);
              this.formVisible = false;
            } else {
              this.$message.error(res.msg);
            }
          }).catch(err => {
            this.$message.error('请求失败: ' + err);
          });
        }
      });
    },
    handleDelete(id) {
      this.$confirm('您确定删除这份作业吗？', '确认删除', { type: "warning" }).then(() => {
        this.$request.delete('/homework/delete/' + id).then(res => {
          if (res.code === '200') {
            this.$message.success('删除成功');
            this.loadHomeworks(this.pageNum);
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
        this.$message.warning('请选择要删除的作业');
        return;
      }
      this.$confirm('您确定批量删除选中的作业吗？', '确认删除', { type: "warning" }).then(() => {
        this.$request.delete('/homework/delete/batch', { data: this.selectedIds }).then(res => {
          if (res.code === '200') {
            this.$message.success('批量删除成功');
            this.loadHomeworks(1);
          } else {
            this.$message.error(res.msg);
          }
        });
      }).catch(() => {});
    },
    loadHomeworks(pageNum) {
      if (pageNum) this.pageNum = pageNum;
      let params = {
        pageNum: this.pageNum,
        pageSize: this.pageSize,
        ...this.searchParams // 合并搜索栏的 courseId 和 studentName
      };

      if (this.isStudent) {
        params.studentId = this.user.id;
        delete params.courseId; // 学生查看自己所有作业，课程筛选在弹窗选择
        delete params.studentName;
      } else if (this.isTeacher) {
        // 后端HomeworkService已有逻辑，会根据当前登录教师ID筛选
      }

      this.$request.get('/homework/selectPage', { params }).then(res => {
        if (res.code === '200' && res.data) {
          this.tableData = res.data.list || [];
          this.total = res.data.total || 0;
        } else {
          this.$message.error(res.msg || '加载作业列表失败');
          this.tableData = [];
          this.total = 0;
        }
      }).catch(err => {
        this.$message.error('请求作业列表失败: ' + err);
        this.tableData = [];
        this.total = 0;
      });
    },
    resetSearch() {
      this.searchParams = { courseId: null, studentName: null };
      this.loadHomeworks(1);
    },
    resetForm() {
      this.form = {};
      this.fileList = [];
      if (this.$refs.formRef) {
        this.$refs.formRef.clearValidate();
      }
    },
    handleCurrentChange(pageNum) {
      this.loadHomeworks(pageNum);
    },
    handleFileSuccess(response, file, fileList) {
      if (response.code === '200') {
        this.form.file = response.data; // 假设后端返回的文件URL在response.data中
        this.fileList = fileList;
        this.$message.success('文件上传成功');
      } else {
        this.$message.error(response.msg || '文件上传失败');
        this.fileList = fileList.filter(f => f.uid !== file.uid); // 移除上传失败的文件
      }
    },
    handleFileRemove(file, fileList) {
      this.form.file = null;
      this.fileList = fileList;
    },
  }
}
</script>

<style scoped>
.upload-demo {
  width: 100%;
}
</style>