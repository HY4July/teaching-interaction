package com.example.mapper;

import com.example.entity.TeachingResource;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface TeachingResourceMapper {

    int insert(TeachingResource teachingResource);

    int deleteById(Integer id);

    int updateById(TeachingResource teachingResource);

    TeachingResource selectById(Integer id);

    List<TeachingResource> selectAll(TeachingResource teachingResource); // 用于后台管理和条件查询

    // 可选：专门为学生端按分类或课程查询的接口，可以和selectAll合并，通过参数控制
    // List<TeachingResource> selectForStudentView(@Param("category") String category, @Param("courseId") Integer courseId, @Param("name") String name);
}