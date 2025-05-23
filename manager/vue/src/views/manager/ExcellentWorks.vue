<template>
  <div>
    <div class="search">
      <el-input v-model="searchParams.title" placeholder="请输入作品标题搜索" style="width: 200px; margin-right: 10px;" clearable></el-input>
      <el-input v-model="searchParams.studentName" placeholder="请输入学生姓名搜索" style="width: 200px; margin-right: 10px;" clearable></el-input>
      <el-select v-model="searchParams.courseId" placeholder="关联课程" style="width: 200px; margin-right: 10px" clearable>
        <el-option v-for="item in courseOptions" :key="item.id" :label="item.name" :value="item.id"></el-option>
      </el-select>
      <el-button type="info" plain @click="loadWorks(1)">查询</el-button>
      <el-button type="warning" plain @click="resetSearch">重置</el-button>
    </div>

    <div class="operation" v-if="isAdmin || isTeacher">
      <el-button type="primary" plain @click="handleAdd">上传优秀作品</el-button>
      <el-button type="danger" plain @click="deleteBatch" :disabled="selectedIds.length === 0">批量删除</el-button>
    </div>

    <div class="table">
      <el-table :data="tableData" stripe @selection-change="handleSelectionChange">
        <el-table-column type="selection" width="55" align="center" v-if="isAdmin || isTeacher"></el-table-column>
        <el-table-column prop="id" label="序号" width="70" align="center" sortable></el-table-column>
        <el-table-column prop="title" label="作品标题" show-overflow-tooltip></el-table-column>
        <el-table-column prop="studentName" label="学生姓名" width="120"></el-table-column>
        <el-table-column prop="courseName" label="关联课程" show-overflow-tooltip></el-table-column>
        <el-table-column prop="description" label="作品描述" show-overflow-tooltip></el-table-column>
        <el-table-column label="预览/文件" width="150" align="center">
          <template v-slot="scope">
            <el-image
                v-if="isImage(scope.row.fileUrl)"
                style="width: 60px; height: 60px; border-radius: 4px; cursor: pointer;"
                :src="scope.row.fileUrl"
                :preview-src-list="[scope.row.fileUrl]"
                fit="cover">
              <div slot="error" class="image-slot">
                <i class="el-icon-picture-outline"></i>
              </div>
            </el-image>
            <el-link v-else-if="scope.row.fileUrl" :href="scope.row.fileUrl" type="primary" target="_blank" :underline="false">
              <i class="el-icon-document"></i> 查看文件
            </el-link>
            <span v-else>无文件</span>
          </template>
        </el-table-column>
        <el-table-column prop="uploaderName" label="上传者" width="120"></el-table-column>
        <el-table-column label="上传时间" width="160">
          <template v-slot="scope">{{ formatDateTime(scope.row.uploadTime) }}</template>
        </el-table-column>

        <el-table-column label="操作" width="180" align="center" v-if="isAdmin || isTeacher">
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

    <el-dialog :title="form.id ? '编辑优秀作品' : '上传优秀作品'" :visible.sync="formVisible" width="600px" :close-on-click-modal="false" destroy-on-close @close="resetForm">
      <el-form :model="form" label-width="100px" style="padding-right: 20px" :rules="rules" ref="formRef">
        <el-form-item label="作品标题" prop="title">
          <el-input v-model="form.title" placeholder="请输入作品标题"></el-input>
        </el-form-item>
        <el-form-item label="学生姓名" prop="studentName">
          <el-input v-model="form.studentName" placeholder="请输入学生姓名 (作者)"></el-input>
        </el-form-item>
        <el-form-item label="关联学生" prop="studentId">
          <el-select v-model="form.studentId" placeholder="可选，关联到特定学生" filterable clearable style="width: 100%">
            <el-option v-for="item in studentOptions" :key="item.id" :label="item.name + ' (' + item.username + ')'" :value="item.id"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="关联课程" prop="courseId">
          <el-select v-model="form.courseId" placeholder="可选，关联到特定课程" clearable style="width: 100%">
            <el-option v-for="item in courseOptions" :key="item.id" :label="item.name" :value="item.id"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="作品描述" prop="description">
          <el-input type="textarea" :rows="3" v-model="form.description" placeholder="请输入作品描述"></el-input>
        </el-form-item>
        <el-form-item label="上传文件/链接" prop="fileUrl">
          <el-input v-model="form.fileUrl" placeholder="请输入文件链接或上传文件" style="margin-bottom: 5px;"></el-input>
          <el-upload
              ref="uploadWork"
              :action="$baseUrl + '/files/upload'"
              :headers="{ token: user.token }"
              :on-success="handleWorkFileSuccess"
              :on-remove="handleWorkFileRemove"
              :file-list="workFileList"
              :limit="1"
          >
            <el-button size="small" type="primary">点击上传</el-button>
            <div slot="tip" class="el-upload__tip">可直接输入外部链接，或上传单个文件 (图片/视频/文档等，不超过100MB)</div>
          </el-upload>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="formVisible = false">取 消</el-button>
        <el-button type="primary" @click="saveWork">提 交</el-button>
      </div>
    </el-dialog>

  </div>
</template>

<script>
export default {
  name: "ExcellentWorks",
  data() {
    return {
      tableData: [],
      pageNum: 1,
      pageSize: 10,
      total: 0,
      user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
      searchParams: {
        title: null,
        studentName: null,
        courseId: null,
      },
      formVisible: false,
      form: {},
      rules: {
        title: [{ required: true, message: '请输入作品标题', trigger: 'blur' }],
        studentName: [{ required: true, message: '请输入学生姓名', trigger: 'blur' }],
        // fileUrl: [{ required: true, message: '请输入文件链接或上传文件', trigger: 'blur' }]
      },
      selectedIds: [],
      courseOptions: [],    // 所有课程
      studentOptions: [],   // 所有学生
      workFileList: [],     // el-upload
      imageExtensions: ['png', 'jpg', 'jpeg', 'gif', 'bmp', 'webp']
    };
  },
  computed: {
    isAdmin() { return this.user.role === 'ADMIN'; },
    isTeacher() { return this.user.role === 'TEACHER'; }
  },
  created() {
    this.loadInitialData();
    this.loadWorks(1);
  },
  methods: {
    loadInitialData() {
      this.$request.get('/course/selectAll').then(res => {
        if (res.code === '200') this.courseOptions = res.data || [];
      });
      this.$request.get('/student/selectAll').then(res => {
        if (res.code === '200') this.studentOptions = res.data || [];
      });
    },
    isImage(fileUrl) {
      if (!fileUrl) return false;
      const extension = fileUrl.split('.').pop().toLowerCase();
      return this.imageExtensions.includes(extension);
    },
    formatDateTime(dateTimeStr) {
      if (!dateTimeStr) return '';
      return new Date(dateTimeStr).toLocaleString();
    },
    getFileName(fileUrl) {
      if (!fileUrl) return '';
      const parts = fileUrl.substring(fileUrl.lastIndexOf('/') + 1).split('-');
      if (parts.length > 1 && /^\d+$/.test(parts[0])) { // 检查第一个部分是否纯数字时间戳
        return parts.slice(1).join('-');
      }
      return parts.join('-'); // 如果不是标准时间戳开头，返回完整文件名
    },
    handleAdd() {
      this.form = { courseId: null, studentId: null };
      this.workFileList = [];
      if (this.$refs.uploadWork) this.$refs.uploadWork.clearFiles();
      this.formVisible = true;
      this.$nextTick(() => {
        if(this.$refs.formRef) this.$refs.formRef.clearValidate();
      });
    },
    handleEdit(row) {
      this.form = JSON.parse(JSON.stringify(row));
      this.workFileList = [];
      if (this.form.fileUrl) {
        // 假设不是所有fileUrl都是通过上传得到的，可能是外部链接
        if (this.form.fileUrl.startsWith('http://' + this.$baseUrl.split('//')[1]) || this.form.fileUrl.startsWith('https://' + this.$baseUrl.split('//')[1])) {
          this.workFileList = [{ name: this.getFileName(this.form.fileUrl), url: this.form.fileUrl }];
        }
      }
      this.formVisible = true;
      this.$nextTick(() => {
        if(this.$refs.formRef) this.$refs.formRef.clearValidate();
      });
    },
    saveWork() {
      this.$refs.formRef.validate((valid) => {
        if (valid) {
          if (!this.form.fileUrl) {
            this.$message.warning('请上传作品文件或提供链接');
            return;
          }
          this.$request({
            url: this.form.id ? '/excellentWork/update' : '/excellentWork/add',
            method: this.form.id ? 'PUT' : 'POST',
            data: this.form
          }).then(res => {
            if (res.code === '200') {
              this.$message.success('操作成功');
              this.loadWorks(this.form.id ? this.pageNum : 1);
              this.formVisible = false;
            } else {
              this.$message.error(res.msg);
            }
          });
        }
      });
    },
    handleDelete(id) {
      this.$confirm('您确定删除这个优秀作品吗？', '确认删除', { type: "warning" }).then(() => {
        this.$request.delete('/excellentWork/delete/' + id).then(res => {
          if (res.code === '200') {
            this.$message.success('删除成功');
            this.loadWorks(this.pageNum);
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
        this.$message.warning('请选择要删除的作品');
        return;
      }
      this.$confirm('您确定批量删除选中的作品吗？', '确认删除', { type: "warning" }).then(() => {
        this.$request.delete('/excellentWork/delete/batch', { data: this.selectedIds }).then(res => {
          if (res.code === '200') {
            this.$message.success('批量删除成功');
            this.loadWorks(1);
          } else {
            this.$message.error(res.msg);
          }
        });
      }).catch(() => {});
    },
    loadWorks(pageNum) {
      if (pageNum) this.pageNum = pageNum;
      this.$request.get('/excellentWork/selectPage', {
        params: {
          pageNum: this.pageNum,
          pageSize: this.pageSize,
          ...this.searchParams
        }
      }).then(res => {
        if (res.code === '200' && res.data) {
          this.tableData = res.data.list || [];
          this.total = res.data.total || 0;
        } else {
          this.$message.error(res.msg || '加载优秀作品失败');
        }
      });
    },
    resetSearch() {
      this.searchParams = { title: null, studentName: null, courseId: null };
      this.loadWorks(1);
    },
    resetForm() {
      this.form = { courseId: null, studentId: null };
      this.workFileList = [];
      if (this.$refs.formRef) {
        this.$refs.formRef.clearValidate();
      }
      if (this.$refs.uploadWork) {
        this.$refs.uploadWork.clearFiles();
      }
    },
    handleCurrentChange(pageNum) {
      this.loadWorks(pageNum);
    },
    handleWorkFileSuccess(response, file, fileList) {
      if (response.code === '200') {
        this.$set(this.form, 'fileUrl', response.data);
        this.workFileList = [{ name: file.name, url: response.data }];
        this.$message.success('文件上传成功');
      } else {
        this.$message.error(response.msg || '文件上传失败');
        this.workFileList = fileList.filter(f => f.uid !== file.uid);
        if(this.$refs.uploadWork) this.$refs.uploadWork.clearFiles();
      }
    },
    handleWorkFileRemove(file, fileList) {
      this.$set(this.form, 'fileUrl', null);
      this.workFileList = fileList;
    },
    canEditOrDelete(row) {
      return this.isAdmin || (this.isTeacher && row.uploaderId === this.user.id && row.uploaderRole === this.user.role);
    }
  }
};
</script>

<style scoped>
.el-image {
  display: block; /* 确保图片居中 */
  margin: auto;
}
</style>