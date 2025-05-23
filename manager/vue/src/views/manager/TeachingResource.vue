<template>
  <div>
    <div class="search">
      <el-input v-model="searchParams.name" placeholder="请输入资源名称搜索" style="width: 200px; margin-right: 10px;" clearable></el-input>
      <el-select v-model="searchParams.category" placeholder="请选择资源分类" style="width: 180px; margin-right: 10px" clearable>
        <el-option label="课件" value="课件"></el-option>
        <el-option label="视频" value="视频"></el-option>
        <el-option label="习题" value="习题"></el-option>
        <el-option label="案例" value="案例"></el-option>
        <el-option label="其他" value="其他"></el-option>
      </el-select>
      <el-select v-model="searchParams.courseId" placeholder="关联课程" style="width: 200px; margin-right: 10px" clearable v-if="!isStudent"> <el-option v-for="item in courseOptions" :key="item.id" :label="item.name" :value="item.id"></el-option>
      </el-select>
      <el-button type="info" plain @click="loadResources(1)">查询</el-button>
      <el-button type="warning" plain @click="resetSearch">重置</el-button>
    </div>

    <div class="operation" v-if="isTeacher">
      <el-button type="primary" plain @click="handleAdd">上传新资源</el-button>
      <el-button type="danger" plain @click="deleteBatch" :disabled="selectedIds.length === 0">批量删除</el-button>
    </div>

    <div class="table">
      <el-table :data="tableData" stripe @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" v-if="isTeacher || isAdmin"></el-table-column>
        <el-table-column prop="id" label="序号" width="70" align="center" sortable></el-table-column>
        <el-table-column prop="name" label="资源名称" show-overflow-tooltip></el-table-column>
        <el-table-column prop="category" label="分类" width="100"></el-table-column>
        <el-table-column prop="courseName" label="关联课程" show-overflow-tooltip></el-table-column>
        <el-table-column prop="description" label="描述" show-overflow-tooltip></el-table-column>
        <el-table-column prop="uploaderName" label="上传教师" width="120"></el-table-column>
        <el-table-column label="上传时间" width="160">
          <template v-slot="scope">{{ formatDateTime(scope.row.uploadTime) }}</template>
        </el-table-column>
        <el-table-column label="文件" width="120" align="center">
          <template v-slot="scope">
            <el-link v-if="scope.row.fileUrl" :href="scope.row.fileUrl" type="primary" target="_blank" :underline="false">
              <i class="el-icon-download"></i> 下载/查看
            </el-link>
            <span v-else>无文件</span>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="180" align="center" v-if="isTeacher || isAdmin">
          <template v-slot="scope">
            <el-button plain type="primary" @click="handleEdit(scope.row)" size="mini" v-if="canEditOrDelete(scope.row)">编辑</el-button>
            <el-button plain type="danger" size="mini" @click="handleDelete(scope.row.id)" v-if="canEditOrDelete(scope.row)">删除</el-button>
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

    <el-dialog :title="form.id ? '编辑教学资源' : '上传新资源'" :visible.sync="formVisible" width="550px" :close-on-click-modal="false" destroy-on-close @close="resetForm">
      <el-form :model="form" label-width="100px" style="padding-right: 20px" :rules="rules" ref="formRef">
        <el-form-item label="资源名称" prop="name">
          <el-input v-model="form.name" placeholder="请输入资源名称"></el-input>
        </el-form-item>
        <el-form-item label="资源分类" prop="category">
          <el-select v-model="form.category" placeholder="请选择资源分类" style="width: 100%">
            <el-option label="课件" value="课件"></el-option>
            <el-option label="视频" value="视频"></el-option>
            <el-option label="习题" value="习题"></el-option>
            <el-option label="案例" value="案例"></el-option>
            <el-option label="其他" value="其他"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="关联课程" prop="courseId">
          <el-select v-model="form.courseId" placeholder="可选，关联到特定课程" style="width: 100%" clearable>
            <el-option v-for="item in teacherCourseOptions" :key="item.id" :label="item.name" :value="item.id"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="资源描述" prop="description">
          <el-input type="textarea" :rows="3" v-model="form.description" placeholder="请输入资源描述"></el-input>
        </el-form-item>
        <el-form-item label="上传文件" prop="fileUrl">
          <el-upload
              ref="upload"
              :action="$baseUrl + '/files/upload'"
              :headers="{ token: user.token }"
              :on-success="handleFileSuccess"
              :on-remove="handleFileRemove"
              :before-upload="beforeFileUpload"
              :file-list="fileList"
              :limit="1"
          >
            <el-button size="small" type="primary">点击上传</el-button>
            <div slot="tip" class="el-upload__tip">上传单个文件，大小不超过100MB</div>
          </el-upload>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="formVisible = false">取 消</el-button>
        <el-button type="primary" @click="saveResource">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: "TeachingResource",
  data() {
    return {
      tableData: [],
      pageNum: 1,
      pageSize: 10,
      total: 0,
      user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
      searchParams: {
        name: null,
        category: null,
        courseId: null,
      },
      formVisible: false,
      form: {},
      rules: {
        name: [{ required: true, message: '请输入资源名称', trigger: 'blur' }],
        category: [{ required: true, message: '请选择资源分类', trigger: 'change' }],
        // fileUrl: [{ required: true, message: '请上传文件', trigger: 'blur' }] // 文件通过上传组件控制
      },
      selectedIds: [],
      courseOptions: [], // 所有课程，用于管理员和教师搜索
      teacherCourseOptions: [], // 当前教师的课程，用于弹窗中关联课程
      fileList: [], // 用于el-upload
    };
  },
  computed: {
    isTeacher() { return this.user.role === 'TEACHER'; },
    isAdmin() { return this.user.role === 'ADMIN'; },
    isStudent() { return this.user.role === 'STUDENT'; }
  },
  created() {
    this.loadInitialData();
    this.loadResources(1);
  },
  methods: {
    loadInitialData() {
      // 加载所有课程给教师和管理员用于搜索和弹窗中的关联课程选择
      this.$request.get('/course/selectAll').then(res => {
        if (res.code === '200') {
          this.courseOptions = res.data || [];
          // 教师在上传/编辑时，关联课程下拉框也用所有课程，或者只用自己的课程
          if (this.isTeacher) {
            this.teacherCourseOptions = res.data.filter(c => c.teacherId === this.user.id) || [];
          } else {
            this.teacherCourseOptions = res.data || [];
          }
        }
      });
    },
    formatDateTime(dateTimeStr) {
      if (!dateTimeStr) return '';
      return new Date(dateTimeStr).toLocaleString();
    },
    getFileName(fileUrl) {
      if (!fileUrl) return '';
      // 移除时间戳和连接符，例如 1697438073596-avatar.png -> avatar.png
      const parts = fileUrl.substring(fileUrl.lastIndexOf('/') + 1).split('-');
      if (parts.length > 1) {
        return parts.slice(1).join('-');
      }
      return parts[0];
    },
    handleAdd() {
      this.form = { category: null, courseId: null }; // 清空表单
      this.fileList = [];
      if (this.$refs.upload) this.$refs.upload.clearFiles(); // 清除el-upload的已上传列表
      this.formVisible = true;
      this.$nextTick(() => {
        if(this.$refs.formRef) this.$refs.formRef.clearValidate();
      });
    },
    handleEdit(row) {
      this.form = JSON.parse(JSON.stringify(row));
      this.fileList = [];
      if (this.form.fileUrl) {
        this.fileList = [{ name: this.getFileName(this.form.fileUrl), url: this.form.fileUrl }];
      }
      this.formVisible = true;
      this.$nextTick(() => {
        if(this.$refs.formRef) this.$refs.formRef.clearValidate();
      });
    },
    saveResource() {
      this.$refs.formRef.validate((valid) => {
        if (valid) {
          if (!this.form.fileUrl && !this.form.id) { // 新增时必须有文件
            this.$message.warning('请上传资源文件');
            return;
          }
          this.$request({
            url: this.form.id ? '/teachingResource/update' : '/teachingResource/add',
            method: this.form.id ? 'PUT' : 'POST',
            data: this.form
          }).then(res => {
            if (res.code === '200') {
              this.$message.success('操作成功');
              this.loadResources(this.form.id ? this.pageNum : 1);
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
      this.$confirm('您确定删除这个教学资源吗？', '确认删除', { type: "warning" }).then(() => {
        this.$request.delete('/teachingResource/delete/' + id).then(res => {
          if (res.code === '200') {
            this.$message.success('删除成功');
            this.loadResources(this.pageNum);
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
        this.$message.warning('请选择要删除的资源');
        return;
      }
      this.$confirm('您确定批量删除选中的资源吗？', '确认删除', { type: "warning" }).then(() => {
        this.$request.delete('/teachingResource/delete/batch', { data: this.selectedIds }).then(res => {
          if (res.code === '200') {
            this.$message.success('批量删除成功');
            this.loadResources(1);
          } else {
            this.$message.error(res.msg);
          }
        });
      }).catch(() => {});
    },
    loadResources(pageNum) {
      if (pageNum) this.pageNum = pageNum;
      let params = {
        pageNum: this.pageNum,
        pageSize: this.pageSize,
        ...this.searchParams
      };
      // 如果是教师，并且没有指定搜索uploaderId（通过searchParams），则默认查询自己的
      if (this.isTeacher && !params.uploaderId) {
        // 后端Service层会处理 teacherId:this.user.id
        // params.uploaderId = this.user.id;
      }

      this.$request.get('/teachingResource/selectPage', { params }).then(res => {
        if (res.code === '200' && res.data) {
          this.tableData = res.data.list || [];
          this.total = res.data.total || 0;
        } else {
          this.$message.error(res.msg || '加载教学资源失败');
          this.tableData = [];
          this.total = 0;
        }
      }).catch(err => {
        this.$message.error('请求教学资源列表失败: ' + err);
        this.tableData = [];
        this.total = 0;
      });
    },
    resetSearch() {
      this.searchParams = { name: null, category: null, courseId: null };
      this.loadResources(1);
    },
    resetForm() {
      this.form = { category: null, courseId: null };
      this.fileList = [];
      if (this.$refs.formRef) {
        this.$refs.formRef.clearValidate();
      }
      if (this.$refs.upload) {
        this.$refs.upload.clearFiles();
      }
    },
    handleCurrentChange(pageNum) {
      this.loadResources(pageNum);
    },
    handleFileSuccess(response, file, fileList) {
      if (response.code === '200') {
        this.$set(this.form, 'fileUrl', response.data); // 确保响应式更新
        this.fileList = [{ name: file.name, url: response.data }]; // 只显示当前成功上传的文件
        this.$message.success('文件上传成功');
      } else {
        this.$message.error(response.msg || '文件上传失败');
        this.fileList = fileList.filter(f => f.uid !== file.uid);
        if(this.$refs.upload) this.$refs.upload.clearFiles(); // 清除失败的文件
      }
    },
    handleFileRemove(file, fileList) {
      this.$set(this.form, 'fileUrl', null);
      this.fileList = fileList;
    },
    beforeFileUpload(file) {
      // 可在此处添加文件大小或类型的校验
      const isLt100M = file.size / 1024 / 1024 < 100;
      if (!isLt100M) {
        this.$message.error('上传文件大小不能超过 100MB!');
      }
      return isLt100M;
    },
    canEditOrDelete(row) {
      return this.isAdmin || (this.isTeacher && row.uploaderId === this.user.id);
    }
  }
};
</script>

<style scoped>
.upload-demo {
  width: 100%;
}
</style>