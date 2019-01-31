
--========================================== Создание таблиц ============================================================--
CREATE TABLE offices (
  id_office serial PRIMARY KEY,
  name varchar(45) NOT NULL
);

CREATE TABLE posts (
  id_post serial PRIMARY KEY,
  name varchar(45) NOT NULL,
  department char(1) CHECK (department in ('A','L','H')) NOT NULL, 
  is_doc boolean NOT NULL DEFAULT false
);

CREATE TABLE office_posts (
  post int REFERENCES posts(id_post),
  office int REFERENCES offices(id_office),
  PRIMARY KEY(post, office) 
);

CREATE TABLE workers (
  login char(40) PRIMARY KEY,
  password char(32) NOT NULL,
  last_name varchar(45) NOT NULL,
  first_name varchar(45) NOT NULL,
  middle_name varchar(45) NOT NULL,
  post int REFERENCES posts(id_post) NOT NULL,
  date_hiring date NOT NULL,
  birthday date NOT NULL,
  photo varchar(250) DEFAULT NULL
);

CREATE TABLE med_workers (
  worker char(40) PRIMARY KEY REFERENCES workers(login),
  office int REFERENCES offices(id_office) NOT NULL
);

CREATE TABLE doctors (
  id_doctor serial PRIMARY KEY,
  worker char(40) REFERENCES workers(login) NOT NULL UNIQUE,
  room int NOT NULL,
  education varchar(100) NOT NULL,
  experience_bf int NOT NULL
);

CREATE TABLE districts (
  district int PRIMARY KEY,
  doctor int REFERENCES doctors(id_doctor)
);

CREATE TABLE addresses(
  id_address serial PRIMARY KEY,
  street varchar(100) NOT NULL,
  building char(10) NOT NULL,
  district int REFERENCES districts(district) NOT NULL
);

CREATE TABLE employments(
  id_employment serial PRIMARY KEY,
  name varchar(100) NOT NULL
);

CREATE TABLE patients (
  number_policy char(19) PRIMARY KEY,
  last_name varchar(45) NOT NULL,
  first_name varchar(45) NOT NULL,
  middle_name varchar(45) NOT NULL,
  date_registration date NOT NULL,
  address int REFERENCES addresses(id_address) NOT NULL,
  apartment int NOT NULL,
  phone char(16) NOT NULL,
  birthday date NOT NULL,
  ins_company varchar(60) NOT NULL,

  lgot char(3),
  snils char(16),
  gender boolean,
  work_place varchar(200),
  employment int REFERENCES employments(id_employment) NOT NULL,
  nak int
);

CREATE TABLE district_records (
  date date,
  patient char(19) REFERENCES patients(number_policy),
  PRIMARY KEY(date, patient) 
);

CREATE TABLE graphics (
  date date,
  doctor int REFERENCES doctors(id_doctor),
  begin_time time NOT NULL,
  end_time time NOT NULL,
  time int NOT NULL,
  PRIMARY KEY(date, doctor) 
);

CREATE TABLE records (
  date date,
  doctor int REFERENCES doctors (id_doctor),
  patient char(19) REFERENCES patients (number_policy),
  time time NOT NULL,
  coupon int NOT NULL,
  ready boolean NOT NULL DEFAULT false,
  PRIMARY KEY(date, doctor, patient)
);

CREATE TABLE templates (
  temp_name varchar(45),
  week_day int CHECK (week_day in (1,2,3,4,5)),
  begin_time time DEFAULT NULL,
  end_time time DEFAULT NULL,
  time int DEFAULT NULL,
  PRIMARY KEY(temp_name, week_day)
);

CREATE TABLE lgots(
	id_lgot char(3) PRIMARY KEY,
	name text DEFAULT NULL
);

\c postgres


--// Дополнительные таблицы 
/*
CREATE TABLE mkb(
  id_mkb char(20) PRIMARY KEY,
  name text NOT NULL
);

CREATE TABLE case_disease(
  doctor int REFERENCES doctors (id_doctor),
  patient char(19) REFERENCES patients (number_policy),
  diagnosis char(20) REFERENCES mkb (id_mkb),
  PRIMARY KEY(doctor, patient)
);

--//Журнал направлений(госпитализаций), сделать place - PRIMARY
CREATE TABLE log_hosp (
  date date,
  doctor int REFERENCES doctors(id_doctor),
  patient char(19) REFERENCES patients(number_policy),
  place varchar(200) NOT NULL,
  PRIMARY KEY(date, doctor, patient)
);

--//Журнал рецептов, выписанных врачем
CREATE TABLE log_prescription (
  date date,
  doctor int REFERENCES doctors(id_doctor),
  patient char(19) REFERENCES patients(number_policy),
  medication varchar(50),
  PRIMARY KEY(date, doctor, patient, medication)
);

--//Журнал рецептов, выписанных врачем
CREATE TABLE log_sick (
  date date,
  doctor int REFERENCES doctors(id_doctor),
  patient char(19) REFERENCES patients(number_policy),
  date_begin date NOT NULL,
  date_end date NOT NULL,
  PRIMARY KEY(date, doctor, patient)
 );
 */ 
