package com.example.entity;

import java.io.Serializable;
import java.util.Date; // 建议使用 java.util.Date 或更现代的日期时间API
import java.util.List;

public class Discussion implements Serializable {
    private static final long serialVersionUID = 1L;

    private Integer id;
    private Integer courseId; // 关联课程ID
    private String courseName; // 冗余字段，方便前端显示
    private Integer userId;   // 发布用户ID
    private String userName;  // 发布用户名 (冗余，方便前端显示)
    private String userAvatar; // 发布用户头像 (冗余，方便前端显示)
    private String userRole;  // 发布用户角色
    private String title;     // 讨论主题 (主贴才有)
    private String content;   // 讨论内容
    private Integer parentId; // 父级ID，如果是主贴则为null
    private Date timestamp;   // 发布时间 (使用 java.util.Date)

    private List<Discussion> replies; // 用于存放回复列表 (查询时填充)

    // Getter 和 Setter 方法
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getCourseId() {
        return courseId;
    }

    public void setCourseId(Integer courseId) {
        this.courseId = courseId;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserAvatar() {
        return userAvatar;
    }

    public void setUserAvatar(String userAvatar) {
        this.userAvatar = userAvatar;
    }

    public String getUserRole() {
        return userRole;
    }

    public void setUserRole(String userRole) {
        this.userRole = userRole;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Integer getParentId() {
        return parentId;
    }

    public void setParentId(Integer parentId) {
        this.parentId = parentId;
    }

    public Date getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Date timestamp) {
        this.timestamp = timestamp;
    }

    public List<Discussion> getReplies() {
        return replies;
    }

    public void setReplies(List<Discussion> replies) {
        this.replies = replies;
    }
}