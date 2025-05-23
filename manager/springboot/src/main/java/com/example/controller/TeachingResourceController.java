package com.example.controller;

import com.example.common.Result;
import com.example.entity.TeachingResource;
import com.example.service.TeachingResourceService;
import com.github.pagehelper.PageInfo;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

@RestController
@RequestMapping("/teachingResource")
public class TeachingResourceController {

    @Resource
    private TeachingResourceService teachingResourceService;

    /**
     * 新增教学资源 (通常由教师操作)
     */
    @PostMapping("/add")
    public Result add(@RequestBody TeachingResource teachingResource) {
        teachingResourceService.add(teachingResource);
        return Result.success();
    }

    /**
     * 删除教学资源
     */
    @DeleteMapping("/delete/{id}")
    public Result deleteById(@PathVariable Integer id) {
        teachingResourceService.deleteById(id);
        return Result.success();
    }

    /**
     * 批量删除教学资源
     */
    @DeleteMapping("/delete/batch")
    public Result deleteBatch(@RequestBody List<Integer> ids) {
        teachingResourceService.deleteBatch(ids);
        return Result.success();
    }

    /**
     * 修改教学资源
     */
    @PutMapping("/update")
    public Result updateById(@RequestBody TeachingResource teachingResource) {
        teachingResourceService.updateById(teachingResource);
        return Result.success();
    }

    /**
     * 根据ID查询教学资源
     */
    @GetMapping("/selectById/{id}")
    public Result selectById(@PathVariable Integer id) {
        TeachingResource teachingResource = teachingResourceService.selectById(id);
        return Result.success(teachingResource);
    }

    /**
     * 查询所有教学资源 (可带条件)
     * 学生、教师、管理员均可访问，但教师访问时 Service 层会处理权限
     */
    @GetMapping("/selectAll")
    public Result selectAll(TeachingResource teachingResource) {
        List<TeachingResource> list = teachingResourceService.selectAll(teachingResource);
        return Result.success(list);
    }

    /**
     * 分页查询教学资源
     * 学生、教师、管理员均可访问
     */
    @GetMapping("/selectPage")
    public Result selectPage(TeachingResource teachingResource,
                             @RequestParam(defaultValue = "1") Integer pageNum,
                             @RequestParam(defaultValue = "10") Integer pageSize) {
        PageInfo<TeachingResource> page = teachingResourceService.selectPage(teachingResource, pageNum, pageSize);
        return Result.success(page);
    }
}