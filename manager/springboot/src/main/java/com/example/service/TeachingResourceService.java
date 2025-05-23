package com.example.service;

import com.example.common.enums.RoleEnum;
import com.example.entity.Account;
import com.example.entity.TeachingResource;
import com.example.mapper.TeachingResourceMapper;
import com.example.utils.TokenUtils;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Date;
import java.util.List;

@Service
public class TeachingResourceService {

    @Resource
    private TeachingResourceMapper teachingResourceMapper;

    @Transactional
    public void add(TeachingResource teachingResource) {
        Account currentUser = TokenUtils.getCurrentUser();
        // 通常只有教师可以上传教学资源
        if (!RoleEnum.TEACHER.name().equals(currentUser.getRole())) {
            // 或者抛出权限不足的异常
            return;
        }
        teachingResource.setUploaderId(currentUser.getId());
        teachingResource.setUploadTime(new Date());
        teachingResourceMapper.insert(teachingResource);
    }

    @Transactional
    public void deleteById(Integer id) {
        // 可在此处添加权限校验，例如只有上传者或管理员才能删除
        TeachingResource resource = teachingResourceMapper.selectById(id);
        Account currentUser = TokenUtils.getCurrentUser();
        if (resource != null && (currentUser.getRole().equals(RoleEnum.ADMIN.name()) || resource.getUploaderId().equals(currentUser.getId()))) {
            teachingResourceMapper.deleteById(id);
            // 注意：这里只删除了数据库记录，实际的文件需要额外处理（如果文件存储在服务器上）
            // FileUtil.del(filePath + fileNameFromUrl(resource.getFileUrl()));
        }
    }

    @Transactional
    public void deleteBatch(List<Integer> ids) {
        Account currentUser = TokenUtils.getCurrentUser();
        for (Integer id : ids) {
            TeachingResource resource = teachingResourceMapper.selectById(id);
            if (resource != null && (currentUser.getRole().equals(RoleEnum.ADMIN.name()) || resource.getUploaderId().equals(currentUser.getId()))) {
                teachingResourceMapper.deleteById(id);
                // FileUtil.del(filePath + fileNameFromUrl(resource.getFileUrl()));
            }
        }
    }

    @Transactional
    public void updateById(TeachingResource teachingResource) {
        // 可在此处添加权限校验
        TeachingResource dbResource = teachingResourceMapper.selectById(teachingResource.getId());
        Account currentUser = TokenUtils.getCurrentUser();
        if (dbResource != null && (currentUser.getRole().equals(RoleEnum.ADMIN.name()) || dbResource.getUploaderId().equals(currentUser.getId()))) {
            // uploaderId 和 uploadTime 通常不应在更新时修改
            teachingResource.setUploaderId(dbResource.getUploaderId());
            teachingResource.setUploadTime(dbResource.getUploadTime());
            teachingResourceMapper.updateById(teachingResource);
        }
    }

    public TeachingResource selectById(Integer id) {
        return teachingResourceMapper.selectById(id);
    }

    public List<TeachingResource> selectAll(TeachingResource teachingResource) {
        // 对于学生，可能不需要传入 uploaderId 进行筛选，他们看所有老师上传的
        // 对于教师，如果只想看自己上传的，可以在Controller层设置uploaderId
        return teachingResourceMapper.selectAll(teachingResource);
    }

    public PageInfo<TeachingResource> selectPage(TeachingResource teachingResource, Integer pageNum, Integer pageSize) {
        Account currentUser = TokenUtils.getCurrentUser();
        // 教师查看资源列表时，默认只看自己上传的（除非是管理员）
        if (RoleEnum.TEACHER.name().equals(currentUser.getRole())) {
            // 如果 teachingResource.getUploaderId() 为空 (即前端没有特定指定uploaderId进行搜索)
            // 并且当前用户是教师，则设置查询条件为当前教师
            if (teachingResource.getUploaderId() == null) {
                teachingResource.setUploaderId(currentUser.getId());
            }
        } else if (RoleEnum.STUDENT.name().equals(currentUser.getRole())) {
            // 学生可以查看所有教师上传的资源，所以不设置uploaderId
            teachingResource.setUploaderId(null); // 确保学生查询时不会意外使用到旧的uploaderId
        }
        // 管理员可以查看所有，并可以按uploaderId筛选（如果前端提供了）

        PageHelper.startPage(pageNum, pageSize);
        List<TeachingResource> list = teachingResourceMapper.selectAll(teachingResource);
        return PageInfo.of(list);
    }
}