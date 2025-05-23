package com.example.mapper;

import com.example.entity.ExcellentWork;
import java.util.List;

public interface ExcellentWorkMapper {

    int insert(ExcellentWork excellentWork);

    int deleteById(Integer id);

    int updateById(ExcellentWork excellentWork);

    ExcellentWork selectById(Integer id);

    List<ExcellentWork> selectAll(ExcellentWork excellentWork);
}