package com.example.mapper;

import com.example.entity.Discussion;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface DiscussionMapper {

    int insert(Discussion discussion);

    int deleteById(Integer id);

    Discussion selectById(Integer id);

    // 查询某个课程下的所有主贴 (parentId is null)
    List<Discussion> selectTopicsByCourseId(@Param("courseId") Integer courseId, @Param("title") String title);

    // 查询某个主贴下的所有回复 (parentId = topicId)
    List<Discussion> selectRepliesByParentId(Integer parentId);

    // 如果需要级联删除子回复，可以添加此方法 (或者在数据库层面设置级联删除)
    // int deleteByParentId(Integer parentId);
}