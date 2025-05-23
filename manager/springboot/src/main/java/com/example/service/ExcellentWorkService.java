package com.example.service;

import com.example.common.enums.RoleEnum;
import com.example.entity.Account;
import com.example.entity.ExcellentWork;
import com.example.mapper.ExcellentWorkMapper;
import com.example.utils.TokenUtils;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Date;
import java.util.List;

@Service
public class ExcellentWorkService {

    @Resource
    private ExcellentWorkMapper excellentWorkMapper;

    @Transactional
    public void add(ExcellentWork excellentWork) {
        Account currentUser = TokenUtils.getCurrentUser();
        // 通常管理员或教师可以上传优秀作品
        if (RoleEnum.ADMIN.name().equals(currentUser.getRole()) || RoleEnum.TEACHER.name().equals(currentUser.getRole())) {
            excellentWork.setUploaderId(currentUser.getId());
            excellentWork.setUploaderRole(currentUser.getRole());
            excellentWork.setUploadTime(new Date());
            excellentWorkMapper.insert(excellentWork);
        } else {
            // 可以抛出权限不足异常
        }
    }

    @Transactional
    public void deleteById(Integer id) {
        // 权限校验：通常只有上传者或管理员可以删除
        Account currentUser = TokenUtils.getCurrentUser();
        ExcellentWork work = excellentWorkMapper.selectById(id);
        if (work != null && (RoleEnum.ADMIN.name().equals(currentUser.getRole()) ||
                (work.getUploaderId().equals(currentUser.getId()) && work.getUploaderRole().equals(currentUser.getRole())))) {
            excellentWorkMapper.deleteById(id);
            // 注意：也需要处理关联文件的删除
        }
    }

    @Transactional
    public void deleteBatch(List<Integer> ids) {
        Account currentUser = TokenUtils.getCurrentUser();
        for (Integer id : ids) {
            ExcellentWork work = excellentWorkMapper.selectById(id);
            if (work != null && (RoleEnum.ADMIN.name().equals(currentUser.getRole()) ||
                    (work.getUploaderId().equals(currentUser.getId()) && work.getUploaderRole().equals(currentUser.getRole())))) {
                excellentWorkMapper.deleteById(id);
            }
        }
    }

    @Transactional
    public void updateById(ExcellentWork excellentWork) {
        Account currentUser = TokenUtils.getCurrentUser();
        ExcellentWork dbWork = excellentWorkMapper.selectById(excellentWork.getId());
        if (dbWork != null && (RoleEnum.ADMIN.name().equals(currentUser.getRole()) ||
                (dbWork.getUploaderId().equals(currentUser.getId()) && dbWork.getUploaderRole().equals(currentUser.getRole())))) {
            // 不应允许修改 uploaderId, uploaderRole, uploadTime
            excellentWork.setUploaderId(dbWork.getUploaderId());
            excellentWork.setUploaderRole(dbWork.getUploaderRole());
            excellentWork.setUploadTime(dbWork.getUploadTime());
            excellentWorkMapper.updateById(excellentWork);
        }
    }

    public ExcellentWork selectById(Integer id) {
        return excellentWorkMapper.selectById(id);
    }

    public List<ExcellentWork> selectAll(ExcellentWork excellentWork) {
        return excellentWorkMapper.selectAll(excellentWork);
    }

    public PageInfo<ExcellentWork> selectPage(ExcellentWork excellentWork, Integer pageNum, Integer pageSize) {
        PageHelper.startPage(pageNum, pageSize);
        List<ExcellentWork> list = excellentWorkMapper.selectAll(excellentWork);
        return PageInfo.of(list);
    }
}