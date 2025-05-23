<template>
  <div>
    <div class="search" v-if="!isStudent">
      <el-input placeholder="请输入标题查询" style="width: 200px; margin-right: 10px;" v-model="searchParams.title"></el-input>
      <el-button type="info" plain style="margin-left: 10px" @click="loadNotices(1)">查询</el-button>
      <el-button type="warning" plain style="margin-left: 10px" @click="resetSearch">重置</el-button>
    </div>

    <div class="operation" v-if="isAdmin || isTeacher">
      <el-button type="primary" plain @click="handleAdd">发布新公告</el-button>
    </div>

    <div class="notice-list" style="margin-top: 15px;">
      <el-row :gutter="20">
        <el-col :span="24" v-for="item in tableData" :key="item.id" style="margin-bottom: 20px;">
          <el-card class="box-card notice-card">
            <div slot="header" class="clearfix">
              <span style="font-weight: bold; font-size: 1.1em;">{{ item.title }}</span>
              <div style="float: right; padding: 3px 0">
                <span class="notice-meta">发布人: {{ item.user }}</span>
                <span class="notice-meta">发布时间: {{ item.time }}</span>
                <el-button style="margin-left: 10px;" type="text" icon="el-icon-edit" v-if="canEditOrDelete(item)" @click="handleEdit(item)" :disabled="!canEditOrDelete(item)">编辑</el-button>
                <el-button type="text" icon="el-icon-delete" style="color: #F56C6C;" v-if="canEditOrDelete(item)" @click="deleteNotice(item.id)" :disabled="!canEditOrDelete(item)">删除</el-button>
              </div>
            </div>
            <div class="notice-content" v-html="formatNoticeContent(item.content)">
            </div>
          </el-card>
        </el-col>
      </el-row>
      <el-empty v-if="!tableData.length && !loading" description="暂无公告"></el-empty>
    </div>

    <div class="pagination" v-if="total > 0">
      <el-pagination
          background
          @current-change="handleCurrentChange"
          :current-page="pageNum"
          :page-size="pageSize"
          layout="total, prev, pager, next"
          :total="total">
      </el-pagination>
    </div>

    <el-dialog :title="form.id ? '编辑公告' : '发布新公告'" :visible.sync="formVisible" width="60%" :close-on-click-modal="false" destroy-on-close @close="resetForm">
      <el-form :model="form" label-width="80px" style="padding-right: 20px" :rules="rules" ref="formRef">
        <el-form-item label="标题" prop="title">
          <el-input v-model="form.title" autocomplete="off" placeholder="请输入公告标题"></el-input>
        </el-form-item>
        <el-form-item label="内容" prop="content">
          <el-input type="textarea" :rows="10" v-model="form.content" autocomplete="off" placeholder="请输入公告内容"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="formVisible = false">取 消</el-button>
        <el-button type="primary" @click="saveNotice">确 定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: "Notice",
  data() {
    return {
      tableData: [],
      pageNum: 1,
      pageSize: 10, // 可以根据需要调整每页显示的公告数量
      total: 0,
      loading: false, // 用于控制加载状态
      searchParams: { // 统一搜索参数
        title: null,
      },
      formVisible: false,
      form: {},
      user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
      rules: {
        title: [
          { required: true, message: '请输入标题', trigger: 'blur' },
          { min: 2, max: 100, message: '长度在 2 到 100 个字符', trigger: 'blur' }
        ],
        content: [
          { required: true, message: '请输入内容', trigger: 'blur' },
        ]
      },
      // selectedIds: [], // 如果不使用批量删除，可以移除
    };
  },
  computed: {
    isAdmin() { return this.user.role === 'ADMIN'; },
    isTeacher() { return this.user.role === 'TEACHER'; },
    isStudent() { return this.user.role === 'STUDENT'; }
  },
  created() {
    this.loadNotices(1);
  },
  methods: {
    formatNoticeContent(content) {
      if (!content) return '';
      // 将换行符替换为<br>以在HTML中正确显示，同时避免XSS（虽然此处是内部系统，风险较低）
      // 更安全的方式是使用专门的库来处理富文本或Markdown，但对于简单文本，这样基本可行
      return String(content).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#039;').replace(/\n/g, '<br>');
    },
    canEditOrDelete(notice) {
      // 管理员可以编辑/删除所有公告
      // 教师只能编辑/删除自己发布的公告
      return this.isAdmin || (this.isTeacher && notice.user === this.user.username);
    },
    handleAdd() {
      this.form = {};
      this.formVisible = true;
      this.$nextTick(() => {
        if(this.$refs.formRef) this.$refs.formRef.clearValidate();
      });
    },
    handleEdit(row) {
      this.form = JSON.parse(JSON.stringify(row));
      this.formVisible = true;
      this.$nextTick(() => {
        if(this.$refs.formRef) this.$refs.formRef.clearValidate();
      });
    },
    saveNotice() {
      this.$refs.formRef.validate((valid) => {
        if (valid) {
          // 如果是新增，后端Service会自动设置 user 和 time
          this.$request({
            url: this.form.id ? '/notice/update' : '/notice/add',
            method: this.form.id ? 'PUT' : 'POST',
            data: this.form
          }).then(res => {
            if (res.code === '200') {
              this.$message.success('操作成功');
              this.loadNotices(this.form.id ? this.pageNum : 1); // 编辑时留在当前页，新增时到第一页
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
    deleteNotice(id) {
      this.$confirm('您确定删除这条公告吗？', '确认删除', { type: "warning" }).then(() => {
        this.$request.delete('/notice/delete/' + id).then(res => {
          if (res.code === '200') {
            this.$message.success('删除成功');
            // 如果删除后当前页没有数据了，且不是第一页，则加载前一页
            if (this.tableData.length === 1 && this.pageNum > 1) {
              this.pageNum--;
            }
            this.loadNotices(this.pageNum);
          } else {
            this.$message.error(res.msg);
          }
        });
      }).catch(() => {});
    },
    // 如果不需要批量删除，可以注释或移除以下两个方法
    // handleSelectionChange(rows) {
    //   this.selectedIds = rows.map(v => v.id);
    // },
    // delBatch() {
    //   if (!this.selectedIds.length) {
    //     this.$message.warning('请选择数据');
    //     return;
    //   }
    //   this.$confirm('您确定批量删除这些数据吗？', '确认删除', {type: "warning"}).then(() => {
    //     this.$request.delete('/notice/delete/batch', {data: this.selectedIds}).then(res => {
    //       if (res.code === '200') {
    //         this.$message.success('操作成功');
    //         this.loadNotices(1);
    //       } else {
    //         this.$message.error(res.msg);
    //       }
    //     });
    //   }).catch(() => {});
    // },
    loadNotices(pageNum) {
      if (pageNum) this.pageNum = pageNum;
      this.loading = true;
      this.$request.get('/notice/selectPage', {
        params: {
          pageNum: this.pageNum,
          pageSize: this.pageSize,
          title: this.searchParams.title, // 使用 searchParams
        }
      }).then(res => {
        if (res.code === '200' && res.data) {
          this.tableData = res.data.list || [];
          this.total = res.data.total || 0;
        } else {
          this.$message.error(res.msg || '加载公告列表失败');
          this.tableData = [];
          this.total = 0;
        }
      }).finally(() => {
        this.loading = false;
      });
    },
    resetSearch() {
      this.searchParams.title = null;
      this.loadNotices(1);
    },
    resetForm() {
      this.form = {};
      if (this.$refs.formRef) {
        this.$refs.formRef.clearValidate();
      }
    },
    handleCurrentChange(pageNum) {
      this.loadNotices(pageNum);
    },
  }
};
</script>

<style scoped>
.notice-list .el-card {
  margin-bottom: 15px;
  border: 1px solid #EBEEF5;
  box-shadow: 0 2px 12px 0 rgba(0,0,0,.1);
}
.notice-list .clearfix:before,
.notice-list .clearfix:after {
  display: table;
  content: "";
}
.notice-list .clearfix:after {
  clear: both
}
.notice-card .el-card__header { /* Element UI 默认 card header padding 较大 */
  padding: 10px 20px;
}
.notice-meta {
  font-size: 12px;
  color: #909399;
  margin-right: 15px;
}
.notice-content {
  font-size: 14px;
  line-height: 1.8;
  color: #303133; /* 内容颜色深一些 */
  padding-top: 10px;
}
.search, .operation {
  margin-bottom: 10px;
}
</style>