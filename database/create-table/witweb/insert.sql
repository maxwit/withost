insert into TBL_CATEGORY (id, title) values (1, 'HTML5');
insert into TBL_CATEGORY (id, title) values (2, 'Web服务器端开发:(Java EE方向)');
insert into TBL_CATEGORY (id, title) values (3, 'Web服务器端开发:(PHP方向)');
insert into TBL_CATEGORY (id, title) values (4, 'Web服务器端开发:(Ruby方向)');
insert into TBL_CATEGORY (id, title) values (5, 'Web服务器端开发:(Python方向)');
insert into TBL_CATEGORY (id, title) values (7, 'Web移动应用:(Android方向)');
insert into TBL_CATEGORY (id, title) values (8, '移动应用:(iOS方向)');
insert into TBL_CATEGORY (id, title) values (10, '项目管理与敏捷开发');
insert into TBL_CATEGORY (id, title) values (15, '云计算:(大数据方向)');
insert into TBL_CATEGORY (id, title) values (16, '云计算:(虚拟化方向)');
insert into TBL_CATEGORY (id, title) values (18, 'ARM体系结构与Linux内核');
insert into TBL_CATEGORY (id, title) values (20, '大学课程');


insert into TBL_COURSE (title) values ('System Maintenance');
insert into TBL_COURSE (title) values ('C-like Programming Languages');
insert into TBL_COURSE (title) values ('C-like Programming Languages: C/C++');
insert into TBL_COURSE (title) values ('C-like Programming Languages: Java');
insert into TBL_COURSE (title) values ('JavaScript');
insert into TBL_COURSE (title) values ('C-like Programming Languages: Swift');
insert into TBL_COURSE (title) values ('C-like Programming Languages: C#');
insert into TBL_COURSE (title) values ('计算机科学导论（ICS）');
insert into TBL_COURSE (title) values ('计算机组成原理与操作系统');
insert into TBL_COURSE (title) values ('数据库技术');
insert into TBL_COURSE (title) values ('计算机网络');
insert into TBL_COURSE (title) values ('计算机图形学');
insert into TBL_COURSE (title) values ('多媒体技术');
insert into TBL_COURSE (title) values ('Shell脚本编程');
insert into TBL_COURSE (title) values ('Application Development');
insert into TBL_COURSE (title) values ('HTML5 and CSS3');
insert into TBL_COURSE (title) values ('Bootstrap');
insert into TBL_COURSE (title) values ('数据结构与算法');
insert into TBL_COURSE (title) values ('经典算法——逻辑与表达的乐趣');
insert into TBL_COURSE (title) values ('SCM版本管理: Git');
insert into TBL_COURSE (title) values ('敏捷开发');
insert into TBL_COURSE (title) values ('CMMI管理');
insert into TBL_COURSE (title) values ('UML设计');
insert into TBL_COURSE (title) values ('Bugzilla and Issue Track');
insert into TBL_COURSE (title) values ('Java Advanced Programming');
insert into TBL_COURSE (title) values ('JSP and Java EE');
insert into TBL_COURSE (title) values ('Java Web Frameworks');
insert into TBL_COURSE (title) values ('PHP程序设计');
insert into TBL_COURSE (title) values ('PHP Web Frameworks: CI, YII');
insert into TBL_COURSE (title) values ('.Net Frameworks');
insert into TBL_COURSE (title) values ('Ruby程序设计');
insert into TBL_COURSE (title) values ('Ruby Web Frameworks: Rails');
insert into TBL_COURSE (title) values ('Python程序设计');
insert into TBL_COURSE (title) values ('Python Web Frameworks: Django, Flask');
insert into TBL_COURSE (title) values ('Web服务器部署');
insert into TBL_COURSE (title) values ('MariaDB/MySQL数据库');
insert into TBL_COURSE (title) values ('PostgreSQL数据库');
insert into TBL_COURSE (title) values ('MS SQL Server数据库');
insert into TBL_COURSE (title) values ('Oracle数据库');
insert into TBL_COURSE (title) values ('NoSQL与非关系型数据库');
insert into TBL_COURSE (title) values ('SQLite开发');
insert into TBL_COURSE (title) values ('网络安全');
insert into TBL_COURSE (title) values ('云计算入门');
insert into TBL_COURSE (title) values ('KVM虚拟化');
insert into TBL_COURSE (title) values ('OpenStack');
insert into TBL_COURSE (title) values ('Hadoop');
insert into TBL_COURSE (title) values ('ARM体系结构');
insert into TBL_COURSE (title) values ('嵌入式系统常用Bus及I/O接口技术');
insert into TBL_COURSE (title) values ('汇编语言程序设计（ARM版）');
insert into TBL_COURSE (title) values ('C语言本质');
insert into TBL_COURSE (title) values ('纯汇编精简版Bootloader开发');
insert into TBL_COURSE (title) values ('Bootloader（g-bios/u-boot）开发');
insert into TBL_COURSE (title) values ('Linux内核分析与开发');
insert into TBL_COURSE (title) values ('Linux设备驱动开发');
insert into TBL_COURSE (title) values ('Linux rootfs与BusyBox');
insert into TBL_COURSE (title) values ('Linux系统构建');
insert into TBL_COURSE (title) values ('GNU Toolchain');
insert into TBL_COURSE (title) values ('系统底层软件调试：工具及技巧');
insert into TBL_COURSE (title) values ('Android开发');
insert into TBL_COURSE (title) values ('iOS开发');
insert into TBL_COURSE (title) values ('Cocos2d编程');
insert into TBL_COURSE (title) values ('OpenGL 3D编程');
insert into TBL_COURSE (title) values ('Unity游戏开发');
insert into TBL_COURSE (title) values ('TCP/IP协议剖析及开发');
insert into TBL_COURSE (title) values ('设计模式');

insert into TBL_COURSE_CATEGORY (category_id, course_id) select 1, id from TBL_COURSE where title = 'HTML5 and CSS3';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 1, id from TBL_COURSE where title = 'JavaScript';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 1, id from TBL_COURSE where title = 'Bootstrap';

insert into TBL_COURSE_CATEGORY (category_id, course_id) select 2, id from TBL_COURSE where title = 'System Maintenance';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 2, id from TBL_COURSE where title = 'Shell脚本编程';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 2, id from TBL_COURSE where title = 'SCM版本管理: Git';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 2, id from TBL_COURSE where title = 'JavaScript';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 2, id from TBL_COURSE where title = '数据结构与算法';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 2, id from TBL_COURSE where title = 'HTML5 and CSS3';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 2, id from TBL_COURSE where title = 'MariaDB/MySQL数据库';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 2, id from TBL_COURSE where title = 'PostgreSQL数据库';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 2, id from TBL_COURSE where title = 'Application Development';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 2, id from TBL_COURSE where title = 'Java程序设计';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 2, id from TBL_COURSE where title = 'Java Advanced Programming';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 2, id from TBL_COURSE where title = 'JSP and Java EE';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 2, id from TBL_COURSE where title = 'Java Web Frameworks';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 2, id from TBL_COURSE where title = 'Web服务器部署';

insert into TBL_COURSE_CATEGORY (category_id, course_id) select 3, id from TBL_COURSE where title = 'System Maintenance';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 3, id from TBL_COURSE where title = 'Shell脚本编程';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 3, id from TBL_COURSE where title = 'SCM版本管理: Git';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 3, id from TBL_COURSE where title = 'JavaScript';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 3, id from TBL_COURSE where title = '数据结构与算法';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 3, id from TBL_COURSE where title = 'HTML5 and CSS3';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 3, id from TBL_COURSE where title = 'MariaDB/MySQL数据库';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 3, id from TBL_COURSE where title = 'PostgreSQL数据库';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 3, id from TBL_COURSE where title = 'PHP程序设计';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 3, id from TBL_COURSE where title = 'PHP Web Frameworks: CI, YII';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 3, id from TBL_COURSE where title = 'Web服务器部署';

insert into TBL_COURSE_CATEGORY (category_id, course_id) select 4, id from TBL_COURSE where title = 'System Maintenance';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 4, id from TBL_COURSE where title = 'Shell脚本编程';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 4, id from TBL_COURSE where title = 'SCM版本管理: Git';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 4, id from TBL_COURSE where title = 'JavaScript';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 4, id from TBL_COURSE where title = '数据结构与算法';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 4, id from TBL_COURSE where title = 'HTML5 and CSS3';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 4, id from TBL_COURSE where title = 'MariaDB/MySQL数据库';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 4, id from TBL_COURSE where title = 'PostgreSQL数据库';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 4, id from TBL_COURSE where title = 'Ruby程序设计';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 4, id from TBL_COURSE where title = 'Ruby Web Frameworks: Rails';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 4, id from TBL_COURSE where title = 'Web服务器部署';

insert into TBL_COURSE_CATEGORY (category_id, course_id) select 5, id from TBL_COURSE where title = 'System Maintenance';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 5, id from TBL_COURSE where title = 'Shell脚本编程';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 5, id from TBL_COURSE where title = 'SCM版本管理: Git';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 5, id from TBL_COURSE where title = 'JavaScript';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 5, id from TBL_COURSE where title = '数据结构与算法';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 5, id from TBL_COURSE where title = 'HTML5 and CSS3';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 5, id from TBL_COURSE where title = 'MariaDB/MySQL数据库';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 5, id from TBL_COURSE where title = 'PostgreSQL数据库';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 5, id from TBL_COURSE where title = 'Python程序设计';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 5, id from TBL_COURSE where title = 'Python Web Frameworks: Django, Flask';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 5, id from TBL_COURSE where title = 'Web服务器部署';

insert into TBL_COURSE_CATEGORY (category_id, course_id) select 7, id from TBL_COURSE where title = 'Java程序设计';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 7, id from TBL_COURSE where title = 'SQLite开发';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 7, id from TBL_COURSE where title = 'Android开发';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 7, id from TBL_COURSE where title = 'Cocos2d编程';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 7, id from TBL_COURSE where title = 'OpenGL 3D编程';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 7, id from TBL_COURSE where title = 'Unity游戏开发';

insert into TBL_COURSE_CATEGORY (category_id, course_id) select 8, id from TBL_COURSE where title = 'Swift程序设计';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 8, id from TBL_COURSE where title = 'SQLite开发';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 8, id from TBL_COURSE where title = 'iOS开发';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 8, id from TBL_COURSE where title = 'Cocos2d编程';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 8, id from TBL_COURSE where title = 'OpenGL 3D编程';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 8, id from TBL_COURSE where title = 'Unity游戏开发';

insert into TBL_COURSE_CATEGORY (category_id, course_id) select 18, id from TBL_COURSE where title = 'C/C++程序设计';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 18, id from TBL_COURSE where title = 'ARM体系结构';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 18, id from TBL_COURSE where title = '嵌入式系统常用Bus及I/O接口技术';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 18, id from TBL_COURSE where title = '汇编语言程序设计（ARM版）';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 18, id from TBL_COURSE where title = 'C语言本质';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 18, id from TBL_COURSE where title = '纯汇编精简版Bootloader开发';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 18, id from TBL_COURSE where title = 'Bootloader（g-bios/u-boot）开发';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 18, id from TBL_COURSE where title = 'Linux内核分析与开发';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 18, id from TBL_COURSE where title = 'Linux设备驱动开发';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 18, id from TBL_COURSE where title = 'Linux rootfs与BusyBox';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 18, id from TBL_COURSE where title = 'Linux系统构建';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 18, id from TBL_COURSE where title = 'GNU Toolchain';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 18, id from TBL_COURSE where title = '系统底层软件调试：工具及技巧';

insert into TBL_COURSE_CATEGORY (category_id, course_id) select 16, id from TBL_COURSE where title = '云计算入门';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 16, id from TBL_COURSE where title = 'Python程序设计';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 16, id from TBL_COURSE where title = '网络安全';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 16, id from TBL_COURSE where title = 'KVM虚拟化';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 16, id from TBL_COURSE where title = 'OpenStack';

insert into TBL_COURSE_CATEGORY (category_id, course_id) select 15, id from TBL_COURSE where title = '云计算入门';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 15, id from TBL_COURSE where title = '网络安全';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 15, id from TBL_COURSE where title = 'Java程序设计';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 15, id from TBL_COURSE where title = 'Hadoop';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 15, id from TBL_COURSE where title = 'MS SQL Server数据库';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 15, id from TBL_COURSE where title = 'Oracle数据库';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 15, id from TBL_COURSE where title = 'NoSQL与非关系型数据库';

insert into TBL_COURSE_CATEGORY (category_id, course_id) select 10, id from TBL_COURSE where title = '敏捷开发';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 10, id from TBL_COURSE where title = 'CMMI管理';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 10, id from TBL_COURSE where title = 'UML设计';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 10, id from TBL_COURSE where title = 'Bugzilla and Issue Track';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 10, id from TBL_COURSE where title = '经典算法——逻辑与表达的乐趣';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 10, id from TBL_COURSE where title = 'TCP/IP协议剖析及开发';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 10, id from TBL_COURSE where title = '设计模式';

insert into TBL_COURSE_CATEGORY (category_id, course_id) select 20, id from TBL_COURSE where title = '计算机科学导论（ICS）';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 20, id from TBL_COURSE where title = '计算机组成原理与操作系统';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 20, id from TBL_COURSE where title = '计算机图形学';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 20, id from TBL_COURSE where title = '多媒体技术';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 20, id from TBL_COURSE where title = '数据库技术';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 20, id from TBL_COURSE where title = '计算机网络';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 20, id from TBL_COURSE where title = 'C-like Programming Languages';
insert into TBL_COURSE_CATEGORY (category_id, course_id) select 20, id from TBL_COURSE where title = '数据结构与算法';


insert into TBL_USER (user_name, full_name, password, mail, phone, gender) values ('admin', 'Administer', 'maxwit', 'admin@maxwit.com', '11111111111', 'M');

insert into TBL_ADMIN (id, privilege) select id, 15 from TBL_USER where user_name='admin';


insert into TBL_LESSON (title, course_id, description) values ('title01', 1, 'description01');
insert into TBL_LESSON (title, course_id, description) values ('title02', 1, 'description02');
insert into TBL_LESSON (title, course_id, description) values ('title03', 1, 'description03');

insert into TBL_LESSON (title, course_id, description) values ('title01', 2, 'description01');
insert into TBL_LESSON (title, course_id, description) values ('title02', 2, 'description02');
insert into TBL_LESSON (title, course_id, description) values ('title03', 2, 'description03');

insert into TBL_LESSON (title, course_id, description) values ('title01', 3, 'description01');
insert into TBL_LESSON (title, course_id, description) values ('title02', 3, 'description02');
insert into TBL_LESSON (title, course_id, description) values ('title03', 3, 'description03');

insert into TBL_LESSON (title, course_id, description) values ('title01', 4, 'description01');
insert into TBL_LESSON (title, course_id, description) values ('title02', 4, 'description02');
insert into TBL_LESSON (title, course_id, description) values ('title03', 4, 'description03');

insert into TBL_LESSON (title, course_id, description) values ('title01', 5, 'description01');
insert into TBL_LESSON (title, course_id, description) values ('title02', 5, 'description02');
insert into TBL_LESSON (title, course_id, description) values ('title03', 5, 'description03');

insert into TBL_LESSON (title, course_id, description) values ('title01', 6, 'description01');
insert into TBL_LESSON (title, course_id, description) values ('title02', 6, 'description02');
insert into TBL_LESSON (title, course_id, description) values ('title03', 6, 'description03');

insert into TBL_LESSON (title, course_id, description) values ('title01', 7, 'description01');
insert into TBL_LESSON (title, course_id, description) values ('title02', 7, 'description02');
insert into TBL_LESSON (title, course_id, description) values ('title03', 7, 'description03');

insert into TBL_LESSON (title, course_id, description) values ('title01', 8, 'description01');
insert into TBL_LESSON (title, course_id, description) values ('title02', 8, 'description02');
insert into TBL_LESSON (title, course_id, description) values ('title03', 8, 'description03');

insert into TBL_LESSON (title, course_id, description) values ('title01', 14, 'description01');
insert into TBL_LESSON (title, course_id, description) values ('title02', 14, 'description02');
insert into TBL_LESSON (title, course_id, description) values ('title03', 14, 'description03');

insert into TBL_LESSON (title, course_id, description) values ('title01', 16, 'description01');
insert into TBL_LESSON (title, course_id, description) values ('title02', 16, 'description02');
insert into TBL_LESSON (title, course_id, description) values ('title03', 16, 'description03');
