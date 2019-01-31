\c clinic_db
SET SCHEMA 'clinic';

--//==================================== ТРИГГЕРЫ ================================================//--

--// Триггер контроля повторной записи на участок
--*******************************************************************************| trig_check_ins_district_records |
CREATE FUNCTION fun_trig_check_ins_district_records()
RETURNS trigger AS 
$$
DECLARE
	exist int;
BEGIN 
	SET SCHEMA 'clinic';
	SELECT count(*) INTO exist FROM district_records WHERE date >= current_date and patient = NEW.patient;
	IF exist <> 0 THEN
		RAISE EXCEPTION 'Данный пациент уже записан к участковому врачу!';
		RETURN NULL;
	ELSE
		RETURN NEW;
	END IF;
END;
$$ language plpgsql;

CREATE TRIGGER trig_check_ins_district_records
	BEFORE INSERT on district_records
	FOR EACH ROW
	EXECUTE PROCEDURE fun_trig_check_ins_district_records();

	

--// Триггер контроля повторной регистрации пациента
--*******************************************************************************| trig_check_ins_patients |	
CREATE FUNCTION fun_trig_check_ins_patients()
RETURNS trigger AS 
$$
DECLARE 
	exist int;
BEGIN
	SET SCHEMA 'clinic';
	SELECT count(*) INTO exist FROM patients WHERE number_policy = NEW.number_policy;
	IF exist <> 0 THEN
		RAISE EXCEPTION 'Такой пациент уже зарегестрирован!';
		RETURN NULL;
	ELSE
		RETURN NEW;
	END IF;
END;
$$ language plpgsql;

CREATE TRIGGER trig_check_ins_patients
	BEFORE INSERT on patients
	FOR EACH ROW
	EXECUTE PROCEDURE fun_trig_check_ins_patients();

/**/

--// Триггер контроля повторной записи к врачу
--*******************************************************************************| trig_check_ins_records |		
CREATE FUNCTION fun_trig_check_ins_records()
RETURNS trigger AS 
$$
DECLARE
	exist int;
	talon int;
BEGIN   
	SET SCHEMA 'clinic';
	SELECT count(*) INTO exist FROM records 
	WHERE date = NEW.date and doctor = NEW.doctor and time = NEW.time;
        
	IF exist = 0 THEN
		SELECT count(*) INTO exist FROM records 
		WHERE date = NEW.date and doctor = NEW.doctor and patient = NEW.patient;
		
		IF exist = 0 THEN
			SELECT count(*) INTO talon FROM records WHERE date = NEW.date and doctor = NEW.doctor;
			NEW.coupon = talon + 1;
			RETURN NEW;
		ELSE
			RAISE EXCEPTION 'Ошибка:Вы уже записаны на эту дату!';
			RETURN NULL;
		END IF;
	ELSE
		RAISE EXCEPTION 'Ошибка: Данное время уже занято!';
		RETURN NULL;
	END IF;
END;
$$ language plpgsql;

CREATE TRIGGER trig_check_ins_records
	BEFORE INSERT on records
	FOR EACH ROW
	EXECUTE PROCEDURE fun_trig_check_ins_records();


--// Триггер проверки логина при регистрации нового сотрудника
--*******************************************************************************| trig_check_ins_workers |	
CREATE FUNCTION fun_trig_check_ins_workers()
RETURNS trigger AS 
$$
DECLARE
	exist int;
BEGIN
    SET SCHEMA 'clinic';
    SELECT count(*) INTO exist FROM workers WHERE login = NEW.login;
    
    IF exist <> 0 THEN
		RAISE EXCEPTION 'Сотрудник с таким логином уже зарегестрирован в системе!';
		RETURN NULL;
	ELSE
		RETURN NEW;
    END IF;
END;
$$ language plpgsql;

CREATE TRIGGER trig_check_ins_workers
	BEFORE INSERT on workers
	FOR EACH ROW
	EXECUTE PROCEDURE fun_trig_check_ins_workers();

	
	
--// Триггер удаляющий все связные с работником записи, при его удалении(увольнении)
--*******************************************************************************| trig_del_worker |
CREATE FUNCTION fun_trig_del_worker()
RETURNS trigger AS 
$$
DECLARE
	exist int;
	doc int;
BEGIN
	SET SCHEMA 'clinic';
	SELECT count(*) INTO exist FROM med_workers WHERE worker = OLD.login;
	IF exist <> 0 THEN
		SELECT count(*) INTO exist FROM doctors WHERE worker = OLD.login;
		 
		IF exist = 0 THEN
			DELETE FROM med_workers WHERE worker = OLD.login;
			RETURN OLD;
		 ELSE
			SELECT id_doctor INTO doc FROM doctors WHERE worker = OLD.login;
			SELECT count(*) INTO exist FROM districts WHERE doctor = doc;
			
			IF exist = 0 THEN                
				DELETE FROM records WHERE doctor = doc;
				DELETE FROM graphics WHERE doctor = doc;
                
				DELETE FROM doctors WHERE worker = OLD.login;
				DELETE FROM med_workers WHERE worker = OLD.login;
				RETURN OLD;
			ELSE
				RAISE EXCEPTION 'Данный врач - участковый. Нельзя оставить участок без врача. Привяжите к участку другого врача, а затем увольте данного.';
			END IF;
		END IF;
	ELSE
		RETURN OLD;
    END IF;
END;
$$ language plpgsql;

CREATE TRIGGER trig_del_worker
	BEFORE DELETE on workers
	FOR EACH ROW
	EXECUTE PROCEDURE fun_trig_del_worker();


--//============================ LOGIN ================================================//--


CREATE FUNCTION fun_sel_login_worker(
	plogin char(40), ppassword char(32)
)
RETURNS TABLE(
	id char(1), ythastk boolean, 
	last_name varchar(45), first_name varchar(45),
	middle_name varchar(45),photo varchar(250),
	post varchar(45), office varchar(45), office_id int
) AS 
$$
DECLARE
	vexist int; vpost int; vid char(1); 
	vis_doc boolean; vychastkovyi boolean;
	FIO varchar(200); voffice varchar(45); 
	voffice_id int;
BEGIN
	SET SCHEMA 'clinic';
	vychastkovyi = false;
	vis_doc = false;
	voffice = '';
	
	SELECT count(*) INTO vexist 
	FROM workers
	WHERE login = plogin and password = ppassword;
	
	IF vexist <> 0 THEN --//если зарегистрированин (работник)
						
		SELECT w.post INTO vpost
		FROM workers as w
		WHERE login = plogin;
					
		IF vpost = 25 THEN vid = 'G';
		ELSIF vpost = 23 THEN vid = 'Z';
		ELSIF vpost = 31 THEN vid = 'R';
		ELSE --// Если обычный работник
			SELECT concat(w.last_name,' ',w.first_name,' ',w.middle_name) INTO FIO
			FROM workers as w
			WHERE login = plogin;						
			RAISE EXCEPTION 'Ошибка: Уважаемый %, для вас не предусмотрен вход в систему.', FIO; 
		END IF;
			
		IF vpost = 23 THEN 
			SELECT name INTO voffice
			FROM med_workers as m, offices
			WHERE worker=plogin and m.office=id_office;

			SELECT m.office INTO voffice_id
			FROM med_workers as m
			WHERE m.worker=plogin;
		END IF;
						
		RETURN QUERY
		SELECT vid, vychastkovyi, w.last_name, w.first_name, w.middle_name, w.photo, name, voffice, voffice_id
		FROM workers as w, posts
		WHERE login = plogin and w.post = id_post;
	ELSE
		RAISE EXCEPTION 'Ошибка: Неверный логин или пароль!';
	END IF;
END;
$$ language plpgsql;


--//Вход пациента 
--*******************************************************************************| fun_sel_login_patient |
CREATE FUNCTION fun_sel_login_pacient(
	pnumber_policy char(19)
)
RETURNS TABLE(
	number_policy char(19),	last_name varchar(45),
	first_name varchar(45),	middle_name varchar(45)
) AS
$$
DECLARE 
	exist int;
BEGIN
	SET SCHEMA 'clinic';
	SELECT count(*) INTO exist
	FROM patients as p WHERE p.number_policy = pnumber_policy;
	
	IF exist <> 0 THEN
		RETURN QUERY
		SELECT p.number_policy, p.last_name, p.first_name, p.middle_name
		FROM patients  as p WHERE p.number_policy = pnumber_policy;
	ELSE
		RAISE EXCEPTION 'Ошибка: Пациент с таким номером полиса не зарегестрирован!';
	END IF;
END;
$$ language plpgsql;


--//============================ GRAPHS ================================================//--

--//Вывод расписания врачей за определенный день
--****************************************************************************| fun_sel_graph |
CREATE FUNCTION fun_sel_graph(
	pdate date, poffice int
)
RETURNS TABLE (
	id_doctor int, FIO text,  post varchar(45), 
	begin_time time, end_time time, time_field int, date_field date
) AS
$$
BEGIN
	SET SCHEMA 'clinic';
	RETURN QUERY
	SELECT d.id_doctor, concat(w.last_name, ' ', w.first_name, ' ', w.middle_name), p.name, 
 	(SELECT g.begin_time FROM graphics as g WHERE d.id_doctor = doctor AND date = pdate),
 	(SELECT g.end_time FROM graphics as g WHERE d.id_doctor = doctor AND date = pdate),
 	(SELECT g.time FROM graphics as g WHERE d.id_doctor = doctor AND date = pdate), pdate
 	FROM workers as w, doctors as d, posts as p, med_workers as m
 	WHERE w.login = d.worker and w.post = p.id_post and m.worker = w.login and m.office = poffice;
END;
$$ language plpgsql;


--//Обновление расписания врачей за определенный день
--*************************************************************************| fun_upd_ins_graph |
CREATE FUNCTION fun_upd_ins_graph(
	pdate date, pdoctor int, pbegin time, pend time, ptime int
)  
RETURNS void AS
$$
DECLARE 
	exist int; have_rec int;
BEGIN  
    SET SCHEMA 'clinic';
    IF (pdate IS NOT NULL) and (pdoctor IS NOT NULL) and (pbegin IS NOT NULL) 
	 and (pend IS NOT NULL) and  (ptime IS NOT NULL) THEN
	
	SELECT count(*) INTO exist
	FROM graphics
	WHERE date = pdate and doctor = pdoctor;
    
	IF exist = 0 THEN
		INSERT INTO graphics
		VALUES (pdate, pdoctor, pbegin, pend, ptime);
	ELSE
		SELECT count(*) INTO have_rec 
		FROM records 
		WHERE date = pdate and doctor = pdoctor;
        
		IF have_rec = 0 THEN
			UPDATE graphics
			SET begin_time = pbegin, end_time = pend,time = ptime
			WHERE date = pdate and doctor = pdoctor;
		ELSE
			RAISE EXCEPTION 'Ошибка: Расписание нельзя изменить, так как на этот день уже записанны пациенты!';
		END IF;
	END IF;
     END IF;
END;
$$ language plpgsql;


CREATE FUNCTION fun_scal_del_graph(
	pdate date, pdoctor int
)
RETURNS void AS
$$
DECLARE 
	exist int; 
BEGIN
	SET SCHEMA 'clinic';
	
	SELECT count(*) INTO exist FROM graphics
	WHERE date = pdate and doctor = pdoctor;
	
	IF exist <> 0 THEN
		SELECT count(*) INTO exist FROM records 
		WHERE date = pdate and doctor = pdoctor;

		IF exist = 0 THEN
			DELETE FROM graphics WHERE date = pdate and doctor = pdoctor;
		ELSE
			RAISE EXCEPTION 'Ошибка: Расписание нельзя удалить, так как на этот день уже записанны пациенты!';
		END IF;
	END IF;
END;
$$ language plpgsql;

--// Заполнение расписания на неделю/месяц
--*************************************************************************| fun_upd_ins_graph_with_temp |
CREATE FUNCTION fun_upd_ins_graph_with_temp(
	ptemp_name varchar(45), pdoctor int, pbegin_date date, pcount_day int
)
RETURNS void AS
$$
DECLARE 
	i int;
	notnull boolean;
BEGIN
	SET SCHEMA 'clinic';
	
		SELECT EXTRACT(DOW FROM pbegin_date) INTO i;
		pcount_day = pcount_day + i;
	
		BEGIN
			WHILE i <> pcount_day LOOP
				IF i%7 <> 6 and  i%7 <> 0 THEN
					PERFORM fun_upd_ins_graph(
						pbegin_date,
						pdoctor,
						(SELECT begin_time FROM templates WHERE week_day = i%7 and temp_name = ptemp_name),
						(SELECT end_time FROM templates WHERE week_day = i%7 and temp_name = ptemp_name),
						(SELECT time FROM templates WHERE week_day = i%7 and temp_name = ptemp_name)
					);
				END IF;
				pbegin_date = pbegin_date + 1;
				i = i+1;
			END LOOP; 
		END;  
END;
$$ language plpgsql;




--//========================================== TEMPLATES ================================================//--

--//Имеющиеся шаблоны
--*******************************************************************************| view_templnames |
CREATE VIEW view_templnames AS
	SELECT temp_name FROM templates GROUP BY temp_name;

	
--//Вывод конкретного шаблона
--*******************************************************************************| fun_sel_template |
CREATE FUNCTION fun_sel_template(
	ptemp_name varchar(45)
)
RETURNS TABLE  (
	template varchar(45), week_day int, display_day text, 
	begin_time time, end_time time, time_field int
)AS
$$
BEGIN
	SET SCHEMA 'clinic';
	RETURN QUERY
	SELECT t.temp_name, t.week_day,
		CASE 
			WHEN t.week_day = 1 THEN 'Понедельник'
			WHEN t.week_day = 2 THEN 'Вторник'
			WHEN t.week_day = 3 THEN 'Среда'
			WHEN t.week_day = 4 THEN 'Четверг'
			WHEN t.week_day = 5 THEN 'Пятница'			
		END, 
	t.begin_time, t.end_time, t.time 
	FROM templates as t
	WHERE t.temp_name = ptemp_name
	ORDER BY t.week_day;
END;
$$ language plpgsql;


CREATE FUNCTION fun_upd_clear_temp(
	ptemplate varchar(45), pweek_day int
)
RETURNS void AS
$$
DECLARE
	eixist int;
BEGIN
	SET SCHEMA 'clinic';	
	SELECT count(*) INTO eixist FROM templates
	WHERE temp_name = ptemplate and week_day = pweek_day;
	
	IF eixist <> 0 THEN
		UPDATE templates 
		SET begin_time = null, end_time = null, time = null
		WHERE temp_name = ptemplate and week_day = pweek_day;
	END IF;
END;
$$ language plpgsql;

CREATE FUNCTION fun_del_temp(
	ptemplate varchar(45)
)
RETURNS void AS
$$
DECLARE
	eixist int;
BEGIN
	SET SCHEMA 'clinic';
	IF ptemplate = 'Новый' THEN
		RAISE EXCEPTION 'Ошибка: Нельзя удалять еще не созданный шаблон!';	
	ELSE
		SELECT count(*) INTO eixist FROM templates WHERE temp_name = ptemplate;
		IF eixist <> 0 THEN
			DELETE FROM templates WHERE temp_name = ptemplate;
		END IF;
	END IF;
END;
$$ language plpgsql;



--// Создание шаблона
--*******************************************************************************| fun_ins_templ |
CREATE FUNCTION fun_ins_templ(
	ptemp_name varchar(45)
)
RETURNS void AS
$$
DECLARE
	eixist int;
BEGIN 
	SET SCHEMA 'clinic';
	--//Проверка, нет ли такого шаблона уже
	SELECT count(*) INTO eixist 
	FROM templates WHERE temp_name = ptemp_name;
	
	IF eixist = 0 THEN
		--//Создание пустого шаблона
		BEGIN
			FOR i IN 1..5 LOOP
				INSERT INTO templates(temp_name, week_day) VALUES (ptemp_name, i);
			END LOOP;
		END;
	ELSE
		RAISE EXCEPTION 'Ошибка: Шаблон с таким именем уже существует!';
	END IF;
END;
$$ language plpgsql;


--// Обновление шаблона
--*******************************************************************************| fun_upd_templ |
CREATE FUNCTION fun_upd_templ(
	ptemp_name varchar(45), pweek_day int, 
	pbegin_time time, pend_time time, ptime int
)
RETURNS void AS
$$
BEGIN   
	SET SCHEMA 'clinic';
	UPDATE templates
	SET begin_time = pbegin_time, end_time = pend_time, time = ptime
	WHERE temp_name = ptemp_name and week_day = pweek_day;
END;
$$ language plpgsql;

--// Проверка заполнености шаблона (пригоден ли для заполнения расписания?)
--*******************************************************************************| fun_scal_is_null_temp |
CREATE FUNCTION fun_scal_is_null_temp(
	ptemp_name varchar(45)
)
RETURNS boolean AS
$$
DECLARE 
	count_notnull_rows int;
BEGIN   
	SET SCHEMA 'clinic';
	SELECT count(*) INTO count_notnull_rows 
	FROM  templates 
	WHERE (temp_name = ptemp_name) and (begin_time IS NOT NULL) and
		  (end_time IS NOT NULL) and  (time IS NOT NULL);
		  
	IF count_notnull_rows = 5 THEN RETURN true;
	ELSE RETURN false;
	END IF;
END;
$$ language plpgsql;



--//========================================== EMPLOYEES ================================================//--

--//Вывод всех врачей и их должностей
--*******************************************************************************| view_docktors |
CREATE VIEW view_docktors AS
    SELECT id_doctor, concat(name, ' - ', last_name,' ',first_name,' ',middle_name) AS FIO
    FROM doctors, workers, posts
    WHERE worker = login and post = id_post
    ORDER BY FIO;

CREATE FUNCTION fun_sel_doctors_by_office(
	poffice int
)
RETURNS TABLE  (
	id_doctor int, FIO text
)AS
$$
BEGIN
    SET SCHEMA 'clinic';
    RETURN QUERY
    SELECT d.id_doctor, concat(p.name, ' - ', w.last_name,' ', w.first_name,' ', w.middle_name)
    FROM doctors as d, workers as w, posts as p, med_workers as m
    WHERE d.worker = w.login and w.post = p.id_post and m.worker = w.login and m.office = poffice
    ORDER BY FIO;
END;
$$ language plpgsql;

--// Вывод сотрудников и их должностей
--*******************************************************************************| view_workers |
CREATE VIEW view_workers AS
    SELECT login, concat(name, ' - ', last_name, ' ',first_name, ' ', middle_name) as info
    FROM workers, posts
    WHERE post = id_post and post <> 25
    ORDER BY info;


--// Определяет, кем является работник (обычный работник - W, медработник - M, доктор - D)
--*******************************************************************************| fun_scal_who_is_this |
CREATE FUNCTION fun_scal_who_is_this(
	plogin CHAR(40)
)
RETURNS char(1) AS
$$
DECLARE 
	exist int;
BEGIN
    SET SCHEMA 'clinic';
    SELECT count(*) INTO exist FROM med_workers WHERE worker = plogin;
    
    IF exist = 0 THEN
		RETURN 'W';
    ELSE
		SELECT count(*) INTO exist FROM doctors WHERE worker = plogin;
        IF exist = 0 THEN
			RETURN 'M';
        ELSE
			RETURN 'D';
        END IF;
    END IF;
END;
$$ language plpgsql;



--// Информация о сотруднике (если он W - worker)
--*******************************************************************************| fun_sel_worker |
CREATE FUNCTION fun_sel_worker(
	plogin CHAR(40)
)
RETURNS TABLE (
	last_name varchar(45), first_name varchar(45),  middle_name varchar(45),
	birthday date, photo varchar(250), post_name varchar(45),
	department_name text
) AS
$$
BEGIN
	SET SCHEMA 'clinic';
	RETURN QUERY
	SELECT w.last_name, w.first_name, w.middle_name, w.birthday, w.photo, p.name, 
		CASE 
			WHEN p.department = 'L' THEN 'Лечебный'
			WHEN p.department = 'A' THEN 'Административный'
			WHEN p.department = 'H' THEN 'Хозяйственный'		
		END
	FROM workers as w, posts as p
	WHERE  login = plogin and w.post = p.id_post;
END;
$$ language plpgsql;



--// Информация о сотруднике (если он M - medworker)
--*******************************************************************************| fun_sel_medworker |
CREATE FUNCTION fun_sel_medworker(
	plogin CHAR(40)
)
RETURNS TABLE (
	last_name varchar(45), first_name varchar(45),  middle_name varchar(45),
	birthday date, photo varchar(250), post_name varchar(45),
	office_name varchar(45), department_name text
) AS
$$
BEGIN
	SET SCHEMA 'clinic';
	RETURN QUERY
	SELECT  w.last_name, w.first_name, w.middle_name, w.birthday, w.photo, p.name, o.name,
		CASE 
			WHEN p.department = 'L' THEN 'Лечебный'
			WHEN p.department = 'A' THEN 'Административный'
			WHEN p.department = 'H' THEN 'Хозяйственный'		
		END
	FROM workers as w, posts as p, med_workers as m, offices as o
	WHERE w.login = plogin and w.post = p.id_post and w.login = m.worker and m.office = o.id_office;
END;
$$ language plpgsql;



--// Информация о сотруднике (если он D - doctor)
--*******************************************************************************| fun_sel_doctor |
CREATE FUNCTION fun_sel_doctor(
	plogin CHAR(40)
)
RETURNS TABLE (
	last_name varchar(45), first_name varchar(45),  middle_name varchar(45),
	birthday date, photo varchar(250), post_name varchar(45),
	office_name varchar(45), room int, education varchar(100), experience int,
	department_name text
) AS
$$
BEGIN	
	SET SCHEMA 'clinic';
	--//d.experience_bf + накопленый стаж сдесь
	RETURN QUERY
	SELECT  w.last_name, w.first_name, w.middle_name, w.birthday, w.photo, 
		p.name, o.name, d.room, d.education, d.experience_bf,
		CASE 
			WHEN p.department = 'L' THEN 'Лечебный'
			WHEN p.department = 'A' THEN 'Административный'
			WHEN p.department = 'H' THEN 'Хозяйственный'		
		END
	FROM workers as w, posts as p, med_workers as m, offices as o, doctors as d
	WHERE w.login = plogin and w.post = p.id_post and w.login = m.worker 
		  and m.office = o.id_office and w.login = d.worker;
END;
$$ language plpgsql;

--// fun_sel_doctor('xjirae_1998@xaker.ru                    ');

--// Обновление если (W - worker) или (M - medworker)
--*******************************************************************************| fun_upd_worker_medworker |
CREATE FUNCTION fun_upd_worker_medworker (
	plogin CHAR(40), plast_name varchar(45), pfirst_name varchar(45),  
	pmiddle_name varchar(45), pbirthday date, pphoto varchar(250) 
)
RETURNS void AS
$$
BEGIN
	SET SCHEMA 'clinic';
	UPDATE workers
	SET last_name = plast_name, first_name = pfirst_name, middle_name = pmiddle_name, 
		birthday = pbirthday, photo = pphoto
	WHERE login = plogin;
END;	
$$ language plpgsql;



--// Обновление если (D - doctor) (добавляются новые поля: кабинет, образование, стаж)
--*******************************************************************************| fun_upd_doctor |
CREATE FUNCTION fun_upd_doctor (
	plogin CHAR(40), plast_name varchar(45), pfirst_name varchar(45),  
	pmiddle_name varchar(45), pbirthday date, pphoto varchar(250),
	proom int, peducation varchar(100), ppexperience int
)
RETURNS void AS
$$
BEGIN
	SET SCHEMA 'clinic';
	UPDATE workers
	SET last_name = plast_name, first_name = pfirst_name, middle_name = pmiddle_name,
	    birthday = pbirthday, photo = pphoto
	WHERE login = plogin;
	
	UPDATE doctors
	SET room = proom, education = peducation, experience_bf = ppexperience
	WHERE worker = plogin;
END;	
$$ language plpgsql;


--// Увольнение сотрудника (связная инфа удалится триггерами)
--*******************************************************************************| fun_del_worker |
CREATE FUNCTION fun_del_worker (
	plogin CHAR(40)
)
RETURNS void AS
$$
BEGIN
	SET SCHEMA 'clinic';
	DELETE FROM workers WHERE login = plogin;
END;	
$$ language plpgsql;


--// Добавление в штат работника (W -worker)
--*******************************************************************************| fun_ins_worker |
CREATE FUNCTION fun_ins_worker(
	plogin CHAR(40), ppassword CHAR(32), plast_name VARCHAR(45), 
	pfirst_name VARCHAR(45), pmiddle_name VARCHAR(45), ppost INT, 
	pdate_hiring DATE,pbirthday DATE, pphoto VARCHAR(250)
)
RETURNS void AS
$$
BEGIN
	SET SCHEMA 'clinic';
	IF pphoto = 'картинка по-умолчанию' THEN --//!!!!
		pphoto = null;
	END IF;
	
	INSERT INTO workers 
	VALUES (plogin, ppassword, plast_name, pfirst_name,pmiddle_name, 
			ppost, pdate_hiring, pbirthday, pphoto);
END;
$$ language plpgsql;


--// Добавление в штат медработника (M - medworker)
--*******************************************************************************| fun_ins_medworker |
CREATE FUNCTION fun_ins_medworker(
	plogin CHAR(40), ppassword CHAR(32), plast_name VARCHAR(45), 
	pfirst_name VARCHAR(45), pmiddle_name VARCHAR(45), ppost INT, 
	pdate_hiring DATE,pbirthday DATE, pphoto VARCHAR(250), poffice int
)
RETURNS void AS
$$
BEGIN
	SET SCHEMA 'clinic';
	---// START TRANSACTION;
	BEGIN
		PERFORM fun_ins_worker(plogin, ppassword, plast_name, pfirst_name, 
			pmiddle_name,ppost, pdate_hiring, pbirthday, pphoto);
		INSERT INTO med_workers VALUES (plogin, poffice);
	---// COMMIT;
	END;
END;
$$ language plpgsql;


--// Добавление в штат медработника (M - medworker)
--*******************************************************************************| fun_ins_doctor |
CREATE FUNCTION fun_ins_doctor(
	plogin CHAR(40), ppassword CHAR(32), plast_name VARCHAR(45), 
	pfirst_name VARCHAR(45), pmiddle_name VARCHAR(45), ppost INT, 
	pdate_hiring DATE,pbirthday DATE, pphoto VARCHAR(250), poffice int,
	proom int, peducation varchar(100), pexperience int
)
RETURNS void AS
$$
BEGIN
	SET SCHEMA 'clinic';
	---// START TRANSACTION;
	BEGIN
		PERFORM fun_ins_medworker(plogin, ppassword, plast_name, pfirst_name, 
				pmiddle_name, ppost, pdate_hiring, pbirthday, pphoto, poffice);
		
		INSERT INTO doctors (worker, room, education, experience_bf)
		VALUES (plogin, proom, peducation, pexperience);
	---// COMMIT;
	END;
END;
$$ language plpgsql;



--=============================================== COMBOBOXES ================================================--
  
--// Вывод отделений
--*******************************************************************************| view_offices |
CREATE VIEW view_offices AS
	SELECT id_office, name FROM offices;

--// Вывод должностей в определенном отделе(подразделении поликлиники) 
--*******************************************************************************| fun_sel_post_in_depart |
CREATE FUNCTION fun_sel_post_in_depart(
	pdepartment char(1)
)
RETURNS TABLE (
	id_post int, name varchar(45)
)AS
$$
BEGIN
	SET SCHEMA 'clinic';
	RETURN QUERY 
	SELECT p.id_post, p.name FROM posts as p 
	WHERE p.department = pdepartment;
END;
$$ language plpgsql;


--// Вывод должностей на определенном отделении(лечебном)
--*******************************************************************************| fun_sel_post_in_office | 
CREATE FUNCTION fun_sel_post_in_office(
	poffice int
)
RETURNS TABLE (
	id_post int, name varchar(45)
)AS
$$
BEGIN
	SET SCHEMA 'clinic';
	RETURN QUERY 
	SELECT p.id_post, p.name 
	FROM posts as p, office_posts as o
	WHERE o.office = poffice and o.post = p.id_post;
END;
$$ language plpgsql;



--// Врачебная ли это специальность 
--//(необходимо для отображения панели с дополнительными полями)
--*******************************************************************************| fun_scal_is_doc | 
CREATE FUNCTION fun_scal_is_doc(
	ppost int
)
RETURNS boolean AS
$$
DECLARE 
	is_doc boolean;
BEGIN
	SET SCHEMA 'clinic';
	SELECT p.is_doc INTO is_doc
	FROM posts as p WHERE p.id_post = ppost;
	RETURN is_doc;
END;
$$ language plpgsql;


--// Вывод ФИО врача и отделения, исходя из id врача
--*******************************************************************************| fun_sel_doctor_with_office | 
CREATE FUNCTION fun_sel_doctor_with_office(
	pid_doctor int
)
RETURNS TABLE (
	FIO text, office varchar(45)
)AS
$$
BEGIN
	SET SCHEMA 'clinic';
	RETURN QUERY
	SELECT concat(last_name, ' ', first_name, ' ', middle_name), o.name
	FROM worker as w, doctors as d, med_workers as m, offices as o
	WHERE d.id_doctor = pid_doctor and d.worker = w.login and 
		m.worker = w.login and m.office = o.id_office;
END;
$$ language plpgsql;



--=============================================== ПАЦИЕНТ ==================================================---

--//   РЕГИСТРАЦИЯ

--// Загрузка всех улиц, обслуживаемых поликлиникой
--*******************************************************************************| view_streets | 
CREATE VIEW view_streets AS
SELECT street FROM addresses WHERE district <> 0 GROUP BY street ORDER BY street;

	
--// Загрузка домов, исходя из выбранной улицы
--*******************************************************************************| fun_sel_building | 	
CREATE FUNCTION fun_sel_building(
	pstreet varchar(100) 
)
RETURNS TABLE (
	building char(10)
)AS
$$
BEGIN
	SET SCHEMA 'clinic';
	RETURN QUERY
	SELECT a.building FROM addresses as a WHERE a.street = pstreet;
END;
$$ language plpgsql;


--// Получение id адреса, исходя из выбранной улицы и дома
--*******************************************************************************| fun_scal_id_address |
CREATE FUNCTION fun_scal_building(
	pstreet varchar(100), pbuilding char(10) 
)
RETURNS int AS
$$
DECLARE 
	id int;
BEGIN
	SET SCHEMA 'clinic';
	SELECT id_address INTO id FROM addresses 
	WHERE street = pstreet and building = pbuilding;
	RETURN id;
END;
$$ language plpgsql;


CREATE FUNCTION fun_scal_ins_addres(
	pstreet varchar(100), pbuilding char(10)
)
RETURNS int AS
$$
DECLARE 
	id int; exist int;
BEGIN
	SET SCHEMA 'clinic';

	SELECT count(*) INTO exist FROM addresses 
	WHERE street = pstreet and building = pbuilding;
	IF exist = 0 THEN
		INSERT INTO addresses(street, building, district)
		VALUES (pstreet, pbuilding, 0);
	END IF;

	SELECT id_address INTO id FROM addresses 
	WHERE street = pstreet and building = pbuilding;
	RETURN id;
END;
$$ language plpgsql;


CREATE FUNCTION fun_scal_number_ak()
RETURNS int AS
$$
DECLARE
	index_ak int;
	exist int;
BEGIN
	index_ak = 99;
	exist = 1;
	WHILE exist <> 0 LOOP
		index_ak = index_ak +1;
		SELECT count(*) INTO exist FROM patients WHERE nak = index_ak;
	END LOOP;
	RETURN 	index_ak;
END;
$$ language plpgsql;

--// Добавление пациента
--*******************************************************************************| fun_ins_pacient |
CREATE FUNCTION fun_ins_pacient(
  pnumber_policy char(19),  plast_name varchar(45),
  pfirst_name varchar(45), pmiddle_name varchar(45),
  pdate_registration date,  paddress int,
  papartment int, pphone char(16), pbirthday date,
  pins_company varchar(60),
  plgot char(3), psnils char(16), pgender boolean,
  pwork_place varchar(200), pemployment int
)
RETURNS int AS
$$
DECLARE
	number_ak int;
BEGIN
	SET SCHEMA 'clinic';
	number_ak = fun_scal_number_ak();
	INSERT INTO patients VALUES ( pnumber_policy,  plast_name, 
				pfirst_name, pmiddle_name, pdate_registration,  
				paddress, papartment, pphone, pbirthday, 
				pins_company,plgot, psnils, pgender, pwork_place, pemployment, number_ak);
	RETURN number_ak;
END;
$$ language plpgsql;



--//Расписание врачей на определенном отделении, за определенную дату
--*******************************************************************************| fun_sel_graph_with_office_and_date |
CREATE FUNCTION fun_sel_graph_with_office_and_date(
	poffice int, pdate date
)
RETURNS TABLE (
	date date, FIO text, begin_time time, end_time time, time_field int
)AS
$$
BEGIN
	SET SCHEMA 'clinic';
	RETURN QUERY
	SELECT 	pdate, concat(w.last_name, ' ',w.first_name, ' ',w.middle_name), 
		(SELECT g.begin_time FROM graphics as g WHERE g.doctor = d.id_doctor and g.date = pdate),
		(SELECT g.end_time FROM graphics as g WHERE g.doctor = d.id_doctor and g.date = pdate),
		(SELECT g.time FROM graphics as g WHERE g.doctor = d.id_doctor and g.date = pdate)
	FROM workers as w, med_workers as m, doctors as d
	WHERE w.login = m.worker and w.login = d.worker and m.office = poffice;
END;
$$ language plpgsql;


--//Получение свободного временени для приема на заданный день
--*******************************************************************************| fun_sel_get_time |
CREATE FUNCTION fun_sel_get_time (
	pdate date, pdoctor int
)
RETURNS TABLE (
	free_time time
)AS
$$
DECLARE
	vbegin time; vend time;
	vtime int; exist int;
	minutes varchar(10);
BEGIN    
    SET SCHEMA 'clinic';
    SELECT begin_time INTO vbegin FROM graphics WHERE date = pdate and doctor = pdoctor;
    SELECT end_time INTO vend FROM graphics WHERE date = pdate and doctor = pdoctor;
	SELECT time INTO vtime FROM graphics WHERE date = pdate and doctor = pdoctor;
    
    CREATE TEMPORARY TABLE temp (time time PRIMARY KEY);
    minutes = concat(vtime,' minute');
	
    WHILE vbegin < vend LOOP
	SELECT count(*) INTO exist FROM records WHERE date = pdate and doctor = pdoctor and time = vbegin;
        IF exist = 0 THEN
			INSERT INTO temp values(vbegin);
        END IF;
	vbegin = vbegin + minutes::interval;
    END LOOP;
	
	RETURN QUERY
	SELECT * FROM temp;
END;
$$ language plpgsql;


--//Запись к врачу на прием(проверки на триггере)
--*******************************************************************************| fun_ins_records |
CREATE FUNCTION fun_ins_records(
	pdate date, pdoctor int, ppatient char(19), ptime time
)
RETURNS void AS
$$
BEGIN
	SET SCHEMA 'clinic';
	INSERT INTO records (date, doctor, patient, time)
	VALUES (pdate, pdoctor, ppatient, ptime);
END;
$$ language plpgsql;


--=============================================== ТАЛОНЫ ==================================================---

--// Вывод имеющихся талонов для конкретного пациента
--*******************************************************************************| fun_sel_talons |
CREATE FUNCTION fun_sel_talons(
	ppatient char(19), today date
)
RETURNS TABLE(
	number_tal int, date date, FIO text, id_doc int,
	post_name  varchar(45), time_field time, room int
) AS
$$
BEGIN
	SET SCHEMA 'clinic';
	RETURN QUERY
	SELECT  r.coupon, r.date, concat(w.last_name, ' ', w.first_name, ' ', w.middle_name), 
		d.id_doctor , p.name, r.time, d.room
	FROM records as r, doctors as d, workers as w, posts as p
	WHERE r.patient = ppatient and r.date >= today and
		  r.doctor = d.id_doctor and d.worker = w.login and w.post = p.id_post;
END;
$$ language plpgsql; 



--// Вывод врачей по данной специальности для записи к ним на прием
--*******************************************************************************| fun_sel_doctors_with_post |
CREATE FUNCTION fun_sel_doctors_with_post(
	ppost int
)
RETURNS TABLE(
	id_doctor int, FIO text, room int
) AS
$$
BEGIN
	SET SCHEMA 'clinic';
	RETURN QUERY
	SELECT d.id_doctor, concat(w.last_name, ' ', w.first_name, ' ', w.middle_name), d.room 
	FROM workers as w, doctors as d
	WHERE d.worker = w.login and w.post  = ppost;  
END;
$$ language plpgsql; 


CREATE FUNCTION fun_sel_doctor_with_room_and_office(
	pdoctor int
)
RETURNS TABLE(
	FIO text, office_name varchar(45), room int
) AS
$$
BEGIN
	SET SCHEMA 'clinic';
	RETURN QUERY	
	SELECT concat(w.last_name, ' ', w.first_name, ' ', w.middle_name), o.name, d.room
	FROM workers as w, med_workers as m, offices as o, doctors as d
	WHERE d.id_doctor = pdoctor and d.worker = w.login and w.login = m.worker and m.office = o.id_office;
END;
$$ language plpgsql; 



--=============================================== УЧАСТОК ==================================================---

--//Вывод информации о пациенте и его участковом враче (при вызове участкового врача)
--*******************************************************************************| fun_sel_district_record |
CREATE FUNCTION fun_sel_district_record(
	pnumber_policy char(19)
)
RETURNS TABLE(
	FIO_p text, phone char(16), address text, FIO_d text
) AS
$$
BEGIN
	SET SCHEMA 'clinic';
	RETURN QUERY
	SELECT 	
		concat(p.last_name, ' ', p.first_name, ' ', p.middle_name), p.phone, 
		concat(		
			CASE 
				WHEN position('пр. ' in a.street) = 0 THEN 'ул. '
				WHEN position('пр. ' in a.street) <> 0 THEN '' 
			END,
		a.street, ', д. ', a.building, ', кв. ', p.apartment),
		concat(w.last_name, ' ', w.first_name,' ', w.middle_name)
	FROM patients as p, addresses as a, districts as dis, doctors as d, workers as w
	
	WHERE p.number_policy = pnumber_policy and p.address = a.id_address and 
		a.district = dis.district and dis.doctor = d.id_doctor 
		and d.worker = w.login;
END;
$$ language plpgsql; 


--//Добавить запись к участковому врачу		

--*******************************************************************************| fun_ins_district_record |
CREATE FUNCTION fun_ins_district_record (
	pdate date, ppatient char(19)
)
RETURNS void AS
$$
BEGIN 	
	SET SCHEMA 'clinic';
	INSERT INTO district_records VALUES (pdate, ppatient);
END;
$$ language plpgsql;



--=============================================== НОВЫЕ ==================================================---

CREATE VIEW view_patients AS
SELECT number_policy, concat(last_name,' ', first_name, ' ', middle_name) as FIO, nak FROM patients;

CREATE VIEW view_patients_district AS
SELECT number_policy, concat(last_name,' ', first_name, ' ', middle_name) as FIO, nak 
FROM patients, addresses WHERE address = id_address and district <> 0;

CREATE FUNCTION fun_sel_patients_with_police (
	filter varchar(19), is_district boolean
)
RETURNS TABLE(
	number_policy char(19), FIO text, nak int
) AS
$$
BEGIN 	
	SET SCHEMA 'clinic';
	IF is_district THEN
		RETURN QUERY
		SELECT vp.number_policy, vp.FIO, vp.nak FROM view_patients_district as vp
		WHERE vp.number_policy LIKE concat('%',filter,'%');
	ELSE
		RETURN QUERY
		SELECT vp.number_policy, vp.FIO, vp.nak FROM view_patients as vp
		WHERE vp.number_policy LIKE concat('%',filter,'%');
	END IF;
END;
$$ language plpgsql; 

CREATE FUNCTION fun_sel_patients_with_FIO (
	filter varchar(250), is_district boolean
)
RETURNS TABLE(
	number_policy char(19), FIO text, nak int
) AS
$$
BEGIN 	
	SET SCHEMA 'clinic';
	IF is_district THEN
		RETURN QUERY
		SELECT vp.number_policy, vp.FIO, vp.nak FROM view_patients_district as vp
		WHERE vp.FIO LIKE concat('%',filter,'%');
	ELSE
		RETURN QUERY
		SELECT vp.number_policy, vp.FIO, vp.nak FROM view_patients as vp
		WHERE vp.FIO LIKE concat('%',filter,'%');
	END IF;
END;
$$ language plpgsql;



CREATE FUNCTION fun_sel_patients_medcard(
	ppatient char(19)
)
RETURNS TABLE(
	nak int, ins_company varchar(60), number_policy char(19),
	snils char(16), lgot char(3),   last_name varchar(45),
  	first_name varchar(45), middle_name varchar(45), gender text,
	birthday date, addres text, phone char(16), work_place varchar(200), 		profession text 
) AS
$$
BEGIN 
	SET SCHEMA 'clinic';
	RETURN QUERY	
	SELECT p.nak, p.ins_company, p.number_policy, p.snils, 
		CASE 
			WHEN p.lgot = 'нет' THEN ''
			ELSE p.lgot 
		END, p.last_name, p.first_name, p.middle_name, 
		CASE 
			WHEN p.gender = true THEN 'мужской'
			WHEN p.gender = false THEN 'женский' 
		END, p.birthday, 
		concat(		
			CASE 
				WHEN position('пр. ' in a.street) = 0 THEN 'ул. '
				WHEN position('пр. ' in a.street) <> 0 THEN '' 
			END,
		a.street, ', д. ', a.building, ', кв. ', p.apartment),
		p.phone, p.work_place, ''
		FROM patients as p, addresses as a, employments as e
		WHERE p.number_policy = ppatient and p.address = a.id_address
			and p.employment = e.id_employment;
END;
$$ language plpgsql;


CREATE FUNCTION fun_sel_talon(
	pdate date, pdoctor int, ppatient char(19)
)
RETURNS TABLE(
	coupon text, nak int, record_time time,lgot char(3), 
	number_policy char(19), snils char(16), FIO_p text, 
	gender text, birthday date, addres text, 
	employment varchar(45), FIO_d text
) AS
$$
BEGIN 
	SET SCHEMA 'clinic';
	RETURN QUERY

	SELECT	concat('№ ', r.coupon), p.nak, r.time,
		CASE 
			WHEN p.lgot = 'нет' THEN ''
			ELSE p.lgot 
		END, p.number_policy, p.snils, 
		concat(p.last_name,' ',p.first_name,' ',p.middle_name),
		CASE 
			WHEN p.gender = true THEN 'мужской'
			WHEN p.gender = false THEN 'женский' 
		END, p.birthday,
		concat(		
			CASE 
				WHEN position('пр. ' in a.street) = 0 THEN 'ул. '
				WHEN position('пр. ' in a.street) <> 0 THEN '' 
			END,
		a.street, ', д. ', a.building, ', кв. ', p.apartment), e.name,
		concat(w.last_name, ' ', w.first_name, ' ', w.middle_name)

	FROM patients as p, records as r, employments as e, doctors as d, workers as w, addresses as a
	WHERE r.date = pdate and r.doctor = pdoctor and r.patient = ppatient and 
		r.doctor = d.id_doctor and w.login = d.worker and a.id_address = p.address and
		r.patient = p.number_policy and p.employment = e.id_employment;
END;
$$ language plpgsql;

CREATE FUNCTION fun_scal_get_nak(
	ppatient char(19)
)
RETURNS int AS
$$
DECLARE 
	nak int;
BEGIN 
	SET SCHEMA 'clinic';	
	nak = 0;	
	SELECT p.nak INTO nak FROM patients as p
	WHERE p.number_policy = ppatient;
	RETURN nak;
END;
$$ language plpgsql;

CREATE VIEW view_lgots AS
SELECT id_lgot, concat(id_lgot, ' | ', name) as content FROM lgots;

\c postgres
