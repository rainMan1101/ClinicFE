--
-- PostgreSQL database dump
--

-- Dumped from database version 10.4 (Ubuntu 10.4-2.pgdg16.04+1)
-- Dumped by pg_dump version 10.4 (Ubuntu 10.4-2.pgdg16.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: clinic; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA clinic;


ALTER SCHEMA clinic OWNER TO postgres;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: fun_del_temp(character varying); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_del_temp(ptemplate character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION clinic.fun_del_temp(ptemplate character varying) OWNER TO postgres;

--
-- Name: fun_del_worker(character); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_del_worker(plogin character) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	SET SCHEMA 'clinic';
	DELETE FROM workers WHERE login = plogin;
END;	
$$;


ALTER FUNCTION clinic.fun_del_worker(plogin character) OWNER TO postgres;

--
-- Name: fun_ins_district_record(date, character); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_ins_district_record(pdate date, ppatient character) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN 	
	SET SCHEMA 'clinic';
	INSERT INTO district_records VALUES (pdate, ppatient);
END;
$$;


ALTER FUNCTION clinic.fun_ins_district_record(pdate date, ppatient character) OWNER TO postgres;

--
-- Name: fun_ins_doctor(character, character, character varying, character varying, character varying, integer, date, date, character varying, integer, integer, character varying, integer); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_ins_doctor(plogin character, ppassword character, plast_name character varying, pfirst_name character varying, pmiddle_name character varying, ppost integer, pdate_hiring date, pbirthday date, pphoto character varying, poffice integer, proom integer, peducation character varying, pexperience integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION clinic.fun_ins_doctor(plogin character, ppassword character, plast_name character varying, pfirst_name character varying, pmiddle_name character varying, ppost integer, pdate_hiring date, pbirthday date, pphoto character varying, poffice integer, proom integer, peducation character varying, pexperience integer) OWNER TO postgres;

--
-- Name: fun_ins_medworker(character, character, character varying, character varying, character varying, integer, date, date, character varying, integer); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_ins_medworker(plogin character, ppassword character, plast_name character varying, pfirst_name character varying, pmiddle_name character varying, ppost integer, pdate_hiring date, pbirthday date, pphoto character varying, poffice integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION clinic.fun_ins_medworker(plogin character, ppassword character, plast_name character varying, pfirst_name character varying, pmiddle_name character varying, ppost integer, pdate_hiring date, pbirthday date, pphoto character varying, poffice integer) OWNER TO postgres;

--
-- Name: fun_ins_pacient(character, character varying, character varying, character varying, date, integer, integer, character, date, character varying, character, character, boolean, character varying, integer); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_ins_pacient(pnumber_policy character, plast_name character varying, pfirst_name character varying, pmiddle_name character varying, pdate_registration date, paddress integer, papartment integer, pphone character, pbirthday date, pins_company character varying, plgot character, psnils character, pgender boolean, pwork_place character varying, pemployment integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION clinic.fun_ins_pacient(pnumber_policy character, plast_name character varying, pfirst_name character varying, pmiddle_name character varying, pdate_registration date, paddress integer, papartment integer, pphone character, pbirthday date, pins_company character varying, plgot character, psnils character, pgender boolean, pwork_place character varying, pemployment integer) OWNER TO postgres;

--
-- Name: fun_ins_records(date, integer, character, time without time zone); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_ins_records(pdate date, pdoctor integer, ppatient character, ptime time without time zone) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	SET SCHEMA 'clinic';
	INSERT INTO records (date, doctor, patient, time)
	VALUES (pdate, pdoctor, ppatient, ptime);
END;
$$;


ALTER FUNCTION clinic.fun_ins_records(pdate date, pdoctor integer, ppatient character, ptime time without time zone) OWNER TO postgres;

--
-- Name: fun_ins_templ(character varying); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_ins_templ(ptemp_name character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION clinic.fun_ins_templ(ptemp_name character varying) OWNER TO postgres;

--
-- Name: fun_ins_worker(character, character, character varying, character varying, character varying, integer, date, date, character varying); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_ins_worker(plogin character, ppassword character, plast_name character varying, pfirst_name character varying, pmiddle_name character varying, ppost integer, pdate_hiring date, pbirthday date, pphoto character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	SET SCHEMA 'clinic';
	IF pphoto = 'картинка по-умолчанию' THEN --//!!!!
		pphoto = null;
	END IF;
	
	INSERT INTO workers 
	VALUES (plogin, ppassword, plast_name, pfirst_name,pmiddle_name, 
			ppost, pdate_hiring, pbirthday, pphoto);
END;
$$;


ALTER FUNCTION clinic.fun_ins_worker(plogin character, ppassword character, plast_name character varying, pfirst_name character varying, pmiddle_name character varying, ppost integer, pdate_hiring date, pbirthday date, pphoto character varying) OWNER TO postgres;

--
-- Name: fun_scal_building(character varying, character); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_scal_building(pstreet character varying, pbuilding character) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE 
	id int;
BEGIN
	SET SCHEMA 'clinic';
	SELECT id_address INTO id FROM addresses 
	WHERE street = pstreet and building = pbuilding;
	RETURN id;
END;
$$;


ALTER FUNCTION clinic.fun_scal_building(pstreet character varying, pbuilding character) OWNER TO postgres;

--
-- Name: fun_scal_del_graph(date, integer); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_scal_del_graph(pdate date, pdoctor integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION clinic.fun_scal_del_graph(pdate date, pdoctor integer) OWNER TO postgres;

--
-- Name: fun_scal_get_nak(character); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_scal_get_nak(ppatient character) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE 
	nak int;
BEGIN 
	SET SCHEMA 'clinic';	
	nak = 0;	
	SELECT p.nak INTO nak FROM patients as p
	WHERE p.number_policy = ppatient;
	RETURN nak;
END;
$$;


ALTER FUNCTION clinic.fun_scal_get_nak(ppatient character) OWNER TO postgres;

--
-- Name: fun_scal_ins_addres(character varying, character); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_scal_ins_addres(pstreet character varying, pbuilding character) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION clinic.fun_scal_ins_addres(pstreet character varying, pbuilding character) OWNER TO postgres;

--
-- Name: fun_scal_is_doc(integer); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_scal_is_doc(ppost integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE 
	is_doc boolean;
BEGIN
	SET SCHEMA 'clinic';
	SELECT p.is_doc INTO is_doc
	FROM posts as p WHERE p.id_post = ppost;
	RETURN is_doc;
END;
$$;


ALTER FUNCTION clinic.fun_scal_is_doc(ppost integer) OWNER TO postgres;

--
-- Name: fun_scal_is_null_temp(character varying); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_scal_is_null_temp(ptemp_name character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION clinic.fun_scal_is_null_temp(ptemp_name character varying) OWNER TO postgres;

--
-- Name: fun_scal_number_ak(); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_scal_number_ak() RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION clinic.fun_scal_number_ak() OWNER TO postgres;

--
-- Name: fun_scal_who_is_this(character); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_scal_who_is_this(plogin character) RETURNS character
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION clinic.fun_scal_who_is_this(plogin character) OWNER TO postgres;

--
-- Name: fun_sel_building(character varying); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_sel_building(pstreet character varying) RETURNS TABLE(building character)
    LANGUAGE plpgsql
    AS $$
BEGIN
	SET SCHEMA 'clinic';
	RETURN QUERY
	SELECT a.building FROM addresses as a WHERE a.street = pstreet;
END;
$$;


ALTER FUNCTION clinic.fun_sel_building(pstreet character varying) OWNER TO postgres;

--
-- Name: fun_sel_district_record(character); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_sel_district_record(pnumber_policy character) RETURNS TABLE(fio_p text, phone character, address text, fio_d text)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION clinic.fun_sel_district_record(pnumber_policy character) OWNER TO postgres;

--
-- Name: fun_sel_doctor(character); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_sel_doctor(plogin character) RETURNS TABLE(last_name character varying, first_name character varying, middle_name character varying, birthday date, photo character varying, post_name character varying, office_name character varying, room integer, education character varying, experience integer, department_name text)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION clinic.fun_sel_doctor(plogin character) OWNER TO postgres;

--
-- Name: fun_sel_doctor_with_office(integer); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_sel_doctor_with_office(pid_doctor integer) RETURNS TABLE(fio text, office character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	SET SCHEMA 'clinic';
	RETURN QUERY
	SELECT concat(last_name, ' ', first_name, ' ', middle_name), o.name
	FROM worker as w, doctors as d, med_workers as m, offices as o
	WHERE d.id_doctor = pid_doctor and d.worker = w.login and 
		m.worker = w.login and m.office = o.id_office;
END;
$$;


ALTER FUNCTION clinic.fun_sel_doctor_with_office(pid_doctor integer) OWNER TO postgres;

--
-- Name: fun_sel_doctor_with_room_and_office(integer); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_sel_doctor_with_room_and_office(pdoctor integer) RETURNS TABLE(fio text, office_name character varying, room integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	SET SCHEMA 'clinic';
	RETURN QUERY	
	SELECT concat(w.last_name, ' ', w.first_name, ' ', w.middle_name), o.name, d.room
	FROM workers as w, med_workers as m, offices as o, doctors as d
	WHERE d.id_doctor = pdoctor and d.worker = w.login and w.login = m.worker and m.office = o.id_office;
END;
$$;


ALTER FUNCTION clinic.fun_sel_doctor_with_room_and_office(pdoctor integer) OWNER TO postgres;

--
-- Name: fun_sel_doctors_by_office(integer); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_sel_doctors_by_office(poffice integer) RETURNS TABLE(id_doctor integer, fio text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    SET SCHEMA 'clinic';
    RETURN QUERY
    SELECT d.id_doctor, concat(p.name, ' - ', w.last_name,' ', w.first_name,' ', w.middle_name)
    FROM doctors as d, workers as w, posts as p, med_workers as m
    WHERE d.worker = w.login and w.post = p.id_post and m.worker = w.login and m.office = poffice
    ORDER BY FIO;
END;
$$;


ALTER FUNCTION clinic.fun_sel_doctors_by_office(poffice integer) OWNER TO postgres;

--
-- Name: fun_sel_doctors_with_post(integer); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_sel_doctors_with_post(ppost integer) RETURNS TABLE(id_doctor integer, fio text, room integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	SET SCHEMA 'clinic';
	RETURN QUERY
	SELECT d.id_doctor, concat(w.last_name, ' ', w.first_name, ' ', w.middle_name), d.room 
	FROM workers as w, doctors as d
	WHERE d.worker = w.login and w.post  = ppost;  
END;
$$;


ALTER FUNCTION clinic.fun_sel_doctors_with_post(ppost integer) OWNER TO postgres;

--
-- Name: fun_sel_get_time(date, integer); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_sel_get_time(pdate date, pdoctor integer) RETURNS TABLE(free_time time without time zone)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION clinic.fun_sel_get_time(pdate date, pdoctor integer) OWNER TO postgres;

--
-- Name: fun_sel_graph(date, integer); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_sel_graph(pdate date, poffice integer) RETURNS TABLE(id_doctor integer, fio text, post character varying, begin_time time without time zone, end_time time without time zone, time_field integer, date_field date)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION clinic.fun_sel_graph(pdate date, poffice integer) OWNER TO postgres;

--
-- Name: fun_sel_graph_with_office_and_date(integer, date); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_sel_graph_with_office_and_date(poffice integer, pdate date) RETURNS TABLE(date date, fio text, begin_time time without time zone, end_time time without time zone, time_field integer)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION clinic.fun_sel_graph_with_office_and_date(poffice integer, pdate date) OWNER TO postgres;

--
-- Name: fun_sel_login_pacient(character); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_sel_login_pacient(pnumber_policy character) RETURNS TABLE(number_policy character, last_name character varying, first_name character varying, middle_name character varying)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION clinic.fun_sel_login_pacient(pnumber_policy character) OWNER TO postgres;

--
-- Name: fun_sel_login_worker(character, character); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_sel_login_worker(plogin character, ppassword character) RETURNS TABLE(id character, ythastk boolean, last_name character varying, first_name character varying, middle_name character varying, photo character varying, post character varying, office character varying, office_id integer)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION clinic.fun_sel_login_worker(plogin character, ppassword character) OWNER TO postgres;

--
-- Name: fun_sel_medworker(character); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_sel_medworker(plogin character) RETURNS TABLE(last_name character varying, first_name character varying, middle_name character varying, birthday date, photo character varying, post_name character varying, office_name character varying, department_name text)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION clinic.fun_sel_medworker(plogin character) OWNER TO postgres;

--
-- Name: fun_sel_patients_medcard(character); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_sel_patients_medcard(ppatient character) RETURNS TABLE(nak integer, ins_company character varying, number_policy character, snils character, lgot character, last_name character varying, first_name character varying, middle_name character varying, gender text, birthday date, addres text, phone character, work_place character varying, profession text)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION clinic.fun_sel_patients_medcard(ppatient character) OWNER TO postgres;

--
-- Name: fun_sel_patients_with_fio(character varying, boolean); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_sel_patients_with_fio(filter character varying, is_district boolean) RETURNS TABLE(number_policy character, fio text, nak integer)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION clinic.fun_sel_patients_with_fio(filter character varying, is_district boolean) OWNER TO postgres;

--
-- Name: fun_sel_patients_with_police(character varying, boolean); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_sel_patients_with_police(filter character varying, is_district boolean) RETURNS TABLE(number_policy character, fio text, nak integer)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION clinic.fun_sel_patients_with_police(filter character varying, is_district boolean) OWNER TO postgres;

--
-- Name: fun_sel_post_in_depart(character); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_sel_post_in_depart(pdepartment character) RETURNS TABLE(id_post integer, name character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	SET SCHEMA 'clinic';
	RETURN QUERY 
	SELECT p.id_post, p.name FROM posts as p 
	WHERE p.department = pdepartment;
END;
$$;


ALTER FUNCTION clinic.fun_sel_post_in_depart(pdepartment character) OWNER TO postgres;

--
-- Name: fun_sel_post_in_office(integer); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_sel_post_in_office(poffice integer) RETURNS TABLE(id_post integer, name character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
	SET SCHEMA 'clinic';
	RETURN QUERY 
	SELECT p.id_post, p.name 
	FROM posts as p, office_posts as o
	WHERE o.office = poffice and o.post = p.id_post;
END;
$$;


ALTER FUNCTION clinic.fun_sel_post_in_office(poffice integer) OWNER TO postgres;

--
-- Name: fun_sel_talon(date, integer, character); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_sel_talon(pdate date, pdoctor integer, ppatient character) RETURNS TABLE(coupon text, nak integer, record_time time without time zone, lgot character, number_policy character, snils character, fio_p text, gender text, birthday date, addres text, employment character varying, fio_d text)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION clinic.fun_sel_talon(pdate date, pdoctor integer, ppatient character) OWNER TO postgres;

--
-- Name: fun_sel_talons(character, date); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_sel_talons(ppatient character, today date) RETURNS TABLE(number_tal integer, date date, fio text, id_doc integer, post_name character varying, time_field time without time zone, room integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
	SET SCHEMA 'clinic';
	RETURN QUERY
	SELECT  r.coupon, r.date, concat(w.last_name, ' ', w.first_name, ' ', w.middle_name), 
		d.id_doctor , p.name, r.time, d.room
	FROM records as r, doctors as d, workers as w, posts as p
	WHERE r.patient = ppatient and r.date >= today and
		  r.doctor = d.id_doctor and d.worker = w.login and w.post = p.id_post;
END;
$$;


ALTER FUNCTION clinic.fun_sel_talons(ppatient character, today date) OWNER TO postgres;

--
-- Name: fun_sel_template(character varying); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_sel_template(ptemp_name character varying) RETURNS TABLE(template character varying, week_day integer, display_day text, begin_time time without time zone, end_time time without time zone, time_field integer)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION clinic.fun_sel_template(ptemp_name character varying) OWNER TO postgres;

--
-- Name: fun_sel_worker(character); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_sel_worker(plogin character) RETURNS TABLE(last_name character varying, first_name character varying, middle_name character varying, birthday date, photo character varying, post_name character varying, department_name text)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION clinic.fun_sel_worker(plogin character) OWNER TO postgres;

--
-- Name: fun_trig_check_ins_district_records(); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_trig_check_ins_district_records() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
	exist int;
BEGIN --//Настроить дату на сервере!!!
	SET SCHEMA 'clinic';
	SELECT count(*) INTO exist FROM district_records WHERE date >= current_date and patient = NEW.patient;
	IF exist <> 0 THEN
		RAISE EXCEPTION 'Данный пациент уже записан к участковому врачу!';
		RETURN NULL;
	ELSE
		RETURN NEW;
	END IF;
END;
$$;


ALTER FUNCTION clinic.fun_trig_check_ins_district_records() OWNER TO postgres;

--
-- Name: fun_trig_check_ins_patients(); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_trig_check_ins_patients() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION clinic.fun_trig_check_ins_patients() OWNER TO postgres;

--
-- Name: fun_trig_check_ins_records(); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_trig_check_ins_records() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION clinic.fun_trig_check_ins_records() OWNER TO postgres;

--
-- Name: fun_trig_check_ins_workers(); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_trig_check_ins_workers() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION clinic.fun_trig_check_ins_workers() OWNER TO postgres;

--
-- Name: fun_trig_del_worker(); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_trig_del_worker() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION clinic.fun_trig_del_worker() OWNER TO postgres;

--
-- Name: fun_upd_clear_temp(character varying, integer); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_upd_clear_temp(ptemplate character varying, pweek_day integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION clinic.fun_upd_clear_temp(ptemplate character varying, pweek_day integer) OWNER TO postgres;

--
-- Name: fun_upd_doctor(character, character varying, character varying, character varying, date, character varying, integer, character varying, integer); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_upd_doctor(plogin character, plast_name character varying, pfirst_name character varying, pmiddle_name character varying, pbirthday date, pphoto character varying, proom integer, peducation character varying, ppexperience integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION clinic.fun_upd_doctor(plogin character, plast_name character varying, pfirst_name character varying, pmiddle_name character varying, pbirthday date, pphoto character varying, proom integer, peducation character varying, ppexperience integer) OWNER TO postgres;

--
-- Name: fun_upd_ins_graph(date, integer, time without time zone, time without time zone, integer); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_upd_ins_graph(pdate date, pdoctor integer, pbegin time without time zone, pend time without time zone, ptime integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION clinic.fun_upd_ins_graph(pdate date, pdoctor integer, pbegin time without time zone, pend time without time zone, ptime integer) OWNER TO postgres;

--
-- Name: fun_upd_ins_graph_with_temp(character varying, integer, date, integer); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_upd_ins_graph_with_temp(ptemp_name character varying, pdoctor integer, pbegin_date date, pcount_day integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION clinic.fun_upd_ins_graph_with_temp(ptemp_name character varying, pdoctor integer, pbegin_date date, pcount_day integer) OWNER TO postgres;

--
-- Name: fun_upd_templ(character varying, integer, time without time zone, time without time zone, integer); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_upd_templ(ptemp_name character varying, pweek_day integer, pbegin_time time without time zone, pend_time time without time zone, ptime integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN   
	SET SCHEMA 'clinic';
	UPDATE templates
	SET begin_time = pbegin_time, end_time = pend_time, time = ptime
	WHERE temp_name = ptemp_name and week_day = pweek_day;
END;
$$;


ALTER FUNCTION clinic.fun_upd_templ(ptemp_name character varying, pweek_day integer, pbegin_time time without time zone, pend_time time without time zone, ptime integer) OWNER TO postgres;

--
-- Name: fun_upd_worker_medworker(character, character varying, character varying, character varying, date, character varying); Type: FUNCTION; Schema: clinic; Owner: postgres
--

CREATE FUNCTION clinic.fun_upd_worker_medworker(plogin character, plast_name character varying, pfirst_name character varying, pmiddle_name character varying, pbirthday date, pphoto character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
	SET SCHEMA 'clinic';
	UPDATE workers
	SET last_name = plast_name, first_name = pfirst_name, middle_name = pmiddle_name, 
		birthday = pbirthday, photo = pphoto
	WHERE login = plogin;
END;	
$$;


ALTER FUNCTION clinic.fun_upd_worker_medworker(plogin character, plast_name character varying, pfirst_name character varying, pmiddle_name character varying, pbirthday date, pphoto character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: addresses; Type: TABLE; Schema: clinic; Owner: postgres
--

CREATE TABLE clinic.addresses (
    id_address integer NOT NULL,
    street character varying(100) NOT NULL,
    building character(10) NOT NULL,
    district integer NOT NULL
);


ALTER TABLE clinic.addresses OWNER TO postgres;

--
-- Name: addresses_id_address_seq; Type: SEQUENCE; Schema: clinic; Owner: postgres
--

CREATE SEQUENCE clinic.addresses_id_address_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinic.addresses_id_address_seq OWNER TO postgres;

--
-- Name: addresses_id_address_seq; Type: SEQUENCE OWNED BY; Schema: clinic; Owner: postgres
--

ALTER SEQUENCE clinic.addresses_id_address_seq OWNED BY clinic.addresses.id_address;


--
-- Name: district_records; Type: TABLE; Schema: clinic; Owner: postgres
--

CREATE TABLE clinic.district_records (
    date date NOT NULL,
    patient character(19) NOT NULL
);


ALTER TABLE clinic.district_records OWNER TO postgres;

--
-- Name: districts; Type: TABLE; Schema: clinic; Owner: postgres
--

CREATE TABLE clinic.districts (
    district integer NOT NULL,
    doctor integer
);


ALTER TABLE clinic.districts OWNER TO postgres;

--
-- Name: doctors; Type: TABLE; Schema: clinic; Owner: postgres
--

CREATE TABLE clinic.doctors (
    id_doctor integer NOT NULL,
    worker character(40) NOT NULL,
    room integer NOT NULL,
    education character varying(100) NOT NULL,
    experience_bf integer NOT NULL
);


ALTER TABLE clinic.doctors OWNER TO postgres;

--
-- Name: doctors_id_doctor_seq; Type: SEQUENCE; Schema: clinic; Owner: postgres
--

CREATE SEQUENCE clinic.doctors_id_doctor_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinic.doctors_id_doctor_seq OWNER TO postgres;

--
-- Name: doctors_id_doctor_seq; Type: SEQUENCE OWNED BY; Schema: clinic; Owner: postgres
--

ALTER SEQUENCE clinic.doctors_id_doctor_seq OWNED BY clinic.doctors.id_doctor;


--
-- Name: employments; Type: TABLE; Schema: clinic; Owner: postgres
--

CREATE TABLE clinic.employments (
    id_employment integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE clinic.employments OWNER TO postgres;

--
-- Name: employments_id_employment_seq; Type: SEQUENCE; Schema: clinic; Owner: postgres
--

CREATE SEQUENCE clinic.employments_id_employment_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinic.employments_id_employment_seq OWNER TO postgres;

--
-- Name: employments_id_employment_seq; Type: SEQUENCE OWNED BY; Schema: clinic; Owner: postgres
--

ALTER SEQUENCE clinic.employments_id_employment_seq OWNED BY clinic.employments.id_employment;


--
-- Name: graphics; Type: TABLE; Schema: clinic; Owner: postgres
--

CREATE TABLE clinic.graphics (
    date date NOT NULL,
    doctor integer NOT NULL,
    begin_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    "time" integer NOT NULL
);


ALTER TABLE clinic.graphics OWNER TO postgres;

--
-- Name: lgots; Type: TABLE; Schema: clinic; Owner: postgres
--

CREATE TABLE clinic.lgots (
    id_lgot character(3) NOT NULL,
    name text
);


ALTER TABLE clinic.lgots OWNER TO postgres;

--
-- Name: med_workers; Type: TABLE; Schema: clinic; Owner: postgres
--

CREATE TABLE clinic.med_workers (
    worker character(40) NOT NULL,
    office integer NOT NULL
);


ALTER TABLE clinic.med_workers OWNER TO postgres;

--
-- Name: office_posts; Type: TABLE; Schema: clinic; Owner: postgres
--

CREATE TABLE clinic.office_posts (
    post integer NOT NULL,
    office integer NOT NULL
);


ALTER TABLE clinic.office_posts OWNER TO postgres;

--
-- Name: offices; Type: TABLE; Schema: clinic; Owner: postgres
--

CREATE TABLE clinic.offices (
    id_office integer NOT NULL,
    name character varying(45) NOT NULL
);


ALTER TABLE clinic.offices OWNER TO postgres;

--
-- Name: offices_id_office_seq; Type: SEQUENCE; Schema: clinic; Owner: postgres
--

CREATE SEQUENCE clinic.offices_id_office_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinic.offices_id_office_seq OWNER TO postgres;

--
-- Name: offices_id_office_seq; Type: SEQUENCE OWNED BY; Schema: clinic; Owner: postgres
--

ALTER SEQUENCE clinic.offices_id_office_seq OWNED BY clinic.offices.id_office;


--
-- Name: patients; Type: TABLE; Schema: clinic; Owner: postgres
--

CREATE TABLE clinic.patients (
    number_policy character(19) NOT NULL,
    last_name character varying(45) NOT NULL,
    first_name character varying(45) NOT NULL,
    middle_name character varying(45) NOT NULL,
    date_registration date NOT NULL,
    address integer NOT NULL,
    apartment integer NOT NULL,
    phone character(16) NOT NULL,
    birthday date NOT NULL,
    ins_company character varying(60) NOT NULL,
    lgot character(3),
    snils character(16),
    gender boolean,
    work_place character varying(200),
    employment integer NOT NULL,
    nak integer
);


ALTER TABLE clinic.patients OWNER TO postgres;

--
-- Name: posts; Type: TABLE; Schema: clinic; Owner: postgres
--

CREATE TABLE clinic.posts (
    id_post integer NOT NULL,
    name character varying(45) NOT NULL,
    department character(1) NOT NULL,
    is_doc boolean DEFAULT false NOT NULL,
    CONSTRAINT posts_department_check CHECK ((department = ANY (ARRAY['A'::bpchar, 'L'::bpchar, 'H'::bpchar])))
);


ALTER TABLE clinic.posts OWNER TO postgres;

--
-- Name: posts_id_post_seq; Type: SEQUENCE; Schema: clinic; Owner: postgres
--

CREATE SEQUENCE clinic.posts_id_post_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinic.posts_id_post_seq OWNER TO postgres;

--
-- Name: posts_id_post_seq; Type: SEQUENCE OWNED BY; Schema: clinic; Owner: postgres
--

ALTER SEQUENCE clinic.posts_id_post_seq OWNED BY clinic.posts.id_post;


--
-- Name: records; Type: TABLE; Schema: clinic; Owner: postgres
--

CREATE TABLE clinic.records (
    date date NOT NULL,
    doctor integer NOT NULL,
    patient character(19) NOT NULL,
    "time" time without time zone NOT NULL,
    coupon integer NOT NULL,
    ready boolean DEFAULT false NOT NULL
);


ALTER TABLE clinic.records OWNER TO postgres;

--
-- Name: sys_combobox_columns; Type: TABLE; Schema: clinic; Owner: postgres
--

CREATE TABLE clinic.sys_combobox_columns (
    id_name integer NOT NULL,
    numb integer NOT NULL,
    column_name character varying(100) NOT NULL
);


ALTER TABLE clinic.sys_combobox_columns OWNER TO postgres;

--
-- Name: sys_datagridview_columns; Type: TABLE; Schema: clinic; Owner: postgres
--

CREATE TABLE clinic.sys_datagridview_columns (
    id_name integer NOT NULL,
    numb integer NOT NULL,
    datapropertyname character varying(100) NOT NULL,
    headertext character varying(100) NOT NULL,
    visible boolean NOT NULL,
    width integer NOT NULL,
    readonly boolean NOT NULL,
    columntype integer NOT NULL
);


ALTER TABLE clinic.sys_datagridview_columns OWNER TO postgres;

--
-- Name: sys_fields_types; Type: TABLE; Schema: clinic; Owner: postgres
--

CREATE TABLE clinic.sys_fields_types (
    id_name integer NOT NULL,
    numb integer NOT NULL,
    type_field integer NOT NULL
);


ALTER TABLE clinic.sys_fields_types OWNER TO postgres;

--
-- Name: sys_input_upd_columns; Type: TABLE; Schema: clinic; Owner: postgres
--

CREATE TABLE clinic.sys_input_upd_columns (
    id_name integer NOT NULL,
    numb integer NOT NULL,
    column_name character varying(100) NOT NULL
);


ALTER TABLE clinic.sys_input_upd_columns OWNER TO postgres;

--
-- Name: sys_names; Type: TABLE; Schema: clinic; Owner: postgres
--

CREATE TABLE clinic.sys_names (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE clinic.sys_names OWNER TO postgres;

--
-- Name: templates; Type: TABLE; Schema: clinic; Owner: postgres
--

CREATE TABLE clinic.templates (
    temp_name character varying(45) NOT NULL,
    week_day integer NOT NULL,
    begin_time time without time zone,
    end_time time without time zone,
    "time" integer,
    CONSTRAINT templates_week_day_check CHECK ((week_day = ANY (ARRAY[1, 2, 3, 4, 5])))
);


ALTER TABLE clinic.templates OWNER TO postgres;

--
-- Name: workers; Type: TABLE; Schema: clinic; Owner: postgres
--

CREATE TABLE clinic.workers (
    login character(40) NOT NULL,
    password character(32) NOT NULL,
    last_name character varying(45) NOT NULL,
    first_name character varying(45) NOT NULL,
    middle_name character varying(45) NOT NULL,
    post integer NOT NULL,
    date_hiring date NOT NULL,
    birthday date NOT NULL,
    photo character varying(250) DEFAULT NULL::character varying
);


ALTER TABLE clinic.workers OWNER TO postgres;

--
-- Name: view_docktors; Type: VIEW; Schema: clinic; Owner: postgres
--

CREATE VIEW clinic.view_docktors AS
 SELECT doctors.id_doctor,
    concat(posts.name, ' - ', workers.last_name, ' ', workers.first_name, ' ', workers.middle_name) AS fio
   FROM clinic.doctors,
    clinic.workers,
    clinic.posts
  WHERE ((doctors.worker = workers.login) AND (workers.post = posts.id_post))
  ORDER BY (concat(posts.name, ' - ', workers.last_name, ' ', workers.first_name, ' ', workers.middle_name));


ALTER TABLE clinic.view_docktors OWNER TO postgres;

--
-- Name: view_lgots; Type: VIEW; Schema: clinic; Owner: postgres
--

CREATE VIEW clinic.view_lgots AS
 SELECT lgots.id_lgot,
    concat(lgots.id_lgot, ' | ', lgots.name) AS content
   FROM clinic.lgots;


ALTER TABLE clinic.view_lgots OWNER TO postgres;

--
-- Name: view_offices; Type: VIEW; Schema: clinic; Owner: postgres
--

CREATE VIEW clinic.view_offices AS
 SELECT offices.id_office,
    offices.name
   FROM clinic.offices;


ALTER TABLE clinic.view_offices OWNER TO postgres;

--
-- Name: view_patients; Type: VIEW; Schema: clinic; Owner: postgres
--

CREATE VIEW clinic.view_patients AS
 SELECT patients.number_policy,
    concat(patients.last_name, ' ', patients.first_name, ' ', patients.middle_name) AS fio,
    patients.nak
   FROM clinic.patients;


ALTER TABLE clinic.view_patients OWNER TO postgres;

--
-- Name: view_patients_district; Type: VIEW; Schema: clinic; Owner: postgres
--

CREATE VIEW clinic.view_patients_district AS
 SELECT patients.number_policy,
    concat(patients.last_name, ' ', patients.first_name, ' ', patients.middle_name) AS fio,
    patients.nak
   FROM clinic.patients,
    clinic.addresses
  WHERE ((patients.address = addresses.id_address) AND (addresses.district <> 0));


ALTER TABLE clinic.view_patients_district OWNER TO postgres;

--
-- Name: view_streets; Type: VIEW; Schema: clinic; Owner: postgres
--

CREATE VIEW clinic.view_streets AS
 SELECT addresses.street
   FROM clinic.addresses
  WHERE (addresses.district <> 0)
  GROUP BY addresses.street
  ORDER BY addresses.street;


ALTER TABLE clinic.view_streets OWNER TO postgres;

--
-- Name: view_templnames; Type: VIEW; Schema: clinic; Owner: postgres
--

CREATE VIEW clinic.view_templnames AS
 SELECT templates.temp_name
   FROM clinic.templates
  GROUP BY templates.temp_name;


ALTER TABLE clinic.view_templnames OWNER TO postgres;

--
-- Name: view_workers; Type: VIEW; Schema: clinic; Owner: postgres
--

CREATE VIEW clinic.view_workers AS
 SELECT workers.login,
    concat(posts.name, ' - ', workers.last_name, ' ', workers.first_name, ' ', workers.middle_name) AS info
   FROM clinic.workers,
    clinic.posts
  WHERE ((workers.post = posts.id_post) AND (workers.post <> 25))
  ORDER BY (concat(posts.name, ' - ', workers.last_name, ' ', workers.first_name, ' ', workers.middle_name));


ALTER TABLE clinic.view_workers OWNER TO postgres;

--
-- Name: addresses id_address; Type: DEFAULT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.addresses ALTER COLUMN id_address SET DEFAULT nextval('clinic.addresses_id_address_seq'::regclass);


--
-- Name: doctors id_doctor; Type: DEFAULT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.doctors ALTER COLUMN id_doctor SET DEFAULT nextval('clinic.doctors_id_doctor_seq'::regclass);


--
-- Name: employments id_employment; Type: DEFAULT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.employments ALTER COLUMN id_employment SET DEFAULT nextval('clinic.employments_id_employment_seq'::regclass);


--
-- Name: offices id_office; Type: DEFAULT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.offices ALTER COLUMN id_office SET DEFAULT nextval('clinic.offices_id_office_seq'::regclass);


--
-- Name: posts id_post; Type: DEFAULT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.posts ALTER COLUMN id_post SET DEFAULT nextval('clinic.posts_id_post_seq'::regclass);


--
-- Data for Name: addresses; Type: TABLE DATA; Schema: clinic; Owner: postgres
--

COPY clinic.addresses (id_address, street, building, district) FROM stdin;
1	Гладкова	21        	2
2	Гладкова	10        	2
3	Гладкова	6         	2
4	Гладкова	19        	2
5	Гладкова	17        	2
6	Гладкова	13        	2
7	Гладкова	15        	2
8	Гладкова	1 лит. А  	1
9	Гладкова	3         	1
10	Гладкова	7         	1
11	Гладкова	9         	2
12	Гладкова	11        	2
13	Гладкова	8         	2
14	Губина	4         	4
15	Губина	2         	4
16	Губина	6         	4
17	Губина	8         	4
18	Губина	10        	4
19	Губина	12        	4
20	Губина	14        	4
21	Губина	16        	4
22	Губина	18        	4
23	Губина	20        	4
24	Зои Космодемьянской	1         	5
25	Зои Космодемьянской	11        	5
26	Зои Космодемьянской	9         	5
27	Зои Космодемьянской	15        	5
28	Зои Космодемьянской	17        	5
29	Зои Космодемьянской	3         	5
30	Зои Космодемьянской	5         	5
31	Косинова	10        	1
32	Косинова	18        	1
33	Косинова	16        	1
34	Косинова	14 к.2    	1
35	Косинова	14 к.1    	1
36	Косинова	17        	2
37	Косинова	15        	2
38	Косинова	11        	2
39	Косинова	9         	2
40	Косинова	8         	1
41	Косинова	7         	2
42	Косинова	6         	1
43	Косинова	5         	2
44	Косинова	4         	1
45	Косинова	13        	2
46	Оборонная	14        	5
47	Оборонная	1         	1
48	Оборонная	3         	1
49	Оборонная	21        	4
50	Оборонная	4         	5
51	Оборонная	6         	5
52	Оборонная	8         	5
53	Оборонная	19        	4
54	Оборонная	9         	2
55	Оборонная	5         	1
56	Оборонная	7         	1
57	Помышленная	30        	4
58	Помышленная	28        	4
59	пр. Стачек	1         	1
60	пр. Стачек	17        	5
61	пр. Стачек	13        	1
62	пр. Стачек	3         	1
63	пр. Стачек	15        	1
64	пр. Стачек	9         	1
65	пр. Стачек	11        	1
66	Промышленная	8         	1
67	Промышленная	14        	2
68	Промышленная	18        	2
69	Промышленная	10        	1
70	Промышленная	16        	2
71	Промышленная	20 к.Б    	3
72	Промышленная	24        	3
73	Промышленная	22        	3
74	Промышленная	20        	3
75	Промышленная	12        	2
76	Севастопольская	7         	4
77	Севастопольская	9         	4
78	Севастопольская	5         	4
79	Севастопольская	13        	4
80	Севастопольская	19        	5
81	Севастопольская	3         	4
82	Севастопольская	1         	4
83	Севастопольская	6         	3
84	Севастопольская	15        	5
85	Турбинная	10 к.2    	2
86	Турбинная	24        	5
87	Турбинная	4         	2
88	Турбинная	6         	2
89	Турбинная	10 к.1    	2
90	Турбинная	12        	2
91	Турбинная	14        	2
92	Турбинная	14 лит.А  	2
93	Турбинная	16        	2
94	Турбинная	18        	2
95	Турбинная	7         	3
96	Турбинная	9         	3
97	Турбинная	11        	3
98	Турбинная	15        	3
99	Турбинная	8         	2
100	Гладкова	1         	1
101	Гладкова	18        	3
102	Гладкова	16        	2
103	Гладкова	14        	2
104	Гладкова	12        	2
105	Гладкова	33        	4
106	Гладкова	29        	3
107	Гладкова	25        	3
108	Гладкова	23        	3
\.


--
-- Data for Name: district_records; Type: TABLE DATA; Schema: clinic; Owner: postgres
--

COPY clinic.district_records (date, patient) FROM stdin;
\.


--
-- Data for Name: districts; Type: TABLE DATA; Schema: clinic; Owner: postgres
--

COPY clinic.districts (district, doctor) FROM stdin;
0	\N
1	1
2	2
3	3
4	4
5	5
\.


--
-- Data for Name: doctors; Type: TABLE DATA; Schema: clinic; Owner: postgres
--

COPY clinic.doctors (id_doctor, worker, room, education, experience_bf) FROM stdin;
1	gjalo@adelite.com                       	110	СПбГУ	3
2	jite@langoo.com                         	111	ГУАП	3
3	njelu_1986@narod.ru                     	112	МГУ	4
4	zyochyimji@netbox.com                   	113	АТУ	2
5	ziania@hotbox.com                       	114	УВАИГА	5
6	xjirae_1998@xaker.ru                    	115	МГУ	3
7	fiati@infobiz.com                       	116	ИТМО	7
8	vyuzyi@adelite.com                      	117	СИБГМУ	1
9	njuvio@mail.ru                          	118	ПМГМУ	2
10	chixiulou@infobiz.com                   	119	ПСПБГМУ	1
11	schium@yahoo.com                        	120	РНИМУ	3
12	tyqu@lycos.com                          	210	МГМСУ	4
13	schiukiavee@umr.ru                      	211	КГМУ	4
14	rjeheeg@inbox.ru                        	212	УГМА	5
15	syipyv@rambler.ru                       	213	САМГМУ	2
16	liokyuso@lycos.com                      	214	СПБПМУ	2
17	gyisjaga@list.ru                        	215	МГУ	4
18	schooqu@adelite.com                     	216	СИБГМУ	1
19	sjum@netman.ru                          	217	ИТМО	1
20	hepytash@list.ru                        	218	АТУ	2
21	dochjozji@sexnarod.ru                   	219	ПМГМУ	3
22	dyschyequ@newmail.ru                    	220	РНИМУ	2
23	tiuzhou@rin.ru                          	121	СПБПМУ	5
24	thiuxyifya@umr.ru                       	122	УВАИГА	3
25	piezischux@newmail.ru                   	310	МГМСУ	3
26	zyukishyu@nettaxi.com                   	311	ГУАП	3
27	thyagy@email.ru                         	312	МГМСУ	3
28	taegja@nihuja.net                       	313	МГМУ	4
29	sjuljed@newmail.ru                      	314	РНИМУ	5
30	nozjeth@mail.ru                         	315	СПбГУ	1
31	fiaz@xaker.ru                           	410	СПбГУ	2
32	hiud@orc.ru                             	411	ПСПБГМУ	3
33	lyishiafju@exn.ru                       	412	ПМГМУ	3
\.


--
-- Data for Name: employments; Type: TABLE DATA; Schema: clinic; Owner: postgres
--

COPY clinic.employments (id_employment, name) FROM stdin;
1	работает
2	пенсионер(ка)
3	студент(ка)
4	не работает
5	проходит военную службу
6	прочие
\.


--
-- Data for Name: graphics; Type: TABLE DATA; Schema: clinic; Owner: postgres
--

COPY clinic.graphics (date, doctor, begin_time, end_time, "time") FROM stdin;
\.


--
-- Data for Name: lgots; Type: TABLE DATA; Schema: clinic; Owner: postgres
--

COPY clinic.lgots (id_lgot, name) FROM stdin;
нет	
001	Инвалиды войны
002	Участники ВОВ
003	Ветераны боевых действий
004	Военнослужащие, проходившие военную службу в воинских частях, учреждениях, военно-учебных заведениях, не входивших в состав действующей армии в период с 22 июня 1941 года по 3 сентября 1945 года не менее 6 месяцев, военнослужащие, награжденные орденами
005	Лица, награжденные знаком «Жителю блокадного Ленинграда»
006	Лица, работавшие в период ВОВ на объектах ПВО, местной ПВО, на строительстве оборонительных сооружений, военно-морских баз, аэродромов и других военных объектов в пределах тыловых границ действующих фронтов, операционных зон действующих фронтов, операционных зон действующих фронтов 
007	Члены семей погибших (умерших) инвалидов войны, участников ВОВ и ветеранов боевых действий
008	Инвалиды (по общему заболеванию)
009	Дети-инвалиды
010	Лица, подвергшиеся воздействию радиации вследствие катастрофы на Чернобыльской АЭС, а также вследствие ядерных испытаний на Семипалатинском полигоне и приравненные к ним граждане
101	Нуждающиеся в лечении ЛС с диагнозом гемофилия
102	Нуждающиеся в лечении ЛС с диагнозом муковисцидоз 
103	Нуждающиеся в лечении ЛС с диагнозом гипофизарный нанизм
104	Нуждающиеся в лечении ЛС с диагнозом болезнь Гоше
105	Нуждающиеся в лечении ЛС с диагнозом миелолейкоз и другие гемобластозы
106	Нуждающиеся в лечении ЛС с диагнозом рассеянный склероз 
107	Нуждающиеся в лечении ЛС после трансплантации органов и тканей
201	Участники гражданской войны и ВОВ
206	Ветераны боевых действий на территориях других государств
207	Дети первых трех лет жизни
208	Инвалиды I группы, неработающие инвалиды II группы, дети-инвалиды в возрасте до 18 лет
209	Граждане, подвергшиеся воздействию радиации вследствие катастрофы на Чернобыльской катастрофы
210	Лица, из числа военнослужащих и вольнонаемного состава ВС СССР, войск и органов комитета госбезопасности СССР, внутренних, железнодорожных  войск и др. воин. фор.
211	Лица, получившие или перенесшие лучевую болезнь или ставшие инвалидами вследствие радиационных аварий их последствий на других (кроме Чернобыльской АЭС) атомных объектах
212	Малочисленные народы Севера, проживающие в сельской местности районов Крайнего Севера и приравненные к ним территориях 
213	Отдельные группы населения, страдающие гельминтозами
214	Детские церебральные параличи
215	Гепатоцеребральная дистрофия и фенилкетонурия
216	Муковисцидоз (больным детям)
217	Острая перемежающаяся порфирия
218	СПИД, ВИЧ – инфицированные
219	Онкологические заболевания
220	Гематологические заболевания, гемобластозы, цитопения
221	Лучевая болезнь
222	Лепра
223	Туберкулез
224	Тяжелая форма бруцеллеза
225	Системные хронические тяжелые заболевания кожи
226	Бронхиальная астма 
227	Ревматизм и ревматоидный артрит, системная (острая) красная волчанка
228	Инфаркт миокарда (первые шесть месяцев)
229	Состояние после операции по протезированию клапанов сердца
230	Пересадка органов и тканей
231	Диабет
232	Гипофизарный нанизм
233	Преждевременное половое развитие
234	Рассеянный склероз
235	Миастения
236	Миопатия
237	Мозжечковая атаксия Мари
238	Болезнь Паркинсона
239	Хронические урологические заболевания
240	Сифилис
241	Глаукома, катаракта
242	Психические заболевания (инвалидам I и II групп, а также больным, работающим в лечебно-производственных государственных предприятиях для проведения трудовой терапии, обучения новым профессиям и трудоустройства на этих предприятиях)
243	Аддисоновая болезнь
244	Шизофрения и эпилепсия
301	Инвалиды войны без ДЛО
302	Участники ВОВ без ДЛО
303	Ветераны боевых действий без ДЛО
304	Военнослужащие ВОВ без ДЛО
305	Блокадники без ДЛО
306	Работавшие в период ВОВ на военных объектах без ДЛО
307	Члены семей погибших (умерших) в ВОВ без ДЛО
308	Инвалиды (по общему заболеванию) без ДЛО
309	Дети-инвалиды без ДЛО
310	Лица, подвергшиеся воздействию радиации без ДЛО
400	Беременные
401	Кормящие матери
501	Пенсионеры, получающие пенсию по старости, инвалидности или по случаю потери кормильца в минимальных размерах
502	Работающие инвалиды II группы, инвалиды III группы, признанные в установленном порядке безработными
503	Граждане, принимавшие в 1988-1999 годах участие в работах по ликвидации последствий чернобыльской катастрофы в пределах зоны отчуждения  
504	Лица, подвергшиеся политическим репрессиям в виде лишения свободы, ссылки, высылки, направления на спецпоселение, привлечения к принудительному труду
505	Военнослужащие, в том числе уволенные в запас (отставку) проходившие военную службу в период с 22 июня 1941 года по 3 сентября 1945 года в воинских частях, учреждениях, военно-учебных заведениях, не входивших в состав действующей армии, и награжденные медалью «За победу над Германией в ВОВ 1941-1945гг.» или медалью «За победу над Японией»
506	Лица, работавшие в годы ВОВ на объектах противовоздушной обороны
507	Лица, проработавшие в тылу в период с 22 июня 1941 года по 9 мая 1945 года не менее 6 месяцев, исключая периоды работы на временно оккупированных территориях СССР
\.


--
-- Data for Name: med_workers; Type: TABLE DATA; Schema: clinic; Owner: postgres
--

COPY clinic.med_workers (worker, office) FROM stdin;
chixiulou@infobiz.com                   	1
fiati@infobiz.com                       	1
gjalo@adelite.com                       	1
jite@langoo.com                         	1
njelu_1986@narod.ru                     	1
njuvio@mail.ru                          	1
noxiec@yandex.ru                        	1
schium@yahoo.com                        	1
thiuxyifya@umr.ru                       	1
thjurje@rin.ru                          	1
tiuzhou@rin.ru                          	1
vyuzyi@adelite.com                      	1
xjirae_1998@xaker.ru                    	1
ziania@hotbox.com                       	1
zyochyimji@netbox.com                   	1
zyshokyd@nextmail.ru                    	1
dochjozji@sexnarod.ru                   	2
drugman2190@gmail.com                   	2
dyschyequ@newmail.ru                    	2
gyisjaga@list.ru                        	2
hepytash@list.ru                        	2
liokyuso@lycos.com                      	2
olgnest813@rambler.ru                   	2
rjeheeg@inbox.ru                        	2
schiukiavee@umr.ru                      	2
schooqu@adelite.com                     	2
sjum@netman.ru                          	2
syipyv@rambler.ru                       	2
tyqu@lycos.com                          	2
xyition@chat.ru                         	2
nasty212@gmail.com                      	3
nozjeth@mail.ru                         	3
piezischux@newmail.ru                   	3
sjuljed@newmail.ru                      	3
taegja@nihuja.net                       	3
thyagy@email.ru                         	3
zyukishyu@nettaxi.com                   	3
ferenw21@yandex.ru                      	4
fiaz@xaker.ru                           	4
hiud@orc.ru                             	4
lyishiafju@exn.ru                       	4
\.


--
-- Data for Name: office_posts; Type: TABLE DATA; Schema: clinic; Owner: postgres
--

COPY clinic.office_posts (post, office) FROM stdin;
1	1
2	1
3	1
4	1
5	1
6	1
7	1
8	2
9	2
10	2
11	2
12	2
13	2
14	2
15	1
16	3
17	3
18	3
19	3
20	3
21	4
22	4
23	1
23	2
23	3
23	4
24	1
24	2
24	3
24	4
29	1
29	2
29	3
29	4
\.


--
-- Data for Name: offices; Type: TABLE DATA; Schema: clinic; Owner: postgres
--

COPY clinic.offices (id_office, name) FROM stdin;
1	Терапевтическое
2	Хирургическое
3	Детское
4	Стоматологическое
\.


--
-- Data for Name: patients; Type: TABLE DATA; Schema: clinic; Owner: postgres
--

COPY clinic.patients (number_policy, last_name, first_name, middle_name, date_registration, address, apartment, phone, birthday, ins_company, lgot, snils, gender, work_place, employment, nak) FROM stdin;
2313 1233 5555 4234	Варенцов	Дмитрий	Генадьевич	2016-12-18	45	40	8-931-453-73-72 	1988-12-08	СОГАЗ-Мед	нет	\N	t	Завод автозапчастей	2	100
2850 7208 3500 0126	Игнатченко	Ольга	Михайловна	2016-12-18	1	30	8-956-783-21-34 	1971-11-30	СОГАЗ-Мед	\N	\N	\N	\N	2	101
3263 7288 4844 8843	Савельев	Николай	Юриевич	2016-12-18	79	88	8-925-267-26-26 	1997-01-21	РОСНО-МС	\N	\N	\N	\N	2	102
3443 6464 3646 4747	Старшин	Николай	Леонидович	2016-12-18	36	67	8-929-221-31-23 	1985-11-06	СОГАЗ-Мед	\N	\N	\N	\N	1	103
5548 5308 9700 0364	Румянцев	Андрей	Семенович	2016-12-18	60	15	8-932-633-77-44 	1967-06-24	РОСНО-МС	\N	\N	\N	\N	2	104
5637 3676 3326 7323	Иванов	Иван	Иванович	2016-12-18	107	5	8-973-256-23-56 	1960-09-14	МАКС-М	\N	\N	\N	\N	2	105
6326 2377 8328 7378	Тивафеев	Андрей	Викторович	2016-12-18	58	46	8-956-236-53-63 	1977-05-17	МАКС-М	\N	\N	\N	\N	2	106
6652 8008 4100 0384	Кудаев	Александр	Артемович	2016-12-18	25	67	8-923-775-32-52 	1992-12-15	РОСНО-МС	\N	\N	\N	\N	2	107
6773 4773 7732 7272	Антонов	Борис	Федоровис	2016-12-18	34	3	8-923-328-12-38 	1990-12-23	СОГАЗ-Мед	\N	\N	\N	\N	2	108
6787 4328 7487 8774	Некифоров	Николай	Андреевич	2016-12-18	32	16	8-973-267-32-31 	1982-07-18	Капитал-Полис	\N	\N	\N	\N	2	109
7348 7438 3487 7348	Кукушкин	Федор	Андреевич	2017-12-26	8	2	8-923-893-28-23 	1983-10-12	МАКС-М	\N	\N	\N	\N	2	110
7657 8302 2387 9431	Перцева	Екатерина	Сергеевна	2016-12-18	105	5	8-964-764-67-32 	1989-01-03	МАКС-М	\N	\N	\N	\N	2	111
7750 0208 2800 0724	Болгов	Алексей	Николаевич	2016-12-18	12	23	8-956-898-98-08 	1967-04-10	Капитал-Полис	\N	\N	\N	\N	2	112
7782 2525 5251 6612	Конохов	Артем	Валерьевич	2016-12-19	65	17	8-911-252-43-53 	1986-01-18	Медэкспресс	\N	\N	\N	\N	2	113
7832 7462 6010 3648	Пермяков	Матвей	Максимович	2016-12-20	21	34	8-945-739-62-12 	1975-11-07	РОСНО-МС	\N	\N	\N	\N	2	114
7832 7832 7837 8473	Кирилов	Андрей	Филипович	2016-12-20	107	14	8-952-356-31-21 	1985-12-21	СОГАЗ-Мед	\N	\N	\N	\N	2	115
7832 9845 3011 2092	Борисов	Сергей	Федорович	2016-12-20	34	23	8-993-737-27-76 	1988-12-31	РОСНО-МС	\N	\N	\N	\N	1	116
7852 1108 2300 3091	Кудаев	Роман	Алексеевич	2016-12-21	53	37	8-982-883-12-34 	1955-11-15	МАКС-М	\N	\N	\N	\N	4	117
\.


--
-- Data for Name: posts; Type: TABLE DATA; Schema: clinic; Owner: postgres
--

COPY clinic.posts (id_post, name, department, is_doc) FROM stdin;
1	Терапевт	L	t
2	Аллерголог	L	t
3	Эндокринолог	L	t
4	Иммунолог	L	t
5	Пульмонолог	L	t
6	Дерматолог	L	t
7	Кардиолог	L	t
8	Хирург	L	t
9	Ортопед	L	t
10	Отоларинголог	L	t
11	Уролог	L	t
12	Гинеколог	L	t
13	Онколог	L	t
14	Офтальмолог	L	t
15	Инфекционист	L	t
16	Педиатр	L	t
17	Детский ортопед	L	t
18	Детский невролог	L	t
19	Детский хирург	L	t
20	Детский стоматолог	L	t
21	Стоматолог	L	t
22	Стоматолог-протезист	L	t
23	Заведующий	L	f
24	Медсестра	L	f
25	Главный врач	A	f
26	Бухгалтер	A	f
27	Секретарь	A	f
28	Системный администратор	A	f
29	Санитар	L	f
30	Охранник	H	f
31	Регистратор	A	f
32	Электрик	H	f
33	Сантехник	H	f
34	Гардеробщица	H	f
\.


--
-- Data for Name: records; Type: TABLE DATA; Schema: clinic; Owner: postgres
--

COPY clinic.records (date, doctor, patient, "time", coupon, ready) FROM stdin;
\.


--
-- Data for Name: sys_combobox_columns; Type: TABLE DATA; Schema: clinic; Owner: postgres
--

COPY clinic.sys_combobox_columns (id_name, numb, column_name) FROM stdin;
11	1	id_post
11	2	name
12	1	id_post
12	2	name
26	1	free_time
26	2	free_time
31	1	id_doctor
31	2	FIO
39	1	street
39	2	street
40	1	id_lgot
40	2	content
41	1	id_office
41	2	name
42	1	temp_name
42	2	temp_name
45	1	id_employment
45	2	name
46	1	building
46	2	building
47	1	login
47	2	info
48	1	id_doctor
48	2	FIO
\.


--
-- Data for Name: sys_datagridview_columns; Type: TABLE DATA; Schema: clinic; Owner: postgres
--

COPY clinic.sys_datagridview_columns (id_name, numb, datapropertyname, headertext, visible, width, readonly, columntype) FROM stdin;
2	1	FIO	ФИО	t	200	t	1
2	2	post	Должность	t	130	t	1
2	3	begin_time	Начало	t	100	f	2
2	4	end_time	Конец	t	100	f	2
2	5	time_field	Прием(мин.)	t	100	f	2
4	1	display_day	День недели	t	120	t	1
4	2	begin_time	Начало работы	t	150	f	2
4	3	end_time	Конец работы	t	150	f	2
4	4	time_field	Время на прием	t	150	f	2
25	1	number_tal	№ талона	t	80	t	1
25	2	date	Дата	t	70	t	1
25	3	id_doc	id_doc	f	0	t	1
25	4	FIO	Врач	t	150	t	1
25	5	post_name	Специальность	t	120	t	1
25	6	time_field	Время	t	65	t	1
25	7	room	Кабинет	t	55	t	1
25	8		Получить талон	t	100	t	3
28	1	FIO	ФИО врача	t	250	t	1
28	2	begin_time	Начало приема	t	110	t	1
28	3	end_time	Конец приема	t	110	t	1
29	1	number_policy	Номер медицинского полиса	t	200	t	1
29	2	FIO	Пациент	t	300	t	1
29	3	nak	НАК	t	100	t	1
30	1	number_policy	Номер медицинского полиса	t	200	t	1
30	2	FIO	Пациент	t	300	t	1
30	3	nak	НАК	t	100	t	1
37	1	id_doctor	id	f	30	t	1
37	2	FIO	ФИО врача	t	200	t	1
37	3	room	Кабинет	t	120	t	1
37	4		Записаться	t	100	t	3
43	1	number_policy	Номер медицинского полиса	t	200	t	1
43	2	FIO	Пациент	t	300	t	1
43	3	nak	НАК	t	100	t	1
44	1	number_policy	Номер медицинского полиса	t	200	t	1
44	2	FIO	Пациент	t	300	t	1
44	3	nak	НАК	t	100	t	1
\.


--
-- Data for Name: sys_fields_types; Type: TABLE DATA; Schema: clinic; Owner: postgres
--

COPY clinic.sys_fields_types (id_name, numb, type_field) FROM stdin;
1	1	6
1	2	6
2	1	7
2	2	9
3	1	7
3	2	9
3	3	20
3	4	20
3	5	9
4	1	22
5	1	22
6	1	22
6	2	9
6	3	20
6	4	20
6	5	9
7	1	22
7	2	9
7	3	7
7	4	9
8	1	6
8	2	22
8	3	22
8	4	22
8	5	7
8	6	22
9	1	6
9	2	22
9	3	22
9	4	22
9	5	7
9	6	22
9	7	9
9	8	22
9	9	9
10	1	6
11	1	6
12	1	9
13	1	9
14	1	6
14	2	6
14	3	22
14	4	22
14	5	22
14	6	9
14	7	7
14	8	7
14	9	22
15	1	6
15	2	6
15	3	22
15	4	22
15	5	22
15	6	9
15	7	7
15	8	7
15	9	22
15	10	9
16	1	6
16	2	6
16	3	22
16	4	22
16	5	22
16	6	9
16	7	7
16	8	7
16	9	22
16	10	9
16	11	9
16	12	22
16	13	9
17	1	6
18	1	6
19	1	6
20	1	6
21	1	22
22	1	22
22	2	6
23	1	6
23	2	22
23	3	22
23	4	22
23	5	7
23	6	9
23	7	9
23	8	6
23	9	7
23	10	22
23	11	6
23	12	6
23	13	2
23	14	22
23	15	9
24	1	7
24	2	6
25	1	6
25	2	7
26	1	7
26	2	9
27	1	7
27	2	9
27	3	6
27	4	20
28	1	9
28	2	7
29	1	22
29	2	2
30	1	22
30	2	2
31	1	9
32	1	7
32	2	9
33	1	22
33	2	9
34	1	22
35	1	22
35	2	6
36	1	6
37	1	9
38	1	9
46	1	22
\.


--
-- Data for Name: sys_input_upd_columns; Type: TABLE DATA; Schema: clinic; Owner: postgres
--

COPY clinic.sys_input_upd_columns (id_name, numb, column_name) FROM stdin;
3	1	date_field
3	2	id_doctor
3	3	begin_time
3	4	end_time
3	5	time_field
6	1	template
6	2	week_day
6	3	begin_time
6	4	end_time
6	5	time_field
\.


--
-- Data for Name: sys_names; Type: TABLE DATA; Schema: clinic; Owner: postgres
--

COPY clinic.sys_names (id, name) FROM stdin;
1	fun_sel_login_worker
2	fun_sel_graph
3	fun_upd_ins_graph
4	fun_sel_template
5	fun_ins_templ
6	fun_upd_templ
7	fun_upd_ins_graph_with_temp
8	fun_upd_worker_medworker
9	fun_upd_doctor
10	fun_del_worker
11	fun_sel_post_in_depart
12	fun_sel_post_in_office
13	fun_scal_is_doc
14	fun_ins_worker
15	fun_ins_medworker
16	fun_ins_doctor
17	fun_scal_who_is_this
18	fun_sel_worker
19	fun_sel_medworker
20	fun_sel_doctor
21	fun_scal_is_null_temp
22	fun_scal_building
23	fun_ins_pacient
24	fun_ins_district_record
25	fun_sel_talons
26	fun_sel_get_time
27	fun_ins_records
28	fun_sel_graph_with_office_and_date
29	fun_sel_patients_with_police
30	fun_sel_patients_with_FIO
31	fun_sel_doctors_by_office
32	fun_scal_del_graph
33	fun_upd_clear_temp
34	fun_del_temp
35	fun_scal_ins_addres
36	fun_sel_login_pacient
37	fun_sel_doctors_with_post
38	fun_sel_doctor_with_room_and_office
39	view_streets
40	view_lgots
41	view_offices
42	view_templnames
43	view_patients_district
44	view_patients
45	employments
46	fun_sel_building
47	view_workers
48	view_docktors
\.


--
-- Data for Name: templates; Type: TABLE DATA; Schema: clinic; Owner: postgres
--

COPY clinic.templates (temp_name, week_day, begin_time, end_time, "time") FROM stdin;
Новый	1	\N	\N	\N
Новый	2	\N	\N	\N
Новый	3	\N	\N	\N
Новый	4	\N	\N	\N
Новый	5	\N	\N	\N
Терапевты	1	09:00:00	15:00:00	15
Терапевты	2	09:00:00	15:00:00	15
Терапевты	3	09:00:00	15:00:00	15
Терапевты	4	09:00:00	15:00:00	15
Терапевты	5	09:00:00	15:00:00	15
\.


--
-- Data for Name: workers; Type: TABLE DATA; Schema: clinic; Owner: postgres
--

COPY clinic.workers (login, password, last_name, first_name, middle_name, post, date_hiring, birthday, photo) FROM stdin;
chixiulou@infobiz.com                   	10b4768e098cec2d6c00479e3584012e	Болдырев	Борис	Вячеславович	6	2007-08-03	1993-06-09	\N
cjibou@chat.ru                          	d4fe5897b17fcd494773af99055fe388	Шаров	Евгений	Петрович	26	2008-12-06	1987-09-14	\N
dochjozji@sexnarod.ru                   	626a14af7268396cd19352b49eb713f8	Коренцов	Влад	Владиславович	13	2003-01-05	1977-10-11	\N
drugman2190@gmail.com                   	5703cee9b64e5b40e3d4007f92831f11	Никитина	Анжелика	Юрьевна	24	2006-06-11	1978-11-07	\N
dyschyequ@newmail.ru                    	8fc79953c1e9d342364af79257a4bd8f	Трушев	Иван	Андреевич	14	2006-03-16	1957-05-28	\N
ferenw21@yandex.ru                      	812a536ce6c72efcc33b9e0f2e062a45	Петрова	Екатерина	Андреевна	23	2017-10-11	1975-05-11	\N
fiati@infobiz.com                       	6358b42481281e65894e2c390df92f8f	Варенцов	Максим	Олегович	3	2005-07-16	1984-10-31	\N
fiaz@xaker.ru                           	252139766868ecbe3003c1a2c850ba44	Рузин	Роман	Вячеславович	21	2000-11-01	1988-08-07	\N
gjalo@adelite.com                       	96cb98dd0ac028acdea3366afe38ff30	Борисов	Александр	Юрьевич	1	2011-09-01	1966-04-26	\N
gyisjaga@list.ru                        	a0d610f028be872b4d9b1dedf9a40b26	Смолин	Николай	Юрьевич	10	2008-10-09	1970-03-14	\N
hepytash@list.ru                        	bfc76d75a7b7eb26a0c85fe96b7f306d	Хотникова	Василиса	Юрьевна	12	2014-10-07	1988-12-11	\N
hiaxjir@netaddress.com                  	9fa10a19ae805dd49be38b84ae456eb8	Ефремова	Светлана	Федоровна	31	2009-08-13	1993-12-01	\N
hiud@orc.ru                             	3c52bb986f4fcbac4371b4ec4b9b72fc	Ледвиг	Дмитрий	Денисович	21	2009-04-17	1961-03-01	\N
jite@langoo.com                         	8b1fdf16e7f6263facbbbe55b5c279fd	Гойхман	Микоелян	Генадевич	1	2005-08-04	1975-05-03	\N
jjoquye@nihuja.net                      	9d3e93fe3bfabda8762561a5f4ce2dfb	Извекова	Мария	Андреевна	25	2001-07-07	1993-08-15	\N
liokyuso@lycos.com                      	03dacfb0b893e63b1843e210d4282276	Рыжкова	Елена	Сергеевна	10	2003-08-08	1980-03-10	\N
lyishiafju@exn.ru                       	d92927b75eb359dd6e725580369138ff	Романенко	Александр	Николаевич	22	2017-05-03	1987-09-14	\N
muveegoo@narod.ru                       	c6bed0a90edabf72f31d4e0121f6d721	Чуняев	Александр	Викторович	32	2010-06-17	1985-09-23	\N
nasty212@gmail.com                      	b86c7b3d45035c6a2422b31fd45e099b	Измайлова	Анастасия	Викторовна	23	2007-12-09	1980-10-20	\N
njelu_1986@narod.ru                     	2a7b27a9f10b99fb58027f33b35abbd5	Карасева	Марина	Олеговна	1	2011-11-12	1970-11-11	image_2.png
njuvio@mail.ru                          	f7cf3ebb9f5a75f27935025fccd40669	Барсукова	Светлана	Михайловна	5	2003-11-21	1983-05-05	\N
noxiec@yandex.ru                        	6bdcc6d382f62c22aa316d8278e2ce4e	Ефимов	Сергей	Романович	23	2007-12-02	1990-11-20	\N
nozjeth@mail.ru                         	23cffa73e98839e6ca5b2c8ef5a9fede	Зуев	Владимир	Анатольевич	20	2010-09-20	1979-04-19	\N
olgnest813@rambler.ru                   	9d8f019fc26ecf76be628b0f37f2d798	Нестерова	Ольга	Николаевна	23	2009-03-12	1983-04-02	\N
piezischux@newmail.ru                   	e07ce02685a8897d69a4777069654c49	Степанов	Виктор	Анатольевич	16	2008-02-08	1997-05-01	\N
rjeheeg@inbox.ru                        	e89a795b8d4a1dae5da7c9ab56cd83dc	Осипова	Любовь	Михайловна	9	2009-01-31	1974-12-30	\N
rjuraequ@adelite.com                    	4d1e9096f886c0e9825b5789f9d11dfe	Маклева	Елена	Геннадьевна	30	2015-04-15	1998-08-11	\N
roojiozu@land.ru                        	fefc106bccb0ecff0bc5114689b0abf5	Адамчук	Владимир	Евгеньевич	34	2005-09-10	1989-06-01	\N
schiukiavee@umr.ru                      	34f2805807f25c16f90d2969ab96126e	Арзамасова	Вероника	Валентиновна	8	2000-01-27	1968-02-01	\N
schium@yahoo.com                        	86146427ef40cb449c08f6cbb37f53da	Сотникова	Анна	Евгеневна	7	2010-04-21	1995-04-05	\N
schooqu@adelite.com                     	83ac514b91eed98dedfd1f0986ac2e5d	Васильева	Анжелика	Михайловна	10	2001-02-02	1959-07-18	\N
siaxy@google.com                        	4773d87da0e67951b7060a9d714d3125	Попов	Алексей	Алесеевич	30	2016-07-20	1970-05-05	image_4.png
sjuljed@newmail.ru                      	82f6434dc01cba6807ed59d1c3fe7a39	Сапожников	Артем	Андреевич	19	2003-04-16	1981-07-13	\N
sjum@netman.ru                          	705bf13a931ba1cd743ffab3f4e9b775	Симонова	Анастасия	Викторовна	11	2010-10-05	1980-02-22	\N
syipyv@rambler.ru                       	3e8eae42528edea931214e93bd657cd8	Демеш	Кирилл	Антонович	9	2010-03-05	1976-10-09	\N
taegja@nihuja.net                       	9e9da41905aa82246ae7790ebdd8edeb	Криницин	Дмитрий	Сергеевич	18	2001-09-14	1960-05-14	\N
thiuxyifya@umr.ru                       	fdad00efb1a79172bb5a7c5c4b6af2d8	Леонова	Арина	Генадевна	15	2016-12-20	1982-02-01	\N
thjurje@rin.ru                          	adb34b90767a6b2a1ed421fafe82c7b0	Вострикова	Ирина	Трофимовна	29	2005-11-30	1970-06-09	\N
thyagy@email.ru                         	2e31592720dbc81fce9da243ba7ecbe1	Тарасов	Дмитрий	Георгиевич	17	2010-07-04	1988-02-11	\N
tiuzhou@rin.ru                          	d072cb8f28134139cfb4aabb4ad3650e	Рожков	Петр	Андреевич	15	2008-05-13	1988-02-29	\N
tyqu@lycos.com                          	70a2734394310d0154993f45c643fc95	Архипов	Борис	Федорович	8	2007-07-25	1998-05-07	image_5.png
vecisch@narod.ru                        	84a12e0be7920ab83439670f50c650c9	Немкина	Марина	Степановна	28	2001-10-23	1983-12-11	\N
vyuzyi@adelite.com                      	627994a1e634966fec5279dd104cc762	Кораблин	Михаил	Андреевич	4	2001-06-27	1990-09-07	\N
xjirae_1998@xaker.ru                    	1af2d02dca9f52f4c3ef087aee87891a	Ефимов	Вячеслав	Валентинович	2	2010-09-12	1980-10-25	image_0.png
xjuryo@rambler.ru                       	f6535790f2521bc9de482d4962746d7f	Битюцких	Игорь	Иванович	33	2016-08-12	1995-12-31	\N
xyition@chat.ru                         	de8189bdcce7cebdea8e01108ccf5532	Базилевич	Сергей	Михайлович	29	2006-10-31	1958-07-09	image_6.png
zhjisyi@land.ru                         	ea0a18cf233044330aaec0ab28c1d658	Грачева	Анна	Олеговна	27	2009-04-30	1982-08-30	\N
ziania@hotbox.com                       	01de700fc0f21c697a73a1f2bf3c4965	Горошина	Анна	Сергеевна	1	2000-10-30	1967-02-24	image_1.png
zyochyimji@netbox.com                   	8c2a8128e6464d53d3cf4648b69bb1b9	Конохов	Константин	Грегорьевич	1	2005-07-16	1951-12-18	image_3.png
zyshokyd@nextmail.ru                    	a08866f8866429c0095617138f539e0a	Стукалов	Сергей	Потапович	24	2004-05-10	1993-04-05	\N
zyukishyu@nettaxi.com                   	3cb39de27289028cfaa936fb16d33c89	Смольянинова	Анастасия	Николаевна	16	2009-09-06	1982-04-16	\N
\.


--
-- Name: addresses_id_address_seq; Type: SEQUENCE SET; Schema: clinic; Owner: postgres
--

SELECT pg_catalog.setval('clinic.addresses_id_address_seq', 109, false);


--
-- Name: doctors_id_doctor_seq; Type: SEQUENCE SET; Schema: clinic; Owner: postgres
--

SELECT pg_catalog.setval('clinic.doctors_id_doctor_seq', 34, false);


--
-- Name: employments_id_employment_seq; Type: SEQUENCE SET; Schema: clinic; Owner: postgres
--

SELECT pg_catalog.setval('clinic.employments_id_employment_seq', 6, true);


--
-- Name: offices_id_office_seq; Type: SEQUENCE SET; Schema: clinic; Owner: postgres
--

SELECT pg_catalog.setval('clinic.offices_id_office_seq', 5, false);


--
-- Name: posts_id_post_seq; Type: SEQUENCE SET; Schema: clinic; Owner: postgres
--

SELECT pg_catalog.setval('clinic.posts_id_post_seq', 35, false);


--
-- Name: addresses addresses_pkey; Type: CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id_address);


--
-- Name: district_records district_records_pkey; Type: CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.district_records
    ADD CONSTRAINT district_records_pkey PRIMARY KEY (date, patient);


--
-- Name: districts districts_pkey; Type: CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.districts
    ADD CONSTRAINT districts_pkey PRIMARY KEY (district);


--
-- Name: doctors doctors_pkey; Type: CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.doctors
    ADD CONSTRAINT doctors_pkey PRIMARY KEY (id_doctor);


--
-- Name: doctors doctors_worker_key; Type: CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.doctors
    ADD CONSTRAINT doctors_worker_key UNIQUE (worker);


--
-- Name: employments employments_pkey; Type: CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.employments
    ADD CONSTRAINT employments_pkey PRIMARY KEY (id_employment);


--
-- Name: graphics graphics_pkey; Type: CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.graphics
    ADD CONSTRAINT graphics_pkey PRIMARY KEY (date, doctor);


--
-- Name: lgots lgots_pkey; Type: CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.lgots
    ADD CONSTRAINT lgots_pkey PRIMARY KEY (id_lgot);


--
-- Name: med_workers med_workers_pkey; Type: CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.med_workers
    ADD CONSTRAINT med_workers_pkey PRIMARY KEY (worker);


--
-- Name: office_posts office_posts_pkey; Type: CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.office_posts
    ADD CONSTRAINT office_posts_pkey PRIMARY KEY (post, office);


--
-- Name: offices offices_pkey; Type: CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.offices
    ADD CONSTRAINT offices_pkey PRIMARY KEY (id_office);


--
-- Name: patients patients_pkey; Type: CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.patients
    ADD CONSTRAINT patients_pkey PRIMARY KEY (number_policy);


--
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id_post);


--
-- Name: records records_pkey; Type: CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.records
    ADD CONSTRAINT records_pkey PRIMARY KEY (date, doctor, patient);


--
-- Name: sys_combobox_columns sys_combobox_columns_pkey; Type: CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.sys_combobox_columns
    ADD CONSTRAINT sys_combobox_columns_pkey PRIMARY KEY (id_name, numb);


--
-- Name: sys_datagridview_columns sys_datagridview_columns_pkey; Type: CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.sys_datagridview_columns
    ADD CONSTRAINT sys_datagridview_columns_pkey PRIMARY KEY (id_name, numb);


--
-- Name: sys_fields_types sys_fields_types_pkey; Type: CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.sys_fields_types
    ADD CONSTRAINT sys_fields_types_pkey PRIMARY KEY (id_name, numb);


--
-- Name: sys_input_upd_columns sys_input_upd_columns_pkey; Type: CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.sys_input_upd_columns
    ADD CONSTRAINT sys_input_upd_columns_pkey PRIMARY KEY (id_name, numb);


--
-- Name: sys_names sys_names_name_key; Type: CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.sys_names
    ADD CONSTRAINT sys_names_name_key UNIQUE (name);


--
-- Name: sys_names sys_names_pkey; Type: CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.sys_names
    ADD CONSTRAINT sys_names_pkey PRIMARY KEY (id);


--
-- Name: templates templates_pkey; Type: CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.templates
    ADD CONSTRAINT templates_pkey PRIMARY KEY (temp_name, week_day);


--
-- Name: workers workers_pkey; Type: CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.workers
    ADD CONSTRAINT workers_pkey PRIMARY KEY (login);


--
-- Name: district_records trig_check_ins_district_records; Type: TRIGGER; Schema: clinic; Owner: postgres
--

CREATE TRIGGER trig_check_ins_district_records BEFORE INSERT ON clinic.district_records FOR EACH ROW EXECUTE PROCEDURE clinic.fun_trig_check_ins_district_records();


--
-- Name: patients trig_check_ins_patients; Type: TRIGGER; Schema: clinic; Owner: postgres
--

CREATE TRIGGER trig_check_ins_patients BEFORE INSERT ON clinic.patients FOR EACH ROW EXECUTE PROCEDURE clinic.fun_trig_check_ins_patients();


--
-- Name: records trig_check_ins_records; Type: TRIGGER; Schema: clinic; Owner: postgres
--

CREATE TRIGGER trig_check_ins_records BEFORE INSERT ON clinic.records FOR EACH ROW EXECUTE PROCEDURE clinic.fun_trig_check_ins_records();


--
-- Name: workers trig_check_ins_workers; Type: TRIGGER; Schema: clinic; Owner: postgres
--

CREATE TRIGGER trig_check_ins_workers BEFORE INSERT ON clinic.workers FOR EACH ROW EXECUTE PROCEDURE clinic.fun_trig_check_ins_workers();


--
-- Name: workers trig_del_worker; Type: TRIGGER; Schema: clinic; Owner: postgres
--

CREATE TRIGGER trig_del_worker BEFORE DELETE ON clinic.workers FOR EACH ROW EXECUTE PROCEDURE clinic.fun_trig_del_worker();


--
-- Name: addresses addresses_district_fkey; Type: FK CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.addresses
    ADD CONSTRAINT addresses_district_fkey FOREIGN KEY (district) REFERENCES clinic.districts(district);


--
-- Name: district_records district_records_patient_fkey; Type: FK CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.district_records
    ADD CONSTRAINT district_records_patient_fkey FOREIGN KEY (patient) REFERENCES clinic.patients(number_policy);


--
-- Name: districts districts_doctor_fkey; Type: FK CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.districts
    ADD CONSTRAINT districts_doctor_fkey FOREIGN KEY (doctor) REFERENCES clinic.doctors(id_doctor);


--
-- Name: doctors doctors_worker_fkey; Type: FK CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.doctors
    ADD CONSTRAINT doctors_worker_fkey FOREIGN KEY (worker) REFERENCES clinic.workers(login);


--
-- Name: graphics graphics_doctor_fkey; Type: FK CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.graphics
    ADD CONSTRAINT graphics_doctor_fkey FOREIGN KEY (doctor) REFERENCES clinic.doctors(id_doctor);


--
-- Name: med_workers med_workers_office_fkey; Type: FK CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.med_workers
    ADD CONSTRAINT med_workers_office_fkey FOREIGN KEY (office) REFERENCES clinic.offices(id_office);


--
-- Name: med_workers med_workers_worker_fkey; Type: FK CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.med_workers
    ADD CONSTRAINT med_workers_worker_fkey FOREIGN KEY (worker) REFERENCES clinic.workers(login);


--
-- Name: office_posts office_posts_office_fkey; Type: FK CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.office_posts
    ADD CONSTRAINT office_posts_office_fkey FOREIGN KEY (office) REFERENCES clinic.offices(id_office);


--
-- Name: office_posts office_posts_post_fkey; Type: FK CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.office_posts
    ADD CONSTRAINT office_posts_post_fkey FOREIGN KEY (post) REFERENCES clinic.posts(id_post);


--
-- Name: patients patients_address_fkey; Type: FK CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.patients
    ADD CONSTRAINT patients_address_fkey FOREIGN KEY (address) REFERENCES clinic.addresses(id_address);


--
-- Name: patients patients_employment_fkey; Type: FK CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.patients
    ADD CONSTRAINT patients_employment_fkey FOREIGN KEY (employment) REFERENCES clinic.employments(id_employment);


--
-- Name: records records_doctor_fkey; Type: FK CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.records
    ADD CONSTRAINT records_doctor_fkey FOREIGN KEY (doctor) REFERENCES clinic.doctors(id_doctor);


--
-- Name: records records_patient_fkey; Type: FK CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.records
    ADD CONSTRAINT records_patient_fkey FOREIGN KEY (patient) REFERENCES clinic.patients(number_policy);


--
-- Name: sys_combobox_columns sys_combobox_columns_id_name_fkey; Type: FK CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.sys_combobox_columns
    ADD CONSTRAINT sys_combobox_columns_id_name_fkey FOREIGN KEY (id_name) REFERENCES clinic.sys_names(id);


--
-- Name: sys_datagridview_columns sys_datagridview_columns_id_name_fkey; Type: FK CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.sys_datagridview_columns
    ADD CONSTRAINT sys_datagridview_columns_id_name_fkey FOREIGN KEY (id_name) REFERENCES clinic.sys_names(id);


--
-- Name: sys_fields_types sys_fields_types_id_name_fkey; Type: FK CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.sys_fields_types
    ADD CONSTRAINT sys_fields_types_id_name_fkey FOREIGN KEY (id_name) REFERENCES clinic.sys_names(id);


--
-- Name: sys_input_upd_columns sys_input_upd_columns_id_name_fkey; Type: FK CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.sys_input_upd_columns
    ADD CONSTRAINT sys_input_upd_columns_id_name_fkey FOREIGN KEY (id_name) REFERENCES clinic.sys_names(id);


--
-- Name: workers workers_post_fkey; Type: FK CONSTRAINT; Schema: clinic; Owner: postgres
--

ALTER TABLE ONLY clinic.workers
    ADD CONSTRAINT workers_post_fkey FOREIGN KEY (post) REFERENCES clinic.posts(id_post);


--
-- PostgreSQL database dump complete
--

