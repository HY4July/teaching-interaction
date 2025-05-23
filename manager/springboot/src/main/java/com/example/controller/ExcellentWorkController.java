package com.example.controller;

import com.example.common.Result;
import com.example.entity.ExcellentWork;
import com.example.service.ExcellentWorkService;
import com.github.pagehelper.PageInfo;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

@RestController
@RequestMapping("/excellentWork")
public class ExcellentWorkController {

    @Resource
    private ExcellentWorkService excellentWorkService;

    /**
     * 新增优秀作品 (管理员或教师操作)
     */
    @PostMapping("/add")
    public Result add(@RequestBody ExcellentWork excellentWork) {
        excellentWorkService.add(excellentWork);
        return Result.success();
    }

    /**
     * 删除优秀作品
     */
    @DeleteMapping("/delete/{id}")
    public Result deleteById(@PathVariable Integer id) {
        excellentWorkService.deleteById(id);
        return Result.success();
    }

    /**
     * 批量删除优秀作品
     */
    @DeleteMapping("/delete/batch")
    public Result deleteBatch(@RequestBody List<Integer> ids) {
        excellentWorkService.deleteBatch(ids);
        return Result.success();
    }

    /**
     * 修改优秀作品
     */
    @PutMapping("/update")
    public Result updateById(@RequestBody ExcellentWork excellentWork) {
        excellentWorkService.updateById(excellentWork);
        return Result.success();
    }

    /**
     * 根据ID查询优秀作品
     */
    @GetMapping("/selectById/{id}")
    public Result selectById(@PathVariable Integer id) {
        ExcellentWork excellentWork = excellentWorkService.selectById(id);
        return Result.success(excellentWork);
    }

    /**
     * 查询所有优秀作品 (可带条件)
     * 对所有角色开放查看
     */
    @GetMapping("/selectAll")
    public Result selectAll(ExcellentWork excellentWork ) {
        List<ExcellentWork> list = excellentWorkService.selectAll(excellentWork);
        return Result.success(list);
    }

    /**
     * 分页查询优秀作品
     * 对所有角色开放查看
     */
    @GetMapping("/selectPage")
    public Result selectPage(ExcellentWork excellentWork,
                             @RequestParam(defaultValue = "1") Integer pageNum,
                             @RequestParam(defaultValue = "10") Integer pageSize) {
        PageInfo<ExcellentWork> page = excellentWorkService.selectPage(excellentWork, pageNum, pageSize);
        return Result.success(page);
    }
}