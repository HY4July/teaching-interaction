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
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '教师信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of teacher
-- ----------------------------
INSERT INTO `teacher` VALUES (2, 'teacher', '123456', '教师', 'http://localhost:9090/files/1747727696571-1697438073596-avatar.png', 'TEACHER', NULL, NULL, NULL);

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
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学生信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of student
-- ----------------------------
INSERT INTO `student` VALUES (1, 'student', '123456', '学生', 'http://localhost:9090/files/1747728213310-1697438073596-avatar.png', 'STUDENT', 1, 3, 2, 0);
INSERT INTO `student` VALUES (2, 'zhangwei', '123456', '张伟', NULL, 'STUDENT', 1, 2, 1, 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '公告信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of notice
-- ----------------------------
INSERT INTO `notice` VALUES (1, '今天系统正式上线，开始内测', '今天系统正式上线，开始内测', '2023-09-05', 'admin');
INSERT INTO `notice` VALUES (2, '所有功能都已完成，可以正常使用', '所有功能都已完成，可以正常使用', '2023-09-05', 'admin');
INSERT INTO `notice` VALUES (3, '今天天气很不错，可以出去一起玩了', '今天天气很不错，可以出去一起玩了', '2023-09-05', 'admin');

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '班级信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of classes
-- ----------------------------
INSERT INTO `classes` VALUES (1, '物联网214', NULL, 2, 2);
INSERT INTO `classes` VALUES (2, '软件211', NULL, 2, 3);

-- ----------------------------
-- Table structure for college
-- ----------------------------
DROP TABLE IF EXISTS `college`;
CREATE TABLE `college`  (
                            `id` int(0) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                            `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '学院名称',
                            `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '学院介绍',
                            PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学院信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of college
-- ----------------------------
INSERT INTO `college` VALUES (1, '计算机学院', 'fwa');

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '专业信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of speciality
-- ----------------------------
INSERT INTO `speciality` VALUES (2, '物联网工程', NULL, 1, NULL);
INSERT INTO `speciality` VALUES (3, '软件工程', NULL, 1, NULL);

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '课程信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of course
-- ----------------------------
INSERT INTO `course` VALUES (1, '程序设计语言', '必修', 2, 4, 120, 'A301', '星期二', '第二大节（09:40 ~ 12:00）', '已开课');
INSERT INTO `course` VALUES (2, '离散数学', '必修', 2, 2, 120, 'B204', '星期四', '第三大节（14:00 ~ 15:30）', '已开课');

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '成绩信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of score
-- ----------------------------

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '作业信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of homework
-- ----------------------------

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '讨论区表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of discussion
-- ----------------------------
INSERT INTO `discussion` VALUES (1, 2, 2, 'TEACHER', 'PTA作业答疑统计', '回复需要课堂讲解的题目', NULL, '2025-05-23 19:09:03');
INSERT INTO `discussion` VALUES (2, 2, 1, 'STUDENT', NULL, '第一题', 1, '2025-05-23 19:09:35');
INSERT INTO `discussion` VALUES (3, 2, 2, 'STUDENT', NULL, '没有要讲的，我都会', 1, '2025-05-23 19:10:15');

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '教学资源信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of teaching_resource
-- ----------------------------
INSERT INTO `teaching_resource` VALUES (1, '测试', '。。。。', 'http://localhost:9090/files/1748003029767-资源test.txt', 2, '2025-05-23 20:24:05', '其他', 1);

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '优秀作品表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of excellent_works
-- ----------------------------
INSERT INTO `excellent_works` VALUES (1, '测试', '优秀作品样例', '张伟', 2, 2, 'http://localhost:9090/files/1748003655925-优秀作品test.docx', '2025-05-23 20:34:36', 2, 'TEACHER');

SET FOREIGN_KEY_CHECKS = 1;
