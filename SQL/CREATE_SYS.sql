--================================= Создание базы данных и табличных пространств ========================================--

\c postgres
CREATE DATABASE clinic_db ENCODING = 'UNICODE';
\c clinic_db
CREATE SCHEMA clinic;
SET SCHEMA 'clinic';


--================================= Создание системных таблиц, которые используют приложения ========================================--
\c clinic_db
SET SCHEMA 'clinic';

CREATE TABLE sys_names (
id int PRIMARY KEY NOT NULL,
name varchar(100) NOT NULL UNIQUE
);

CREATE TABLE sys_fields_types(
id_name int REFERENCES sys_names(id) NOT NULL,
numb int NOT NULL,
type_field int NOT NULL,
PRIMARY KEY(id_name, numb)
);

CREATE TABLE sys_input_UPD_columns(
id_name int REFERENCES sys_names(id) NOT NULL,
numb int NOT NULL,
column_name varchar(100) NOT NULL,
PRIMARY KEY(id_name, numb)
);


CREATE TABLE sys_comboBox_columns(
id_name int REFERENCES sys_names(id) NOT NULL,
numb int NOT NULL,
column_name varchar(100) NOT NULL,
PRIMARY KEY(id_name, numb)
);

-- // columnType = 1 - TextBoxColumn
-- // columnType = 2 - ComboboxColumn
-- // columnType = 3 - ButtonColumn

-- //  Переделать INSERT
CREATE TABLE sys_dataGridView_columns(
id_name int REFERENCES sys_names(id) NOT NULL,
numb int NOT NULL,
dataPropertyName varchar(100) NOT NULL,
headerText varchar(100) NOT NULL,
visible boolean NOT NULL,
width int NOT NULL,
readOnly boolean NOT NULL,
columnType int NOT NULL,
PRIMARY KEY(id_name, numb)
);


-- // Список имеющегося API базы данных
INSERT INTO sys_names VALUES
(1, 'fun_sel_login_worker'),
(2, 'fun_sel_graph'),
(3, 'fun_upd_ins_graph'),
(4, 'fun_sel_template'),
(5, 'fun_ins_templ'),
(6, 'fun_upd_templ'),
(7, 'fun_upd_ins_graph_with_temp'),
(8, 'fun_upd_worker_medworker'),
(9, 'fun_upd_doctor'),
(10, 'fun_del_worker'),
(11, 'fun_sel_post_in_depart'),
(12, 'fun_sel_post_in_office'),
(13, 'fun_scal_is_doc'),
(14, 'fun_ins_worker'),
(15, 'fun_ins_medworker'),
(16, 'fun_ins_doctor'),
(17, 'fun_scal_who_is_this'),
(18, 'fun_sel_worker'),
(19, 'fun_sel_medworker'),
(20, 'fun_sel_doctor'),
(21, 'fun_scal_is_null_temp'),
(22, 'fun_scal_building'),
(23, 'fun_ins_pacient'),
(24, 'fun_ins_district_record'),
(25, 'fun_sel_talons'),
(26, 'fun_sel_get_time'),
(27, 'fun_ins_records'),
(28, 'fun_sel_graph_with_office_and_date'),
(29, 'fun_sel_patients_with_police'),
(30, 'fun_sel_patients_with_FIO'),
(31, 'fun_sel_doctors_by_office'),
(32, 'fun_scal_del_graph'),
(33, 'fun_upd_clear_temp'),
(34, 'fun_del_temp'),
(35, 'fun_scal_ins_addres'),
(36, 'fun_sel_login_pacient'),
(37, 'fun_sel_doctors_with_post'),
(38, 'fun_sel_doctor_with_room_and_office'),
(39, 'view_streets'),
(40, 'view_lgots'),
(41, 'view_offices'),
(42, 'view_templnames'),
(43, 'view_patients_district'),
(44, 'view_patients'),
(45, 'employments'),
(46, 'fun_sel_building'),
(47, 'view_workers'),
(48, 'view_docktors');

-- // Типы входных параметров
INSERT INTO sys_fields_types VALUES
(1, 1, 6), (1, 2, 6), (2, 1, 7),(2, 2, 9),(3, 1, 7),(3, 2, 9),(3, 3, 20),(3, 4, 20),(3, 5, 9),(4, 1, 22),(5, 1, 22),(6, 1, 22),(6, 2, 9),(6, 3, 20), (6, 4, 20),(6, 5, 9),(7, 1, 22),(7, 2, 9),(7, 3, 7),(7, 4, 9), (8, 1, 6),(8, 2, 22),(8, 3, 22), (8, 4, 22),(8, 5, 7),(8, 6, 22), (9, 1, 6), (9, 2, 22),(9, 3, 22),(9, 4, 22),(9, 5, 7),(9, 6, 22),(9, 7, 9),(9, 8, 22),(9, 9, 9), (10, 1, 6), (11, 1, 6),(12, 1, 9),(13, 1, 9),(14, 1, 6),(14, 2, 6),(14, 3, 22),(14, 4, 22),(14, 5, 22),(14, 6, 9), (14, 7, 7),(14, 8, 7),(14, 9, 22),(15, 1, 6),(15, 2, 6),(15, 3, 22),(15, 4, 22),(15, 5, 22), (15, 6, 9),(15, 7, 7),(15, 8, 7),(15, 9, 22),(15, 10, 9), (16, 1, 6),(16, 2, 6),(16, 3, 22),(16, 4, 22),(16, 5, 22),(16, 6, 9),(16, 7, 7),(16, 8, 7), (16, 9, 22),(16, 10, 9),(16, 11, 9),(16, 12, 22),(16, 13, 9), (17, 1, 6),(18, 1, 6),(19, 1, 6),(20, 1, 6),(21, 1, 22),(22, 1, 22),(22, 2, 6), (23, 1, 6),(23, 2, 22),(23, 3, 22),(23, 4, 22),(23, 5, 7),(23, 6, 9),(23, 7, 9),(23, 8, 6),(23, 9, 7), (23, 10, 22), (23, 11, 6), (23, 12, 6), (23, 13, 2), (23, 14, 22),(23, 15, 9), (24, 1, 7),(24, 2, 6),(25, 1, 6),(25, 2, 7),(26, 1, 7),(26, 2, 9),(27, 1, 7),(27, 2, 9),(27, 3, 6),(27, 4, 20),(28, 1, 9),(28, 2, 7),(29, 1, 22),(29, 2, 2),(30, 1, 22),(30, 2, 2),(31, 1, 9),(32, 1, 7),(32, 2, 9),(33, 1, 22),(33, 2, 9),(34, 1, 22),(35, 1, 22),(35, 2, 6),(36, 1, 6),(37, 1, 9),(38, 1, 9), (46, 1, 22);

-- // Названия колонок, возвращаемые SELECT запросом, для заполнения DataGridView/Combobox, и используемые UPDATE запросом в качестве входных параметров
INSERT INTO sys_input_UPD_columns VALUES
(3, 1, 'date_field'),
(3, 2, 'id_doctor'),
(3, 3, 'begin_time'),
(3, 4, 'end_time'),
(3, 5, 'time_field'),
(6, 1, 'template'),
(6, 2, 'week_day'),
(6, 3, 'begin_time'),
(6, 4, 'end_time'),
(6, 5, 'time_field');

-- // Названия колонок, необходимых для установки свойств ValueMember и DisplayMember у comboBox
INSERT INTO sys_comboBox_columns VALUES
(11, 1, 'id_post'),
(11, 2, 'name'),
(12, 1, 'id_post'),
(12, 2, 'name'),
(26, 1, 'free_time'),
(26, 2, 'free_time'),
(31, 1, 'id_doctor'),
(31, 2, 'FIO'),
(39, 1, 'street'),
(39, 2, 'street'),
(40, 1, 'id_lgot'),
(40, 2, 'content'),
(41, 1, 'id_office'),
(41, 2, 'name'),
(42, 1, 'temp_name'),
(42, 2, 'temp_name'),
(45, 1, 'id_employment'),
(45, 2, 'name'),
(46, 1, 'building'),
(46, 2, 'building'),
(47, 1, 'login'),
(47, 2, 'info'),
(48, 1, 'id_doctor'),
(48, 2, 'FIO');


-- // Для Button (ColumnType = 3)
-- // HeaderText -> Свойство Text у колонки dataGridView (Свойство HeaderText = "")

-- // Название колонок, необходимых для установки свойства DataPropertyName у dataGridView
INSERT INTO sys_dataGridView_columns VALUES
(2, 1, 'FIO', 'ФИО', true, 200, true, 1),
(2, 2, 'post', 'Должность', true, 130, true, 1),
(2, 3, 'begin_time', 'Начало', true, 100, false, 2),
(2, 4, 'end_time', 'Конец', true, 100, false, 2),
(2, 5, 'time_field', 'Прием(мин.)', true, 100, false, 2),

(4, 1, 'display_day', 'День недели', true, 120, true, 1),
(4, 2, 'begin_time', 'Начало работы', true, 150, false, 2),
(4, 3, 'end_time', 'Конец работы', true, 150, false, 2),
(4, 4, 'time_field', 'Время на прием', true, 150, false, 2),

(25, 1, 'number_tal', '№ талона', true, 80, true, 1),
(25, 2, 'date', 'Дата', true, 70, true, 1),
(25, 3, 'id_doc', 'id_doc', false, 0, true, 1),
(25, 4, 'FIO', 'Врач', true, 150, true, 1),
(25, 5, 'post_name', 'Специальность', true, 120, true, 1),
(25, 6, 'time_field', 'Время', true, 65, true, 1),
(25, 7, 'room', 'Кабинет', true, 55, true, 1),
(25, 8, '', 'Получить талон', true, 100, true, 3),

(28, 1, 'FIO', 'ФИО врача', true, 250, true, 1),
(28, 2, 'begin_time', 'Начало приема', true, 110, true, 1),
(28, 3, 'end_time', 'Конец приема', true, 110, true, 1),

(29, 1, 'number_policy', 'Номер медицинского полиса', true, 200, true, 1),
(29, 2, 'FIO', 'Пациент',  true, 300, true, 1),
(29, 3, 'nak', 'НАК',  true, 100, true, 1),

(30, 1, 'number_policy', 'Номер медицинского полиса', true, 200, true, 1),
(30, 2, 'FIO', 'Пациент',  true, 300, true, 1),
(30, 3, 'nak', 'НАК',  true, 100, true, 1),

(37, 1, 'id_doctor', 'id', false, 30, true, 1),
(37, 2, 'FIO', 'ФИО врача', true, 200, true, 1),
(37, 3, 'room', 'Кабинет', true, 120, true, 1),
(37, 4, '', 'Записаться', true, 100, true, 3),

(43, 1, 'number_policy', 'Номер медицинского полиса', true, 200, true, 1),
(43, 2, 'FIO', 'Пациент',  true, 300, true, 1),
(43, 3, 'nak', 'НАК',  true, 100, true, 1),

(44, 1, 'number_policy', 'Номер медицинского полиса', true, 200, true, 1),
(44, 2, 'FIO', 'Пациент',  true, 300, true, 1),
(44, 3, 'nak', 'НАК',  true, 100, true, 1);
