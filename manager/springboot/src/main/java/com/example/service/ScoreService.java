package com.example.service;

import cn.hutool.core.util.ObjectUtil;
import com.example.common.enums.ResultCodeEnum;
import com.example.common.enums.RoleEnum;
import com.example.entity.Account;
import com.example.entity.Course;
import com.example.entity.Score;
import com.example.entity.Student;
import com.example.exception.CustomException;
import com.example.mapper.CourseMapper;
import com.example.mapper.ScoreMapper;
import com.example.mapper.StudentMapper;
import com.example.utils.TokenUtils;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;

@Service
public class ScoreService {

    @Resource
    private ScoreMapper scoreMapper;
    @Resource
    private CourseMapper courseMapper;
    @Resource
    private StudentMapper studentMapper;

    /**
     * 新增
     */
    public void add(Score score) {
        // 判断下该门课该学生 有没有录入过成绩，如果有就不需要在录入了
        Score dbScore = scoreMapper.selectByCourceIdAndStudentId(score.getCourseId(), score.getStudentId());
        if (ObjectUtil.isNotEmpty(dbScore)) {
            throw new CustomException(ResultCodeEnum.SCORE_ALREADY_ERROR);
        }
        // 计算一下总成绩
        double total = score.getOrdinaryScore() * 0.3 + score.getExamScore() * 0.7;
        score.setScore(total);
        scoreMapper.insert(score);

        // 录入之后，及格的学生需要获取对应的学分
        if (total >= 60) {
            Course course = courseMapper.selectById(score.getCourseId());
            Student student = studentMapper.selectById(score.getStudentId());
            student.setScore(student.getScore() + course.getScore());
            studentMapper.updateById(student);
        }
    }

    /**
     * 删除
     */
    public void deleteById(Integer id) {
        Score score = scoreMapper.selectById(id);
        scoreMapper.deleteById(id);
        // 扣除学生对应的学分
        Student student = studentMapper.selectById(score.getStudentId());
        Course course = courseMapper.selectById(score.getCourseId());
        student.setScore(student.getScore() - course.getScore());
        studentMapper.updateById(student);
    }

    /**
     * 批量删除
     */
    public void deleteBatch(List<Integer> ids) {
        for (Integer id : ids) {
            scoreMapper.deleteById(id);
        }
    }

    /**
     * 修改
     */
    @Transactional // 添加事务管理注解
    public void updateById(Score score) {
        // 1. 获取旧的成绩信息，以便后续比较学分变化
        Score oldScore = scoreMapper.selectById(score.getId());
        if (ObjectUtil.isNull(oldScore)) {
            throw new CustomException(ResultCodeEnum.PARAM_ERROR.code, "未找到要更新的成绩记录");
        }

        // 2. 重新计算总成绩
        double newTotalScore = 0;
        if (score.getOrdinaryScore() != null && score.getExamScore() != null) {
            newTotalScore = score.getOrdinaryScore() * 0.3 + score.getExamScore() * 0.7;
            score.setScore(newTotalScore);
        } else {
            // 如果平时分或考试分未提供，则不重新计算总分，或根据业务需求抛出异常
            // 这里假设如果分数不完整，则不更新总分，只更新提供的分数部分
            if (score.getScore() == null) { // 如果总分也未提供，则使用旧的总分
                score.setScore(oldScore.getScore());
                newTotalScore = oldScore.getScore(); // 用于后续学分判断
            } else {
                newTotalScore = score.getScore(); // 如果前端直接传了总分
            }
        }


        // 3. 更新成绩表
        scoreMapper.updateById(score);

        // 4. 处理学分变化
        Course course = courseMapper.selectById(score.getCourseId());
        if (ObjectUtil.isNull(course) || ObjectUtil.isNull(course.getScore())) {
            //课程不存在或课程学分为空，则不处理学分
            return;
        }
        Student student = studentMapper.selectById(score.getStudentId());
        if (ObjectUtil.isNull(student)) {
            return; // 学生不存在，不处理学分
        }

        boolean oldIsPass = oldScore.getScore() != null && oldScore.getScore() >= 60;
        boolean newIsPass = newTotalScore >= 60;

        Integer courseCredit = course.getScore();
        Integer currentStudentCredits = student.getScore() == null ? 0 : student.getScore();

        if (oldIsPass && !newIsPass) { // 之前及格，现在不及格
            student.setScore(currentStudentCredits - courseCredit);
            studentMapper.updateById(student);
        } else if (!oldIsPass && newIsPass) { // 之前不及格，现在及格
            student.setScore(currentStudentCredits + courseCredit);
            studentMapper.updateById(student);
        }
        // 如果及格状态不变，则学生总学分不变。
    }

    /**
     * 根据ID查询
     */
    public Score selectById(Integer id) {
        return scoreMapper.selectById(id);
    }

    /**
     * 查询所有
     */
    public List<Score> selectAll(Score score) {
        return scoreMapper.selectAll(score);
    }

    /**
     * 分页查询
     */
    public PageInfo<Score> selectPage(Score score, Integer pageNum, Integer pageSize) {
        Account currentUser = TokenUtils.getCurrentUser();
        if (RoleEnum.TEACHER.name().equals(currentUser.getRole())) {
            score.setTeacherId(currentUser.getId());
        }
        if (RoleEnum.STUDENT.name().equals(currentUser.getRole())) {
            score.setStudentId(currentUser.getId());
        }
        PageHelper.startPage(pageNum, pageSize);
        List<Score> list = scoreMapper.selectAll(score);
        return PageInfo.of(list);
    }

}