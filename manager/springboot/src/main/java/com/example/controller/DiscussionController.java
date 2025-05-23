package com.example.controller;

import com.example.common.Result;
import com.example.entity.Discussion;
import com.example.service.DiscussionService;
import com.github.pagehelper.PageInfo;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;

@RestController
@RequestMapping("/discussion")
public class DiscussionController {

    @Resource
    private DiscussionService discussionService;

    /**
     * 新增讨论或回复
     */
    @PostMapping("/add")
    public Result add(@RequestBody Discussion discussion) {
        discussionService.add(discussion);
        return Result.success();
    }

    /**
     * 删除讨论或回复
     */
    @DeleteMapping("/delete/{id}")
    public Result deleteById(@PathVariable Integer id) {
        // 实际项目中可能需要权限校验
        discussionService.deleteById(id);
        return Result.success();
    }

    /**
     * 根据课程ID分页查询主讨论帖
     */
    @GetMapping("/selectTopicsByCourseId")
    public Result selectTopicsByCourseId(@RequestParam Integer courseId,
                                         @RequestParam(required = false) String title, // 可选的标题搜索
                                         @RequestParam(defaultValue = "1") Integer pageNum,
                                         @RequestParam(defaultValue = "10") Integer pageSize) {
        PageInfo<Discussion> page = discussionService.selectTopicsByCourseId(courseId, title, pageNum, pageSize);
        return Result.success(page);
    }

    /**
     * 根据主贴ID查询主贴及其所有回复（嵌套结构）
     */
    @GetMapping("/selectTopicWithReplies/{topicId}")
    public Result selectTopicWithReplies(@PathVariable Integer topicId) {
        Discussion discussion = discussionService.getDiscussionWithReplies(topicId);
        return Result.success(discussion);
    }
}