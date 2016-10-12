insert into TBL_CATEGORY (ID, TITLE) values (1, 'HTML5');
insert into TBL_CATEGORY (ID, TITLE) values (2, 'Web服务器端开发:(Java EE方向)');
insert into TBL_CATEGORY (ID, TITLE) values (3, 'Web服务器端开发:(PHP方向)');
insert into TBL_CATEGORY (ID, TITLE) values (4, 'Web服务器端开发:(Ruby方向)');
insert into TBL_CATEGORY (ID, TITLE) values (5, 'Web服务器端开发:(Python方向)');
insert into TBL_CATEGORY (ID, TITLE) values (7, 'Web移动应用:(Android方向)');
insert into TBL_CATEGORY (ID, TITLE) values (8, '移动应用:(iOS方向)');
insert into TBL_CATEGORY (ID, TITLE) values (10, '项目管理与敏捷开发');
insert into TBL_CATEGORY (ID, TITLE) values (15, '云计算:(大数据方向)');
insert into TBL_CATEGORY (ID, TITLE) values (16, '云计算:(虚拟化方向)');
insert into TBL_CATEGORY (ID, TITLE) values (18, 'ARM体系结构与Linux内核');
insert into TBL_CATEGORY (ID, TITLE) values (20, '大学课程');


insert into TBL_COURSE (TITLE) values ('System Maintenance');
insert into TBL_COURSE (TITLE) values ('C-like Programming Languages');
insert into TBL_COURSE (TITLE) values ('C-like Programming Languages: C/C++');
insert into TBL_COURSE (TITLE) values ('C-like Programming Languages: Java');
insert into TBL_COURSE (TITLE) values ('JavaScript');
insert into TBL_COURSE (TITLE) values ('C-like Programming Languages: Swift');
insert into TBL_COURSE (TITLE) values ('C-like Programming Languages: C#');
insert into TBL_COURSE (TITLE) values ('计算机科学导论（ICS）');
insert into TBL_COURSE (TITLE) values ('计算机组成原理与操作系统');
insert into TBL_COURSE (TITLE) values ('数据库技术');
insert into TBL_COURSE (TITLE) values ('计算机网络');
insert into TBL_COURSE (TITLE) values ('计算机图形学');
insert into TBL_COURSE (TITLE) values ('多媒体技术');
insert into TBL_COURSE (TITLE) values ('Shell脚本编程');
insert into TBL_COURSE (TITLE) values ('Application Development');
insert into TBL_COURSE (TITLE) values ('HTML5 and CSS3');
insert into TBL_COURSE (TITLE) values ('Bootstrap');
insert into TBL_COURSE (TITLE) values ('数据结构与算法');
insert into TBL_COURSE (TITLE) values ('经典算法——逻辑与表达的乐趣');
insert into TBL_COURSE (TITLE) values ('SCM版本管理: Git');
insert into TBL_COURSE (TITLE) values ('敏捷开发');
insert into TBL_COURSE (TITLE) values ('CMMI管理');
insert into TBL_COURSE (TITLE) values ('UML设计');
insert into TBL_COURSE (TITLE) values ('Bugzilla and Issue Track');
insert into TBL_COURSE (TITLE) values ('Java Advanced Programming');
insert into TBL_COURSE (TITLE) values ('JSP and Java EE');
insert into TBL_COURSE (TITLE) values ('Java Web Frameworks');
insert into TBL_COURSE (TITLE) values ('PHP程序设计');
insert into TBL_COURSE (TITLE) values ('PHP Web Frameworks: CI, YII');
insert into TBL_COURSE (TITLE) values ('.Net Frameworks');
insert into TBL_COURSE (TITLE) values ('Ruby程序设计');
insert into TBL_COURSE (TITLE) values ('Ruby Web Frameworks: Rails');
insert into TBL_COURSE (TITLE) values ('Python程序设计');
insert into TBL_COURSE (TITLE) values ('Python Web Frameworks: Django, Flask');
insert into TBL_COURSE (TITLE) values ('Web服务器部署');
insert into TBL_COURSE (TITLE) values ('MariaDB/MySQL数据库');
insert into TBL_COURSE (TITLE) values ('PostgreSQL数据库');
insert into TBL_COURSE (TITLE) values ('MS SQL Server数据库');
insert into TBL_COURSE (TITLE) values ('Oracle数据库');
insert into TBL_COURSE (TITLE) values ('NoSQL与非关系型数据库');
insert into TBL_COURSE (TITLE) values ('SQLite开发');
insert into TBL_COURSE (TITLE) values ('网络安全');
insert into TBL_COURSE (TITLE) values ('云计算入门');
insert into TBL_COURSE (TITLE) values ('KVM虚拟化');
insert into TBL_COURSE (TITLE) values ('OpenStack');
insert into TBL_COURSE (TITLE) values ('Hadoop');
insert into TBL_COURSE (TITLE) values ('ARM体系结构');
insert into TBL_COURSE (TITLE) values ('嵌入式系统常用Bus及I/O接口技术');
insert into TBL_COURSE (TITLE) values ('汇编语言程序设计（ARM版）');
insert into TBL_COURSE (TITLE) values ('C语言本质');
insert into TBL_COURSE (TITLE) values ('纯汇编精简版Bootloader开发');
insert into TBL_COURSE (TITLE) values ('Bootloader（g-bios/u-boot）开发');
insert into TBL_COURSE (TITLE) values ('Linux内核分析与开发');
insert into TBL_COURSE (TITLE) values ('Linux设备驱动开发');
insert into TBL_COURSE (TITLE) values ('Linux rootfs与BusyBox');
insert into TBL_COURSE (TITLE) values ('Linux系统构建');
insert into TBL_COURSE (TITLE) values ('GNU Toolchain');
insert into TBL_COURSE (TITLE) values ('系统底层软件调试：工具及技巧');
insert into TBL_COURSE (TITLE) values ('Android开发');
insert into TBL_COURSE (TITLE) values ('iOS开发');
insert into TBL_COURSE (TITLE) values ('Cocos2d编程');
insert into TBL_COURSE (TITLE) values ('OpenGL 3D编程');
insert into TBL_COURSE (TITLE) values ('Unity游戏开发');
insert into TBL_COURSE (TITLE) values ('TCP/IP协议剖析及开发');
insert into TBL_COURSE (TITLE) values ('设计模式');

insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 1, ID from TBL_COURSE where TITLE = 'HTML5 and CSS3';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 1, ID from TBL_COURSE where TITLE = 'JavaScript';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 1, ID from TBL_COURSE where TITLE = 'Bootstrap';

insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 2, ID from TBL_COURSE where TITLE = 'System Maintenance';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 2, ID from TBL_COURSE where TITLE = 'Shell脚本编程';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 2, ID from TBL_COURSE where TITLE = 'SCM版本管理: Git';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 2, ID from TBL_COURSE where TITLE = 'JavaScript';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 2, ID from TBL_COURSE where TITLE = '数据结构与算法';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 2, ID from TBL_COURSE where TITLE = 'HTML5 and CSS3';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 2, ID from TBL_COURSE where TITLE = 'MariaDB/MySQL数据库';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 2, ID from TBL_COURSE where TITLE = 'PostgreSQL数据库';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 2, ID from TBL_COURSE where TITLE = 'Application Development';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 2, ID from TBL_COURSE where TITLE = 'Java程序设计';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 2, ID from TBL_COURSE where TITLE = 'Java Advanced Programming';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 2, ID from TBL_COURSE where TITLE = 'JSP and Java EE';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 2, ID from TBL_COURSE where TITLE = 'Java Web Frameworks';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 2, ID from TBL_COURSE where TITLE = 'Web服务器部署';

insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 3, ID from TBL_COURSE where TITLE = 'System Maintenance';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 3, ID from TBL_COURSE where TITLE = 'Shell脚本编程';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 3, ID from TBL_COURSE where TITLE = 'SCM版本管理: Git';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 3, ID from TBL_COURSE where TITLE = 'JavaScript';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 3, ID from TBL_COURSE where TITLE = '数据结构与算法';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 3, ID from TBL_COURSE where TITLE = 'HTML5 and CSS3';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 3, ID from TBL_COURSE where TITLE = 'MariaDB/MySQL数据库';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 3, ID from TBL_COURSE where TITLE = 'PostgreSQL数据库';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 3, ID from TBL_COURSE where TITLE = 'PHP程序设计';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 3, ID from TBL_COURSE where TITLE = 'PHP Web Frameworks: CI, YII';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 3, ID from TBL_COURSE where TITLE = 'Web服务器部署';

insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 4, ID from TBL_COURSE where TITLE = 'System Maintenance';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 4, ID from TBL_COURSE where TITLE = 'Shell脚本编程';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 4, ID from TBL_COURSE where TITLE = 'SCM版本管理: Git';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 4, ID from TBL_COURSE where TITLE = 'JavaScript';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 4, ID from TBL_COURSE where TITLE = '数据结构与算法';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 4, ID from TBL_COURSE where TITLE = 'HTML5 and CSS3';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 4, ID from TBL_COURSE where TITLE = 'MariaDB/MySQL数据库';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 4, ID from TBL_COURSE where TITLE = 'PostgreSQL数据库';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 4, ID from TBL_COURSE where TITLE = 'Ruby程序设计';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 4, ID from TBL_COURSE where TITLE = 'Ruby Web Frameworks: Rails';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 4, ID from TBL_COURSE where TITLE = 'Web服务器部署';

insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 5, ID from TBL_COURSE where TITLE = 'System Maintenance';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 5, ID from TBL_COURSE where TITLE = 'Shell脚本编程';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 5, ID from TBL_COURSE where TITLE = 'SCM版本管理: Git';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 5, ID from TBL_COURSE where TITLE = 'JavaScript';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 5, ID from TBL_COURSE where TITLE = '数据结构与算法';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 5, ID from TBL_COURSE where TITLE = 'HTML5 and CSS3';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 5, ID from TBL_COURSE where TITLE = 'MariaDB/MySQL数据库';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 5, ID from TBL_COURSE where TITLE = 'PostgreSQL数据库';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 5, ID from TBL_COURSE where TITLE = 'Python程序设计';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 5, ID from TBL_COURSE where TITLE = 'Python Web Frameworks: Django, Flask';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 5, ID from TBL_COURSE where TITLE = 'Web服务器部署';

insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 7, ID from TBL_COURSE where TITLE = 'Java程序设计';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 7, ID from TBL_COURSE where TITLE = 'SQLite开发';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 7, ID from TBL_COURSE where TITLE = 'Android开发';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 7, ID from TBL_COURSE where TITLE = 'Cocos2d编程';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 7, ID from TBL_COURSE where TITLE = 'OpenGL 3D编程';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 7, ID from TBL_COURSE where TITLE = 'Unity游戏开发';

insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 8, ID from TBL_COURSE where TITLE = 'Swift程序设计';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 8, ID from TBL_COURSE where TITLE = 'SQLite开发';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 8, ID from TBL_COURSE where TITLE = 'iOS开发';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 8, ID from TBL_COURSE where TITLE = 'Cocos2d编程';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 8, ID from TBL_COURSE where TITLE = 'OpenGL 3D编程';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 8, ID from TBL_COURSE where TITLE = 'Unity游戏开发';

insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 18, ID from TBL_COURSE where TITLE = 'C/C++程序设计';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 18, ID from TBL_COURSE where TITLE = 'ARM体系结构';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 18, ID from TBL_COURSE where TITLE = '嵌入式系统常用Bus及I/O接口技术';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 18, ID from TBL_COURSE where TITLE = '汇编语言程序设计（ARM版）';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 18, ID from TBL_COURSE where TITLE = 'C语言本质';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 18, ID from TBL_COURSE where TITLE = '纯汇编精简版Bootloader开发';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 18, ID from TBL_COURSE where TITLE = 'Bootloader（g-bios/u-boot）开发';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 18, ID from TBL_COURSE where TITLE = 'Linux内核分析与开发';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 18, ID from TBL_COURSE where TITLE = 'Linux设备驱动开发';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 18, ID from TBL_COURSE where TITLE = 'Linux rootfs与BusyBox';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 18, ID from TBL_COURSE where TITLE = 'Linux系统构建';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 18, ID from TBL_COURSE where TITLE = 'GNU Toolchain';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 18, ID from TBL_COURSE where TITLE = '系统底层软件调试：工具及技巧';

insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 16, ID from TBL_COURSE where TITLE = '云计算入门';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 16, ID from TBL_COURSE where TITLE = 'Python程序设计';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 16, ID from TBL_COURSE where TITLE = '网络安全';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 16, ID from TBL_COURSE where TITLE = 'KVM虚拟化';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 16, ID from TBL_COURSE where TITLE = 'OpenStack';

insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 15, ID from TBL_COURSE where TITLE = '云计算入门';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 15, ID from TBL_COURSE where TITLE = '网络安全';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 15, ID from TBL_COURSE where TITLE = 'Java程序设计';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 15, ID from TBL_COURSE where TITLE = 'Hadoop';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 15, ID from TBL_COURSE where TITLE = 'MS SQL Server数据库';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 15, ID from TBL_COURSE where TITLE = 'Oracle数据库';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 15, ID from TBL_COURSE where TITLE = 'NoSQL与非关系型数据库';

insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 10, ID from TBL_COURSE where TITLE = '敏捷开发';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 10, ID from TBL_COURSE where TITLE = 'CMMI管理';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 10, ID from TBL_COURSE where TITLE = 'UML设计';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 10, ID from TBL_COURSE where TITLE = 'Bugzilla and Issue Track';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 10, ID from TBL_COURSE where TITLE = '经典算法——逻辑与表达的乐趣';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 10, ID from TBL_COURSE where TITLE = 'TCP/IP协议剖析及开发';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 10, ID from TBL_COURSE where TITLE = '设计模式';

insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 20, ID from TBL_COURSE where TITLE = '计算机科学导论（ICS）';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 20, ID from TBL_COURSE where TITLE = '计算机组成原理与操作系统';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 20, ID from TBL_COURSE where TITLE = '计算机图形学';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 20, ID from TBL_COURSE where TITLE = '多媒体技术';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 20, ID from TBL_COURSE where TITLE = '数据库技术';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 20, ID from TBL_COURSE where TITLE = '计算机网络';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 20, ID from TBL_COURSE where TITLE = 'C-like Programming Languages';
insert into TBL_COURSE_CATEGORY (CATEGORY_ID, COURSE_ID) select 20, ID from TBL_COURSE where TITLE = '数据结构与算法';


insert into TBL_USER (USER_NAME, FULL_NAME, PASSWORD, MAIL, PHONE, GENDER) values ('admin', 'Administer', 'maxwit', 'admin@maxwit.com', '11111111111', 'M');

insert into TBL_ADMIN (ID, PRIVILEGE) select ID, 15 from TBL_USER where USER_NAME = 'admin';


insert into TBL_LESSON (TITLE, COURSE_ID, DESCRIPTION) values ('title01', 1, 'description01');
insert into TBL_LESSON (TITLE, COURSE_ID, DESCRIPTION) values ('title02', 1, 'description02');
insert into TBL_LESSON (TITLE, COURSE_ID, DESCRIPTION) values ('title03', 1, 'description03');

insert into TBL_LESSON (TITLE, COURSE_ID, DESCRIPTION) values ('title01', 2, 'description01');
insert into TBL_LESSON (TITLE, COURSE_ID, DESCRIPTION) values ('title02', 2, 'description02');
insert into TBL_LESSON (TITLE, COURSE_ID, DESCRIPTION) values ('title03', 2, 'description03');

insert into TBL_LESSON (TITLE, COURSE_ID, DESCRIPTION) values ('title01', 3, 'description01');
insert into TBL_LESSON (TITLE, COURSE_ID, DESCRIPTION) values ('title02', 3, 'description02');
insert into TBL_LESSON (TITLE, COURSE_ID, DESCRIPTION) values ('title03', 3, 'description03');

insert into TBL_LESSON (TITLE, COURSE_ID, DESCRIPTION) values ('title01', 4, 'description01');
insert into TBL_LESSON (TITLE, COURSE_ID, DESCRIPTION) values ('title02', 4, 'description02');
insert into TBL_LESSON (TITLE, COURSE_ID, DESCRIPTION) values ('title03', 4, 'description03');

insert into TBL_LESSON (TITLE, COURSE_ID, DESCRIPTION) values ('title01', 5, 'description01');
insert into TBL_LESSON (TITLE, COURSE_ID, DESCRIPTION) values ('title02', 5, 'description02');
insert into TBL_LESSON (TITLE, COURSE_ID, DESCRIPTION) values ('title03', 5, 'description03');

insert into TBL_LESSON (TITLE, COURSE_ID, DESCRIPTION) values ('title01', 6, 'description01');
insert into TBL_LESSON (TITLE, COURSE_ID, DESCRIPTION) values ('title02', 6, 'description02');
insert into TBL_LESSON (TITLE, COURSE_ID, DESCRIPTION) values ('title03', 6, 'description03');

insert into TBL_LESSON (TITLE, COURSE_ID, DESCRIPTION) values ('title01', 7, 'description01');
insert into TBL_LESSON (TITLE, COURSE_ID, DESCRIPTION) values ('title02', 7, 'description02');
insert into TBL_LESSON (TITLE, COURSE_ID, DESCRIPTION) values ('title03', 7, 'description03');

insert into TBL_LESSON (TITLE, COURSE_ID, DESCRIPTION) values ('title01', 8, 'description01');
insert into TBL_LESSON (TITLE, COURSE_ID, DESCRIPTION) values ('title02', 8, 'description02');
insert into TBL_LESSON (TITLE, COURSE_ID, DESCRIPTION) values ('title03', 8, 'description03');

insert into TBL_LESSON (TITLE, COURSE_ID, DESCRIPTION) values ('title01', 14, 'description01');
insert into TBL_LESSON (TITLE, COURSE_ID, DESCRIPTION) values ('title02', 14, 'description02');
insert into TBL_LESSON (TITLE, COURSE_ID, DESCRIPTION) values ('title03', 14, 'description03');

insert into TBL_LESSON (TITLE, COURSE_ID, DESCRIPTION) values ('title01', 16, 'description01');
insert into TBL_LESSON (TITLE, COURSE_ID, DESCRIPTION) values ('title02', 16, 'description02');
insert into TBL_LESSON (TITLE, COURSE_ID, DESCRIPTION) values ('title03', 16, 'description03');
