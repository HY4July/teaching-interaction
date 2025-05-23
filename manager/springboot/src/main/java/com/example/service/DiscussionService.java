package com.example.service;

import com.example.entity.Account;
import com.example.entity.Discussion;
import com.example.mapper.DiscussionMapper;
import com.example.utils.TokenUtils;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Date;
import java.util.List;

@Service
public class DiscussionService {

    @Resource
    private DiscussionMapper discussionMapper;

    /**
     * 新增讨论（主贴或回复）
     */
    @Transactional
    public void add(Discussion discussion) {
        Account currentUser = TokenUtils.getCurrentUser();
        discussion.setUserId(currentUser.getId());
        discussion.setUserRole(currentUser.getRole());
        discussion.setTimestamp(new Date()); // 设置当前时间为发布时间

        // 如果是回复，parentId 不为空，title 可以为空
        if (discussion.getParentId() != null) {
            discussion.setTitle(null); // 回复通常不需要独立的标题
        } else {
            // 如果是主贴，parentId 为空，title 是必需的 (前端应校验)
        }
        discussionMapper.insert(discussion);
    }

    /**
     * 删除讨论（同时删除其所有子回复，如果设计如此）
     * 简单实现：只删除当前项。若要级联删除，需要在Mapper或数据库层面处理。
     * 为毕业设计简化，暂不处理级联删除子回复，只删除当前点击的讨论或回复。
     * 如果要删除主贴及其所有回复，需要递归或多次查询删除。
     */
    public void deleteById(Integer id) {
        // 可在此处添加权限校验，例如只有发布者或管理员才能删除
        discussionMapper.deleteById(id);
    }

    /**
     * 根据课程ID分页查询主讨论帖
     */
    public PageInfo<Discussion> selectTopicsByCourseId(Integer courseId, String title, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<Discussion> list = discussionMapper.selectTopicsByCourseId(courseId, title);
        // 可以选择在这里为每个主贴加载其部分热门/最新回复作为预览，但为了简化，暂时不处理
        return PageInfo.of(list);
    }

    /**
     * 根据主贴ID查询其所有回复 (不分页，或根据需要分页)
     * 并在Service层递归获取每条回复的子回复
     */
    public Discussion getDiscussionWithReplies(Integer topicId) {
        Discussion topic = discussionMapper.selectById(topicId);
        if (topic != null) {
            List<Discussion> directReplies = discussionMapper.selectRepliesByParentId(topicId);
            fetchRepliesRecursive(directReplies); // 递归获取所有子回复
            topic.setReplies(directReplies);
        }
        return topic;
    }

    private void fetchRepliesRecursive(List<Discussion> discussions) {
        if (discussions == null || discussions.isEmpty()) {
            return;
        }
        for (Discussion discussion : discussions) {
            List<Discussion> replies = discussionMapper.selectRepliesByParentId(discussion.getId());
            fetchRepliesRecursive(replies); // 递归调用
            discussion.setReplies(replies);
        }
    }
}