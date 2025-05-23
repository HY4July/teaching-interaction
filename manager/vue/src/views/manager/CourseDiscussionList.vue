<template>
  <div>
    <div class="search">
      <h3>{{ courseName }} - 讨论区</h3>
      <el-input v-model="searchTitle" placeholder="搜索主题帖标题" style="width: 250px; margin-right: 10px;" clearable @keyup.enter.native="loadTopics(1)"></el-input>
      <el-button type="primary" plain @click="loadTopics(1)">搜索</el-button>
      <el-button type="success" plain @click="openNewTopicDialog" style="margin-left: 10px;">发布新主题</el-button>
    </div>

    <div class="table">
      <el-table :data="topics" stripe v-loading="loading">
        <el-table-column label="主题" min-width="300">
          <template v-slot="scope">
            <el-link type="primary" @click="viewTopic(scope.row.id)">{{ scope.row.title }}</el-link>
          </template>
        </el-table-column>
        <el-table-column label="发起人" width="150">
          <template v-slot="scope">
            <el-avatar size="small" :src="scope.row.userAvatar || defaultAvatar" style="vertical-align: middle; margin-right: 5px;"></el-avatar>
            <span>{{ scope.row.userName }} ({{ scope.row.userRole }})</span>
          </template>
        </el-table-column>
        <el-table-column label="发布时间" width="180">
          <template v-slot="scope">
            {{ formatDateTime(scope.row.timestamp) }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="100" align="center">
          <template v-slot="scope">
            <el-button plain type="danger" size="mini" @click="deleteDiscussion(scope.row.id, true)" v-if="canDelete(scope.row)">删除</el-button>
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

    <el-dialog title="发布新主题" :visible.sync="newTopicDialogVisible" width="600px" :close-on-click-modal="false" @close="resetNewTopicForm">
      <el-form :model="newTopicForm" :rules="newTopicRules" ref="newTopicFormRef" label-width="80px">
        <el-form-item label="标题" prop="title">
          <el-input v-model="newTopicForm.title" placeholder="请输入主题标题"></el-input>
        </el-form-item>
        <el-form-item label="内容" prop="content">
          <el-input type="textarea" :rows="5" v-model="newTopicForm.content" placeholder="请输入讨论内容"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="newTopicDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="submitNewTopic">发 布</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: "CourseDiscussionList",
  props: ['courseId'], // 从路由接收 courseId
  data() {
    return {
      topics: [],
      courseName: '', // 将从后端获取或从上一页传递
      loading: false,
      pageNum: 1,
      pageSize: 10,
      total: 0,
      searchTitle: '',
      user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
      defaultAvatar: require('@/assets/imgs/default_avatar.png'), // 你需要一个默认头像图片
      newTopicDialogVisible: false,
      newTopicForm: {
        title: '',
        content: '',
      },
      newTopicRules: {
        title: [{ required: true, message: '请输入标题', trigger: 'blur' }],
        content: [{ required: true, message: '请输入内容', trigger: 'blur' }],
      }
    };
  },
  created() {
    this.fetchCourseInfo(); // 获取课程信息，例如课程名称
    this.loadTopics(1);
  },
  methods: {
    fetchCourseInfo() {
      // 如果课程名称不能直接从路由状态获取，则需要API调用
      this.$request.get('/course/selectById/' + this.courseId).then(res => {
        if(res.code === '200' && res.data) {
          this.courseName = res.data.name;
        }
      });
    },
    loadTopics(pageNum) {
      if (pageNum) this.pageNum = pageNum;
      this.loading = true;
      this.$request.get('/discussion/selectTopicsByCourseId', {
        params: {
          courseId: this.courseId,
          title: this.searchTitle,
          pageNum: this.pageNum,
          pageSize: this.pageSize,
        }
      }).then(res => {
        if (res.code === '200' && res.data) {
          this.topics = res.data.list || [];
          this.total = res.data.total || 0;
        } else {
          this.$message.error(res.msg || '加载讨论主题失败');
          this.topics = [];
          this.total = 0;
        }
      }).catch(err => {
        this.$message.error('请求讨论主题列表失败: ' + err);
      }).finally(() => {
        this.loading = false;
      });
    },
    formatDateTime(dateTimeStr) {
      if (!dateTimeStr) return '';
      const date = new Date(dateTimeStr);
      return date.toLocaleString(); // 或者使用更复杂的日期格式化库如moment.js或dayjs
    },
    canDelete(item) {
      // 管理员可以删除任何帖子，用户只能删除自己的帖子 (简单规则)
      return this.user.role === 'ADMIN' || (item.userId === this.user.id && item.userRole === this.user.role);
    },
    deleteDiscussion(id, isTopic) {
      this.$confirm(`您确定删除这个${isTopic ? '主题帖' : '回复'}吗？`, '确认删除', { type: "warning" }).then(() => {
        this.$request.delete('/discussion/delete/' + id).then(res => {
          if (res.code === '200') {
            this.$message.success('删除成功');
            if (isTopic) {
              this.loadTopics(this.pageNum);
            } else {
              // 如果是回复，需要通知父组件刷新回复列表，或者重新加载整个主题
              // 这个逻辑会在 DiscussionTopicView.vue 中处理
              this.$emit('reply-deleted'); // 假设在父组件中监听此事件
            }
          } else {
            this.$message.error(res.msg);
          }
        });
      }).catch(() => {});
    },
    handleCurrentChange(pageNum) {
      this.loadTopics(pageNum);
    },
    viewTopic(topicId) {
      this.$router.push({ name: 'DiscussionTopicView', params: { topicId: topicId } });
    },
    openNewTopicDialog() {
      this.newTopicDialogVisible = true;
    },
    resetNewTopicForm() {
      if (this.$refs.newTopicFormRef) {
        this.$refs.newTopicFormRef.resetFields();
      }
      this.newTopicForm = { title: '', content: '' };
    },
    submitNewTopic() {
      this.$refs.newTopicFormRef.validate((valid) => {
        if (valid) {
          const topicData = {
            courseId: parseInt(this.courseId), //确保是数字
            title: this.newTopicForm.title,
            content: this.newTopicForm.content,
            parentId: null, // 主题帖的parentId为null
          };
          this.$request.post('/discussion/add', topicData).then(res => {
            if (res.code === '200') {
              this.$message.success('新主题发布成功');
              this.newTopicDialogVisible = false;
              this.loadTopics(1); // 刷新列表到第一页
            } else {
              this.$message.error(res.msg || '发布失败');
            }
          }).catch(err => {
            this.$message.error('请求失败: ' + err);
          });
        }
      });
    }
  }
};
</script>

<style scoped>
.search {
  margin-bottom: 10px;
  display: flex;
  align-items: center;
}
.search h3 {
  margin-right: 20px;
}
</style>