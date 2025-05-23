package com.example.mapper;

import com.example.entity.College;

import java.util.List;

public interface CollegeMapper {

    /**
     * 新增
     */
    int insert(College college);

    /**
     * 删除
     */
    int deleteById(Integer id);

    /**
     * 修改
     */
    int updateById(College college);

    /**
     * 根据ID查询
     */
    College selectById(Integer id);

    /**
     * 查询所有
     */
    List<College> selectAll(College college);

}