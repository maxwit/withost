CREATE TABLE TBL_TEACHER
(
  id integer,
  name varchar(255),
  nick varchar(255),
  password varchar(255),
  CONSTRAINT tbl_teacher_pkey PRIMARY KEY (id)
);


CREATE TABLE TBL_TEAM
(
  id integer,
  teacher_id integer,
  CONSTRAINT tbl_team_pkey PRIMARY KEY (id)
);


CREATE TABLE TBL_COURSE
(
  id integer,
  price integer,
  title varchar(255) NOT NULL,
  CONSTRAINT tbl_course_pkey PRIMARY KEY (id),
  CONSTRAINT uk_h8k7p4hln6v3u38l0ol637elo UNIQUE (title)
);

CREATE TABLE TBL_CATEGORY
(
  id integer,
  title varchar(255) NOT NULL,
  CONSTRAINT tbl_category_pkey PRIMARY KEY (id),
  CONSTRAINT uk_1by980g4j1ugfvhbqq2do8gnu UNIQUE (title)
);


CREATE TABLE TBL_COURSE_CATEGORY
(
  course_id integer NOT NULL,
  category_id integer NOT NULL
);


CREATE TABLE TBL_USER
(
  id integer,
  certified char(1),
  degree varchar(255),
  full_name varchar(255),
  gender character(1),
  mail varchar(255) NOT NULL,
  password varchar(255) NOT NULL,
  phone varchar(255),
  pid varchar(19),
  reg_date timestamp,
  user_name varchar(255),
  team_id integer,
  CONSTRAINT tbl_user_pkey PRIMARY KEY (id),
  CONSTRAINT uk_d6tho5pxk6qd8xem6vwou8sdp UNIQUE (phone),
  CONSTRAINT uk_eyhwfee2m7xra94ao5rgu7aue UNIQUE (mail),
  CONSTRAINT uk_hjqumoudatq2l1w28halhritq UNIQUE (pid),
  CONSTRAINT uk_s9ie0m36dohw89edvc6249yd0 UNIQUE (user_name)
);


CREATE TABLE TBL_ADMIN
(
  id integer NOT NULL,
  level integer,
  CONSTRAINT tbl_admin_pkey PRIMARY KEY (id)
);

CREATE TABLE TBL_APPLIED
(
  apply_date timestamp,
  current integer,
  score integer,
  course_id integer NOT NULL,
  user_id integer NOT NULL,
  CONSTRAINT tbl_applied_pkey PRIMARY KEY (course_id, user_id)
);

CREATE TABLE TBL_BUDDY
(
  i_id integer NOT NULL,
  u_id integer NOT NULL,
  CONSTRAINT tbl_buddy_pkey PRIMARY KEY (i_id, u_id)
);


CREATE TABLE TBL_COURSE_DEPEND
(
  source_id integer NOT NULL,
  depend_id integer NOT NULL,
  CONSTRAINT tbl_course_depend_pkey PRIMARY KEY (source_id, depend_id)
);

CREATE TABLE TBL_COURSE_IMPROVE
(
  source_id integer NOT NULL,
  improve_id integer NOT NULL,
  CONSTRAINT tbl_course_improve_pkey PRIMARY KEY (source_id, improve_id)
);


CREATE TABLE TBL_SUITE
(
  id integer,
  code varchar(255) NOT NULL,
  title varchar(255) NOT NULL,
  CONSTRAINT tbl_suite_pkey PRIMARY KEY (id),
  CONSTRAINT uk_en9xivgf2d278dgj3cclg08ja UNIQUE (title),
  CONSTRAINT uk_q7os4t16v1tkyskamxxhp3anr UNIQUE (code)
);

CREATE TABLE TBL_COURSE_SUITE
(
  course_id integer NOT NULL,
  suite_id integer NOT NULL
);

CREATE TABLE TBL_COURSE_TEACHER
(
  course_id integer NOT NULL,
  teacher_id integer NOT NULL,
  CONSTRAINT tbl_course_teacher_pkey PRIMARY KEY (course_id, teacher_id)
);


CREATE TABLE TBL_EDUCATION
(
  id integer,
  degree varchar(255),
  enddate date,
  major varchar(255),
  school varchar(255),
  startdate date,
  user_id integer,
  CONSTRAINT tbl_education_pkey PRIMARY KEY (id)
);


CREATE TABLE TBL_HISTORY
(
  id integer,
  ip varchar(255),
  logindate timestamp,
  user_id integer,
  CONSTRAINT tbl_history_pkey PRIMARY KEY (id)
);


CREATE TABLE TBL_LESSON
(
  id integer,
  description varchar(255),
  title varchar(255),
  course_id integer,
  CONSTRAINT tbl_lesson_pkey PRIMARY KEY (id)
);


CREATE TABLE TBL_PROJECT
(
  id integer,
  teacher_id integer,
  CONSTRAINT tbl_project_pkey PRIMARY KEY (id)
);


CREATE TABLE TBL_WORK
(
  id integer,
  company varchar(255),
  enddate date,
  position varchar(255),
  responsibility varchar(255),
  startdate date,
  user_id integer,
  CONSTRAINT tbl_work_pkey PRIMARY KEY (id)
);
