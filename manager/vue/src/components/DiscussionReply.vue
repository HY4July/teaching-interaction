<template>
  <div class="discussion-reply" :style="{ 'margin-left': depth * 20 + 'px' }">
    <div class="reply-meta">
      <el-avatar size="small" :src="reply.userAvatar || defaultAvatar"></el-avatar>
      <strong class="username">{{ reply.userName }} ({{reply.userRole}})</strong>
      <span class="timestamp">{{ formatDateTime(reply.timestamp) }}</span>
      <el-button type="text" size="mini" @click="showReplyForm = !showReplyForm" style="margin-left: 10px;">回复</el-button>
      <el-button type="text" size="mini" @click="deleteThisReply" style="margin-left: 5px; color: #F56C6C;" v-if="canDelete">删除</el-button>
    </div>
    <div class="reply-content" v-html="formatContent(reply.content)"></div>

    <div v-if="showReplyForm" class="sub-reply-form" style="margin-top: 10px; margin-left: 20px;">
      <el-input type="textarea" :rows="2" v-model="subReplyContent" :placeholder="'回复 @' + reply.userName"></el-input>
      <el-button type="primary" size="mini" @click="submitSubReply" style="margin-top: 5px;">提交</el-button>
      <el-button size="mini" @click="showReplyForm = false" style="margin-top: 5px;">取消</el-button>
    </div>

    <div v-if="reply.replies && reply.replies.length" class="sub-replies" style="margin-top:10px;">
      <discussion-reply
          v-for="subReply in reply.replies"
          :key="subReply.id"
          :reply="subReply"
          :depth="depth + 1"
          @reply-submitted="$emit('reply-submitted')"
          @delete-requested="$emit('delete-requested', $event)"
      ></discussion-reply>
    </div>
  </div>
</template>

<script>
export default {
  name: "DiscussionReply",
  props: {
    reply: Object,
    depth: Number, // 用于控制缩进
  },
  data() {
    return {
      user: JSON.parse(localStorage.getItem('xm-user') || '{}'),
      defaultAvatar: require('@/assets/imgs/default_avatar.png'),
      showReplyForm: false,
      subReplyContent: ''
    };
  },
  computed: {
    canDelete() {
      return this.user.role === 'ADMIN' || (this.reply.userId === this.user.id && this.reply.userRole === this.user.role);
    }
  },
  methods: {
    formatDateTime(dateTimeStr) {
      if (!dateTimeStr) return '';
      const date = new Date(dateTimeStr);
      return date.toLocaleString();
    },
    formatContent(content) {
      if (!content) return '';
      return content.replace(/\n/g, '<br>');
    },
    submitSubReply() {
      if (!this.subReplyContent.trim()) {
        this.$message.warning('回复内容不能为空');
        return;
      }
      const replyData = {
        courseId: this.reply.courseId, // 假设回复也需要courseId，从父级reply获取
        content: this.subReplyContent,
        parentId: this.reply.id, // 回复当前这条回复
      };
      this.$request.post('/discussion/add', replyData).then(res => {
        if (res.code === '200') {
          this.$message.success('回复成功');
          this.subReplyContent = '';
          this.showReplyForm = false;
          this.$emit('reply-submitted'); // 通知父组件刷新
        } else {
          this.$message.error(res.msg || '回复失败');
        }
      });
    },
    deleteThisReply() {
      this.$confirm('您确定删除这条回复吗？', '确认删除', { type: "warning" }).then(() => {
        this.$emit('delete-requested', this.reply.id);
      }).catch(() => {});
    }
  }
};
</script>

<style scoped>
.discussion-reply {
  padding: 10px 0;
  border-top: 1px dashed #eee; /* 可选，分隔回复 */
}
.discussion-reply:first-child {
  border-top: none;
}
.reply-meta {
  font-size: 0.9em;
  color: #555;
  margin-bottom: 5px;
  display: flex;
  align-items: center;
}
.reply-meta .username {
  margin: 0 8px;
}
.reply-meta .timestamp {
  color: #999;
}
.reply-content {
  font-size: 0.95em;
  line-height: 1.7;
  word-break: break-word;
  padding-left: 28px; /* 与头像和小按钮对齐 */
}
.sub-reply-form {
  padding-left: 28px;
}
</style>