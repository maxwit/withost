CREATE TABLE TBL_TEACHER
(
  id serial NOT NULL,
  name character varying(255),
  nick character varying(255),
  password character varying(255),
  CONSTRAINT tbl_teacher_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE TBL_TEACHER
  OWNER TO admin;


CREATE TABLE TBL_TEAM
(
  id serial NOT NULL,
  teacher_id integer,
  CONSTRAINT tbl_team_pkey PRIMARY KEY (id),
  CONSTRAINT fk_dpuam8x6bylsb348y2h2wte6 FOREIGN KEY (teacher_id)
      REFERENCES TBL_TEACHER (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE TBL_TEAM
  OWNER TO admin;


CREATE TABLE TBL_COURSE
(
  id serial NOT NULL,
  price integer,
  title character varying(255) NOT NULL,
  CONSTRAINT tbl_course_pkey PRIMARY KEY (id),
  CONSTRAINT uk_h8k7p4hln6v3u38l0ol637elo UNIQUE (title)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE TBL_COURSE
  OWNER TO admin;

CREATE TABLE TBL_CATEGORY
(
  id serial NOT NULL,
  title character varying(255) NOT NULL,
  CONSTRAINT tbl_category_pkey PRIMARY KEY (id),
  CONSTRAINT uk_1by980g4j1ugfvhbqq2do8gnu UNIQUE (title)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE TBL_CATEGORY
  OWNER TO admin;


CREATE TABLE TBL_COURSE_CATEGORY
(
  course_id integer NOT NULL,
  category_id integer NOT NULL,
  CONSTRAINT fk_ackou6yntkyloflc8hpui99g6 FOREIGN KEY (category_id)
      REFERENCES TBL_CATEGORY (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_i725a3n8ljd6rghrk2fx71ivp FOREIGN KEY (course_id)
      REFERENCES TBL_COURSE (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE TBL_COURSE_CATEGORY
  OWNER TO admin;


CREATE TABLE TBL_USER
(
  id serial NOT NULL,
  certified boolean,
  degree character varying(255),
  full_name character varying(255),
  gender character(1),
  mail character varying(255) NOT NULL,
  password character varying(255) NOT NULL,
  phone character varying(255),
  pid character varying(19),
  regdate timestamp without time zone,
  user_name character varying(255),
  team_id integer,
  CONSTRAINT tbl_user_pkey PRIMARY KEY (id),
  CONSTRAINT fk_i5py5jfeds75pefhj87buorbw FOREIGN KEY (team_id)
      REFERENCES TBL_TEAM (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT uk_d6tho5pxk6qd8xem6vwou8sdp UNIQUE (phone),
  CONSTRAINT uk_eyhwfee2m7xra94ao5rgu7aue UNIQUE (mail),
  CONSTRAINT uk_hjqumoudatq2l1w28halhritq UNIQUE (pid),
  CONSTRAINT uk_s9ie0m36dohw89edvc6249yd0 UNIQUE (user_name)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE TBL_USER
  OWNER TO admin;


CREATE TABLE TBL_ADMIN
(
  id integer NOT NULL,
  level integer,
  CONSTRAINT tbl_admin_pkey PRIMARY KEY (id),
  CONSTRAINT fk_gal4rh6ct9sc7itpke11ybuos FOREIGN KEY (id)
      REFERENCES TBL_USER (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE TBL_ADMIN
  OWNER TO admin;

CREATE TABLE TBL_APPLIED
(
  apply_date timestamp without time zone,
  current integer,
  score integer,
  course_id integer NOT NULL,
  user_id integer NOT NULL,
  CONSTRAINT tbl_applied_pkey PRIMARY KEY (course_id, user_id),
  CONSTRAINT fk_5hxkk6uox604tmas2kr9q4y7t FOREIGN KEY (user_id)
      REFERENCES TBL_USER (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_i3e0j5732ugkwg6gv1d7ygaof FOREIGN KEY (course_id)
      REFERENCES TBL_COURSE (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE TBL_APPLIED
  OWNER TO admin;

CREATE TABLE TBL_BUDDY
(
  i_id integer NOT NULL,
  u_id integer NOT NULL,
  CONSTRAINT tbl_buddy_pkey PRIMARY KEY (i_id, u_id),
  CONSTRAINT fk_39ubf1ntuhj7gw7hovgfdkf79 FOREIGN KEY (i_id)
      REFERENCES TBL_USER (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_n4u5o00cm0i1iu2tm9baran8l FOREIGN KEY (u_id)
      REFERENCES TBL_USER (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE TBL_BUDDY
  OWNER TO admin;


CREATE TABLE TBL_COURSE_DEPEND
(
  source_id integer NOT NULL,
  depend_id integer NOT NULL,
  CONSTRAINT tbl_course_depend_pkey PRIMARY KEY (source_id, depend_id),
  CONSTRAINT fk_b8qty4abdxjlmsqa2vfii36u6 FOREIGN KEY (source_id)
      REFERENCES TBL_COURSE (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_c3aokeroceyivgomcom0nsv75 FOREIGN KEY (depend_id)
      REFERENCES TBL_COURSE (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE TBL_COURSE_DEPEND
  OWNER TO admin;

CREATE TABLE TBL_COURSE_IMPROVE
(
  source_id integer NOT NULL,
  improve_id integer NOT NULL,
  CONSTRAINT tbl_course_improve_pkey PRIMARY KEY (source_id, improve_id),
  CONSTRAINT fk_2kccshteina5ln38r4lqka4j0 FOREIGN KEY (improve_id)
      REFERENCES TBL_COURSE (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_r33qewxukuy94cd2urg9bqq5p FOREIGN KEY (source_id)
      REFERENCES TBL_COURSE (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE TBL_COURSE_IMPROVE
  OWNER TO admin;


CREATE TABLE TBL_SUITE
(
  id serial NOT NULL,
  code character varying(255) NOT NULL,
  title character varying(255) NOT NULL,
  CONSTRAINT tbl_suite_pkey PRIMARY KEY (id),
  CONSTRAINT uk_en9xivgf2d278dgj3cclg08ja UNIQUE (title),
  CONSTRAINT uk_q7os4t16v1tkyskamxxhp3anr UNIQUE (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE TBL_SUITE
  OWNER TO admin;

CREATE TABLE TBL_COURSE_SUITE
(
  course_id integer NOT NULL,
  suite_id integer NOT NULL,
  CONSTRAINT fk_6pk67wlv1wi9cgsx29u3m6fh9 FOREIGN KEY (course_id)
      REFERENCES TBL_COURSE (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_gc9qjgjukqhr449pmem6gbhxp FOREIGN KEY (suite_id)
      REFERENCES TBL_SUITE (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE TBL_COURSE_SUITE
  OWNER TO admin;

CREATE TABLE TBL_COURSE_TEACHER
(
  course_id integer NOT NULL,
  teacher_id integer NOT NULL,
  CONSTRAINT tbl_course_teacher_pkey PRIMARY KEY (course_id, teacher_id),
  CONSTRAINT fk_bo7oq6hx2tewh6mqlfpuunr7f FOREIGN KEY (teacher_id)
      REFERENCES TBL_TEACHER (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_mw1vc6w3eqt5ep6amevheb6wu FOREIGN KEY (course_id)
      REFERENCES TBL_COURSE (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE TBL_COURSE_TEACHER
  OWNER TO admin;


CREATE TABLE TBL_EDUCATION
(
  id serial NOT NULL,
  degree character varying(255),
  enddate date,
  major character varying(255),
  school character varying(255),
  startdate date,
  user_id integer,
  CONSTRAINT tbl_education_pkey PRIMARY KEY (id),
  CONSTRAINT fk_k97iqi5i4p328n36tvyyewpmi FOREIGN KEY (user_id)
      REFERENCES TBL_USER (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE TBL_EDUCATION
  OWNER TO admin;


CREATE TABLE TBL_HISTORY
(
  id serial NOT NULL,
  ip character varying(255),
  logindate timestamp without time zone,
  user_id integer,
  CONSTRAINT tbl_history_pkey PRIMARY KEY (id),
  CONSTRAINT fk_bplvrd5hxrbxx60r1vrdlamt9 FOREIGN KEY (user_id)
      REFERENCES TBL_USER (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE TBL_HISTORY
  OWNER TO admin;


CREATE TABLE TBL_LESSON
(
  id serial NOT NULL,
  description character varying(255),
  title character varying(255),
  course_id integer,
  CONSTRAINT tbl_lesson_pkey PRIMARY KEY (id),
  CONSTRAINT fk_34htrinpixb0o5afhnnruoiv8 FOREIGN KEY (course_id)
      REFERENCES TBL_COURSE (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE TBL_LESSON
  OWNER TO admin;


CREATE TABLE TBL_PROJECT
(
  id serial NOT NULL,
  teacher_id integer,
  CONSTRAINT tbl_project_pkey PRIMARY KEY (id),
  CONSTRAINT fk_n2v56k12s5rtn2wkcfbtftoyx FOREIGN KEY (teacher_id)
      REFERENCES TBL_TEACHER (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE TBL_PROJECT
  OWNER TO admin;


CREATE TABLE TBL_WORK
(
  id serial NOT NULL,
  company character varying(255),
  enddate date,
  "position" character varying(255),
  responsibility character varying(255),
  startdate date,
  user_id integer,
  CONSTRAINT tbl_work_pkey PRIMARY KEY (id),
  CONSTRAINT fk_4vf5gf9pq7eysm0ib42l1ts20 FOREIGN KEY (user_id)
      REFERENCES TBL_USER (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE TBL_WORK
  OWNER TO admin;
