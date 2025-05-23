<template>
  <div class="discussion-topic-view card" v-if="topic">
    <el-page-header @back="goBack" :content="topic.title || '讨论帖详情'"></el-page-header>
    <el-divider></el-divider>

    <div class="topic-main">
      <h2>{{ topic.title }}</h2>
      <div class="topic-meta">
        <el-avatar size="small" :src="topic.userAvatar || defaultAvatar"></el-avatar>
        <span class="username">{{ topic.userName }} ({{ topic.userRole }})</span>
        <span class="timestamp">{{ formatDateTime(topic.timestamp) }}</span>
      </div>
      <div class="topic-content" v-html="formatContent(topic.content)"></div>
    </div>
    <el-divider>回复列表</el-divider>

    <div class="replies-list" v-if="topic.replies && topic.replies.length">
      <div v-for="reply in topic.replies" :key="reply.id" class="reply-item">
        <discussion-reply :reply="reply" :depth="0" @reply-submitted="refreshTopic" @delete-requested="handleDeleteReply"></discussion-reply>
      </div>
    </div>
    <el-empty description="暂无回复" v-else></el-empty>

    <div class="reply-form" style="margin-top: 20px;">
      <h4>发表你的回复</h4>
      <el-form :model="newReplyForm" :rules="newReplyRules" ref="newReplyFormRef" label-width="0px">
        <el-form-item prop="content">
          <el-input type="textarea" :rows="4" v-model="newReplyForm.content" placeholder="请输入回复内容..."></el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="submitReply(null)">提交回复</el-button>
        </el-form-item>
      </el-form>
    </div>
  </div>
  <div v-else class="loading-text card">
    <p v-if="loadingError">{{ loadingError }}</p>
    <p v-else>加载中...</p>
  </div>
</template>

<script>
import DiscussionReply from '@/components/DiscussionReply.vue'; // 需要创建一个回复组件

export default {
  name: "DiscussionTopicView",
  props: ['topicId'],
  components: { DiscussionReply },
  data() {
    return {
      topic: null,
      loadingError: null,
      user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
      defaultAvatar: require('@/assets/imgs/default_avatar.png'),
      newReplyForm: {
        content: '',
      },
      newReplyRules: {
        content: [{ required: true, message: '回复内容不能为空', trigger: 'blur' }]
      }
    };
  },
  created() {
    this.fetchTopicWithReplies();
  },
  methods: {
    goBack() {
      // this.$router.go(-1); // 或者跳转到课程讨论列表页
      if (this.topic && this.topic.courseId) {
        this.$router.push({ name: 'CourseDiscussionList', params: { courseId: this.topic.courseId } });
      } else {
        this.$router.go(-1);
      }
    },
    fetchTopicWithReplies() {
      this.loadingError = null;
      this.topic = null;
      this.$request.get('/discussion/selectTopicWithReplies/' + this.topicId)
          .then(res => {
            if (res.code === '200' && res.data) {
              this.topic = res.data;
            } else {
              this.$message.error(res.msg || '加载讨论帖详情失败');
              this.loadingError = res.msg || '加载讨论帖详情失败';
            }
          })
          .catch(err => {
            this.$message.error('请求失败: ' + err);
            this.loadingError = '请求讨论帖详情失败';
          });
    },
    formatDateTime(dateTimeStr) {
      if (!dateTimeStr) return '';
      const date = new Date(dateTimeStr);
      return date.toLocaleString();
    },
    formatContent(content) { // 简单处理换行，实际可使用 markdown 渲染库
      if (!content) return '';
      return content.replace(/\n/g, '<br>');
    },
    submitReply(parentIdForReply) { // parentIdForReply 用于子回复，这里主回复 parentId 是 topicId
      this.$refs.newReplyFormRef.validate(valid => {
        if (valid) {
          const replyData = {
            courseId: this.topic.courseId,
            content: this.newReplyForm.content,
            parentId: parentIdForReply || this.topic.id, // 回复主贴或回复其他回复
          };
          this.$request.post('/discussion/add', replyData).then(res => {
            if (res.code === '200') {
              this.$message.success('回复成功');
              this.newReplyForm.content = ''; // 清空输入框
              this.$refs.newReplyFormRef.clearValidate();
              this.fetchTopicWithReplies(); // 重新加载整个主题和回复
            } else {
              this.$message.error(res.msg || '回复失败');
            }
          });
        }
      });
    },
    refreshTopic(){
      this.fetchTopicWithReplies();
    },
    handleDeleteReply(replyId){ // 这个方法会被 DiscussionReply 组件调用
      this.$request.delete('/discussion/delete/' + replyId).then(res => {
        if (res.code === '200') {
          this.$message.success('删除成功');
          this.fetchTopicWithReplies();
        } else {
          this.$message.error(res.msg);
        }
      });
    }
  }
};
</script>

<style scoped>
.discussion-topic-view {
  padding: 20px;
}
.topic-main {
  margin-bottom: 20px;
}
.topic-main h2 {
  margin-bottom: 10px;
}
.topic-meta {
  font-size: 0.9em;
  color: #888;
  margin-bottom: 15px;
  display: flex;
  align-items: center;
}
.topic-meta .username {
  margin-right: 10px;
  margin-left: 5px;
}
.topic-content {
  line-height: 1.8;
  word-break: break-word;
}
.replies-list .reply-item {
  border-bottom: 1px solid #eee;
  padding: 15px 0;
}
.replies-list .reply-item:last-child {
  border-bottom: none;
}
.loading-text {
  text-align: center;
  padding: 20px;
  color: #909399;
}
</style>