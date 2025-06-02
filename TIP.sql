/*
 Navicat Premium Data Transfer

 Source Server         : tpch
 Source Server Type    : MySQL
 Source Server Version : 80029
 Source Host           : localhost:3306
 Source Schema         : teaching-interaction

 Target Server Type    : MySQL
 Target Server Version : 80029
 File Encoding         : 65001

 Date: 02/06/2025 18:35:48
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin`  (
                          `id` int(0) NOT NULL AUTO_INCREMENT COMMENT 'ID',
                          `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户名',
                          `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '密码',
                          `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '姓名',
                          `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '头像',
                          `role` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '角色标识',
                          `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '电话',
                          `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
                          PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '管理员' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES (1, 'admin', '123456', '管理员', 'http://localhost:9090/files/1747549289730-签名.png', 'ADMIN', '13677889922', 'admin@xm.com');

-- ----------------------------
-- Table structure for classes
-- ----------------------------
DROP TABLE IF EXISTS `classes`;
CREATE TABLE `classes`  (
                            `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                            `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '班级名称',
                            `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '班级描述',
                            `teacher_id` int(0) NULL DEFAULT NULL COMMENT '教师ID',
                            `speciality_id` int(0) NULL DEFAULT NULL COMMENT '专业ID',
                            PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '班级信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of classes
-- ----------------------------
INSERT INTO `classes` VALUES (1, '物联网214', NULL, 2, 2);
INSERT INTO `classes` VALUES (2, '软件211', NULL, 2, 3);
INSERT INTO `classes` VALUES (3, '土木221', NULL, 3, 4);
INSERT INTO `classes` VALUES (4, '建环232', NULL, 3, 5);
INSERT INTO `classes` VALUES (5, '思政241', NULL, 4, 7);
INSERT INTO `classes` VALUES (6, '国贸231', NULL, 4, 9);

-- ----------------------------
-- Table structure for college
-- ----------------------------
DROP TABLE IF EXISTS `college`;
CREATE TABLE `college`  (
                            `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                            `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '学院名称',
                            `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '学院介绍',
                            PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学院信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of college
-- ----------------------------
INSERT INTO `college` VALUES (1, '计算机学院', 'fwa');
INSERT INTO `college` VALUES (2, '马克思学院', 'grnr');
INSERT INTO `college` VALUES (3, '经济学院', ' ￥￥￥￥');
INSERT INTO `college` VALUES (4, '土木学院', '558vfe');

-- ----------------------------
-- Table structure for course
-- ----------------------------
DROP TABLE IF EXISTS `course`;
CREATE TABLE `course`  (
                           `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                           `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '课程名称',
                           `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '课程类型',
                           `teacher_id` int(0) NULL DEFAULT NULL COMMENT '授课教师',
                           `score` int(0) NULL DEFAULT NULL COMMENT '课程学分',
                           `num` int(0) NULL DEFAULT NULL COMMENT '上课人数',
                           `room` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '上课教室',
                           `week` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '周几',
                           `segment` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '第几大节',
                           `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '上课状态',
                           PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '课程信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of course
-- ----------------------------
INSERT INTO `course` VALUES (1, '程序设计语言', '必修', 2, 4, 120, 'A301', '星期二', '第二大节（09:40 ~ 12:00）', '已开课');
INSERT INTO `course` VALUES (2, '离散数学', '必修', 2, 2, 120, 'B204', '星期四', '第三大节（14:00 ~ 15:30）', '已开课');
INSERT INTO `course` VALUES (3, '结构力学', '必修', 3, 3, 120, 'C101', '星期三', '第二大节（09:40 ~ 12:00）', '已开课');
INSERT INTO `course` VALUES (4, '国际贸易实务', '必修', 4, 3, 90, 'D505', '星期三', '第四大节（15:40 ~ 17:00）', '已开课');

-- ----------------------------
-- Table structure for discussion
-- ----------------------------
DROP TABLE IF EXISTS `discussion`;
CREATE TABLE `discussion`  (
                               `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                               `course_id` int(0) NOT NULL COMMENT '关联课程ID',
                               `user_id` int(0) NOT NULL COMMENT '发布用户ID (学生或教师)',
                               `user_role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '发布用户角色 (STUDENT, TEACHER)',
                               `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '讨论主题 (如果是主贴)',
                               `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '讨论内容',
                               `parent_id` int(0) NULL DEFAULT NULL COMMENT '父级讨论ID (用于回复，指向主贴或其他回复)',
                               `timestamp` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '发布时间',
                               PRIMARY KEY (`id`) USING BTREE,
                               INDEX `idx_course_id`(`course_id`) USING BTREE,
                               INDEX `idx_parent_id`(`parent_id`) USING BTREE,
                               CONSTRAINT `fk_discussion_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
                               CONSTRAINT `fk_discussion_parent` FOREIGN KEY (`parent_id`) REFERENCES `discussion` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '讨论区表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of discussion
-- ----------------------------
INSERT INTO `discussion` VALUES (1, 2, 2, 'TEACHER', 'PTA作业答疑统计', '回复需要课堂讲解的题目', NULL, '2025-05-23 19:09:03');
INSERT INTO `discussion` VALUES (2, 2, 1, 'STUDENT', NULL, '第一题', 1, '2025-05-23 19:09:35');
INSERT INTO `discussion` VALUES (3, 2, 2, 'STUDENT', NULL, '没有要讲的，我都会', 1, '2025-05-23 19:10:15');
INSERT INTO `discussion` VALUES (4, 1, 1, 'STUDENT', '谁有上节课的笔记？', '求好心人发我一份', NULL, '2025-05-24 03:58:54');
INSERT INTO `discussion` VALUES (5, 1, 2, 'TEACHER', NULL, '待会我把讲义传上来', 4, '2025-05-24 04:00:58');

-- ----------------------------
-- Table structure for excellent_works
-- ----------------------------
DROP TABLE IF EXISTS `excellent_works`;
CREATE TABLE `excellent_works`  (
                                    `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                                    `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '作品标题',
                                    `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '作品描述',
                                    `student_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '学生姓名 (作者)',
                                    `student_id` int(0) NULL DEFAULT NULL COMMENT '关联学生ID (可选)',
                                    `course_id` int(0) NULL DEFAULT NULL COMMENT '关联课程ID (可选,表明是哪个课程的作品)',
                                    `file_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '作品文件或预览图链接/视频链接',
                                    `upload_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '上传时间',
                                    `uploader_id` int(0) NOT NULL COMMENT '上传者ID (管理员或教师)',
                                    `uploader_role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '上传者角色',
                                    PRIMARY KEY (`id`) USING BTREE,
                                    INDEX `idx_course_id_ew`(`course_id`) USING BTREE,
                                    INDEX `idx_student_id_ew`(`student_id`) USING BTREE,
                                    INDEX `idx_uploader_id_ew`(`uploader_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '优秀作品表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of excellent_works
-- ----------------------------
INSERT INTO `excellent_works` VALUES (1, '测试', '优秀作品样例', '张伟', 2, 2, 'http://localhost:9090/files/1748003655925-优秀作品test.docx', '2025-05-23 20:34:36', 2, 'TEACHER');

-- ----------------------------
-- Table structure for homework
-- ----------------------------
DROP TABLE IF EXISTS `homework`;
CREATE TABLE `homework`  (
                             `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                             `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '课程说明',
                             `course_id` int(0) NULL DEFAULT NULL COMMENT '课程ID',
                             `student_id` int(0) NULL DEFAULT NULL COMMENT '学生ID',
                             `teacher_id` int(0) NULL DEFAULT NULL COMMENT '教师ID',
                             `file` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '作业文件',
                             `score` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '打分',
                             `descr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '说明',
                             PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '作业信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of homework
-- ----------------------------
INSERT INTO `homework` VALUES (1, '测试1', 2, 2, 2, 'http://localhost:9090/files/1747997324672-作业test.txt', '90', '好');
INSERT INTO `homework` VALUES (2, '作业测试', 4, 4, 4, 'http://localhost:9090/files/1748029539552-作业test.txt', NULL, NULL);

-- ----------------------------
-- Table structure for notice
-- ----------------------------
DROP TABLE IF EXISTS `notice`;
CREATE TABLE `notice`  (
                           `id` int(0) NOT NULL AUTO_INCREMENT COMMENT 'ID',
                           `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '标题',
                           `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '内容',
                           `time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '创建时间',
                           `user` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '创建人',
                           PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '公告信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of notice
-- ----------------------------
INSERT INTO `notice` VALUES (5, '系统正式上线', '已实现基础功能，欢迎各位老师同学体验并提出建议！', '2025-05-23', 'admin');

-- ----------------------------
-- Table structure for score
-- ----------------------------
DROP TABLE IF EXISTS `score`;
CREATE TABLE `score`  (
                          `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                          `student_id` int(0) NULL DEFAULT NULL COMMENT '学生ID',
                          `course_id` int(0) NULL DEFAULT NULL COMMENT '课程ID',
                          `teacher_id` int(0) NULL DEFAULT NULL COMMENT '教师ID',
                          `ordinary_score` double(10, 2) NULL DEFAULT NULL COMMENT '平时分',
                          `exam_score` double(10, 2) NULL DEFAULT NULL COMMENT '考试分',
                          `score` double(10, 2) NULL DEFAULT NULL COMMENT '总成绩',
                          PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '成绩信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of score
-- ----------------------------
INSERT INTO `score` VALUES (1, 2, 2, 2, 80.00, 85.00, 83.50);
INSERT INTO `score` VALUES (2, 2, 1, 2, 90.00, 78.00, 81.60);

-- ----------------------------
-- Table structure for speciality
-- ----------------------------
DROP TABLE IF EXISTS `speciality`;
CREATE TABLE `speciality`  (
                               `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                               `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '专业名称',
                               `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '专业描述',
                               `college_id` int(0) NULL DEFAULT NULL COMMENT '所属学院',
                               `score` int(0) NULL DEFAULT NULL COMMENT '学分限定',
                               PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '专业信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of speciality
-- ----------------------------
INSERT INTO `speciality` VALUES (2, '物联网工程', NULL, 1, NULL);
INSERT INTO `speciality` VALUES (3, '软件工程', NULL, 1, NULL);
INSERT INTO `speciality` VALUES (4, '土木工程', NULL, 4, NULL);
INSERT INTO `speciality` VALUES (5, '建筑环境与能源应用工程', NULL, 4, NULL);
INSERT INTO `speciality` VALUES (6, '马克思主义理论', NULL, 2, NULL);
INSERT INTO `speciality` VALUES (7, '思想政治教育', NULL, 2, NULL);
INSERT INTO `speciality` VALUES (8, '经济学', NULL, 3, NULL);
INSERT INTO `speciality` VALUES (9, '国际经济与贸易', NULL, 3, NULL);

-- ----------------------------
-- Table structure for student
-- ----------------------------
DROP TABLE IF EXISTS `student`;
CREATE TABLE `student`  (
                            `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                            `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户名',
                            `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '密码',
                            `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '姓名',
                            `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '头像',
                            `role` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '角色',
                            `college_id` int(0) NULL DEFAULT NULL COMMENT '学院ID',
                            `speciality_id` int(0) NULL DEFAULT NULL COMMENT '专业ID',
                            `class_id` int(0) NULL DEFAULT NULL COMMENT '班级ID',
                            `score` int(0) NULL DEFAULT 0 COMMENT '学分',
                            PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学生信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of student
-- ----------------------------
INSERT INTO `student` VALUES (1, 'student', '123456', '学生', 'http://localhost:9090/files/1748028464441-生成头像 (4).png', 'STUDENT', 1, 3, 2, 0);
INSERT INTO `student` VALUES (2, 'zhangwei', '123456', '张伟', 'http://localhost:9090/files/1748028475936-生成头像 (2).png', 'STUDENT', 1, 2, 1, 6);
INSERT INTO `student` VALUES (3, 'zhou', '123456', '周M', 'http://localhost:9090/files/1748028484092-生成头像 (5).png', 'STUDENT', 3, 9, 6, 0);
INSERT INTO `student` VALUES (4, 'chen', '123456', '陈m', 'http://localhost:9090/files/1748028938514-生成头像.png', 'STUDENT', 2, 7, 5, 0);

-- ----------------------------
-- Table structure for teacher
-- ----------------------------
DROP TABLE IF EXISTS `teacher`;
CREATE TABLE `teacher`  (
                            `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                            `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户名',
                            `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '密码',
                            `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '姓名',
                            `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '头像',
                            `role` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '角色',
                            `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '电话',
                            `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '邮箱',
                            `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '职称',
                            PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '教师信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of teacher
-- ----------------------------
INSERT INTO `teacher` VALUES (2, 'teacher', '123456', '教师', 'http://localhost:9090/files/1748028413701-生成头像 (6).png', 'TEACHER', NULL, NULL, NULL);
INSERT INTO `teacher` VALUES (3, 'yang', '123456', '杨X', 'http://localhost:9090/files/1748028346148-生成头像 (1).png', 'TEACHER', NULL, NULL, NULL);
INSERT INTO `teacher` VALUES (4, 'deng', '123456', '邓R', 'http://localhost:9090/files/1748028437483-生成头像 (7).png', 'TEACHER', NULL, NULL, NULL);

-- ----------------------------
-- Table structure for teaching_resource
-- ----------------------------
DROP TABLE IF EXISTS `teaching_resource`;
CREATE TABLE `teaching_resource`  (
                                      `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                                      `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '资源名称',
                                      `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '资源描述',
                                      `file_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '文件存储路径或链接',
                                      `uploader_id` int(0) NOT NULL COMMENT '上传者ID (应为教师ID)',
                                      `upload_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '上传时间',
                                      `category` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '资源分类 (如: 课件, 视频, 习题, 案例)',
                                      `course_id` int(0) NULL DEFAULT NULL COMMENT '关联课程ID (可选)',
                                      PRIMARY KEY (`id`) USING BTREE,
                                      INDEX `idx_uploader_id`(`uploader_id`) USING BTREE,
                                      INDEX `idx_course_id_tr`(`course_id`) USING BTREE,
                                      CONSTRAINT `fk_resource_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
                                      CONSTRAINT `fk_resource_teacher` FOREIGN KEY (`uploader_id`) REFERENCES `teacher` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '教学资源信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of teaching_resource
-- ----------------------------
INSERT INTO `teaching_resource` VALUES (1, '测试', '。。。。', 'http://localhost:9090/files/1748003029767-资源test.txt', 2, '2025-05-23 20:24:05', '其他', 1);
INSERT INTO `teaching_resource` VALUES (2, '国际贸易课件', NULL, 'http://localhost:9090/files/1748029413643-资源test.txt', 4, '2025-05-24 03:44:23', '课件', 4);

SET FOREIGN_KEY_CHECKS = 1;
