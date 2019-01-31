\c clinic_db
SET SCHEMA 'clinic';

INSERT INTO offices VALUES 
(1,'Терапевтическое'),(2,'Хирургическое'),(3,'Детское'),(4,'Стоматологическое');
SELECT setval(pg_get_serial_sequence('offices', 'id_office'), 5, false); --//Следующее значение авторинкремента - 5


INSERT INTO posts VALUES 
(1,'Терапевт','L',true),(2,'Аллерголог','L',true),(3,'Эндокринолог','L',true),(4,'Иммунолог','L',true),(5,'Пульмонолог','L',true),
(6,'Дерматолог','L',true),(7,'Кардиолог','L',true),(8,'Хирург','L',true),(9,'Ортопед','L',true),(10,'Отоларинголог','L',true),
(11,'Уролог','L',true),(12,'Гинеколог','L',true),(13,'Онколог','L',true),(14,'Офтальмолог','L',true),(15,'Инфекционист','L',true),
(16,'Педиатр','L',true),(17,'Детский ортопед','L',true),(18,'Детский невролог','L',true),(19,'Детский хирург','L',true),
(20,'Детский стоматолог','L',true),(21,'Стоматолог','L',true),(22,'Стоматолог-протезист','L',true),(23,'Заведующий','L',false),
(24,'Медсестра','L',false),(25,'Главный врач','A',false),(26,'Бухгалтер','A',false),(27,'Секретарь','A',false),
(28,'Системный администратор','A',false),(29,'Санитар','L',false),(30,'Охранник','H',false),(31,'Регистратор','A',false),
(32,'Электрик','H',false),(33,'Сантехник','H',false),(34,'Гардеробщица','H',false);
SELECT setval(pg_get_serial_sequence('posts', 'id_post'), 35, false); --//Следующее значение авторинкремента - 35


INSERT INTO office_posts VALUES 
(1,1),(2,1),(3,1),(4,1),(5,1),(6,1),(7,1),(8,2),(9,2),(10,2),(11,2),(12,2),(13,2),(14,2),(15,1),(16,3),(17,3),(18,3),
(19,3),(20,3),(21,4),(22,4),(23,1),(23,2),(23,3),(23,4),(24,1),(24,2),(24,3),(24,4),(29,1),(29,2),(29,3),(29,4);


INSERT INTO workers VALUES 
('chixiulou@infobiz.com','10b4768e098cec2d6c00479e3584012e','Болдырев','Борис','Вячеславович',6,'2007-08-03','1993-06-09',NULL),
('cjibou@chat.ru','d4fe5897b17fcd494773af99055fe388','Шаров','Евгений','Петрович',26,'2008-12-06','1987-09-14',NULL),
('dochjozji@sexnarod.ru','626a14af7268396cd19352b49eb713f8','Коренцов','Влад','Владиславович',13,'2003-01-05','1977-10-11',NULL),
('drugman2190@gmail.com','5703cee9b64e5b40e3d4007f92831f11','Никитина','Анжелика','Юрьевна',24,'2006-06-11','1978-11-07',NULL),
('dyschyequ@newmail.ru','8fc79953c1e9d342364af79257a4bd8f','Трушев','Иван','Андреевич',14,'2006-03-16','1957-05-28',NULL),
('ferenw21@yandex.ru','812a536ce6c72efcc33b9e0f2e062a45','Петрова','Екатерина','Андреевна',23,'2017-10-11','1975-05-11',NULL),
('fiati@infobiz.com','6358b42481281e65894e2c390df92f8f','Варенцов','Максим','Олегович',3,'2005-07-16','1984-10-31',NULL),
('fiaz@xaker.ru','252139766868ecbe3003c1a2c850ba44','Рузин','Роман','Вячеславович',21,'2000-11-01','1988-08-07',NULL),
('gjalo@adelite.com','96cb98dd0ac028acdea3366afe38ff30','Борисов','Александр','Юрьевич',1,'2011-09-01','1966-04-26',NULL),
('gyisjaga@list.ru','a0d610f028be872b4d9b1dedf9a40b26','Смолин','Николай','Юрьевич',10,'2008-10-09','1970-03-14',NULL),
('hepytash@list.ru','bfc76d75a7b7eb26a0c85fe96b7f306d','Хотникова','Василиса','Юрьевна',12,'2014-10-07','1988-12-11',NULL),
('hiaxjir@netaddress.com','9fa10a19ae805dd49be38b84ae456eb8','Ефремова','Светлана','Федоровна',31,'2009-08-13','1993-12-01',NULL),
('hiud@orc.ru','3c52bb986f4fcbac4371b4ec4b9b72fc','Ледвиг','Дмитрий','Денисович',21,'2009-04-17','1961-03-01',NULL),
('jite@langoo.com','8b1fdf16e7f6263facbbbe55b5c279fd','Гойхман','Микоелян','Генадевич',1,'2005-08-04','1975-05-03',NULL),
('jjoquye@nihuja.net','9d3e93fe3bfabda8762561a5f4ce2dfb','Извекова','Мария','Андреевна',25,'2001-07-07','1993-08-15',NULL),
('liokyuso@lycos.com','03dacfb0b893e63b1843e210d4282276','Рыжкова','Елена','Сергеевна',10,'2003-08-08','1980-03-10',NULL),
('lyishiafju@exn.ru','d92927b75eb359dd6e725580369138ff','Романенко','Александр','Николаевич',22,'2017-05-03','1987-09-14',NULL),
('muveegoo@narod.ru','c6bed0a90edabf72f31d4e0121f6d721','Чуняев','Александр','Викторович',32,'2010-06-17','1985-09-23',NULL),
('nasty212@gmail.com','b86c7b3d45035c6a2422b31fd45e099b','Измайлова','Анастасия','Викторовна',23,'2007-12-09','1980-10-20',NULL),
('njelu_1986@narod.ru','2a7b27a9f10b99fb58027f33b35abbd5','Карасева','Марина','Олеговна',1,'2011-11-12','1970-11-11','image_2.png'),
('njuvio@mail.ru','f7cf3ebb9f5a75f27935025fccd40669','Барсукова','Светлана','Михайловна',5,'2003-11-21','1983-05-05',NULL),
('noxiec@yandex.ru','6bdcc6d382f62c22aa316d8278e2ce4e','Ефимов','Сергей','Романович',23,'2007-12-02','1990-11-20',NULL),
('nozjeth@mail.ru','23cffa73e98839e6ca5b2c8ef5a9fede','Зуев','Владимир','Анатольевич',20,'2010-09-20','1979-04-19',NULL),
('olgnest813@rambler.ru','9d8f019fc26ecf76be628b0f37f2d798','Нестерова','Ольга','Николаевна',23,'2009-03-12','1983-04-02',NULL),
('piezischux@newmail.ru','e07ce02685a8897d69a4777069654c49','Степанов','Виктор','Анатольевич',16,'2008-02-08','1997-05-01',NULL),
('rjeheeg@inbox.ru','e89a795b8d4a1dae5da7c9ab56cd83dc','Осипова','Любовь','Михайловна',9,'2009-01-31','1974-12-30',NULL),
('rjuraequ@adelite.com','4d1e9096f886c0e9825b5789f9d11dfe','Маклева','Елена','Геннадьевна',30,'2015-04-15','1998-08-11',NULL),
('roojiozu@land.ru','fefc106bccb0ecff0bc5114689b0abf5','Адамчук','Владимир','Евгеньевич',34,'2005-09-10','1989-06-01',NULL),
('schiukiavee@umr.ru','34f2805807f25c16f90d2969ab96126e','Арзамасова','Вероника','Валентиновна',8,'2000-01-27','1968-02-01',NULL),
('schium@yahoo.com','86146427ef40cb449c08f6cbb37f53da','Сотникова','Анна','Евгеневна',7,'2010-04-21','1995-04-05',NULL),
('schooqu@adelite.com','83ac514b91eed98dedfd1f0986ac2e5d','Васильева','Анжелика','Михайловна',10,'2001-02-02','1959-07-18',NULL),
('siaxy@google.com','4773d87da0e67951b7060a9d714d3125','Попов','Алексей','Алесеевич',30,'2016-07-20','1970-05-05','image_4.png'),
('sjuljed@newmail.ru','82f6434dc01cba6807ed59d1c3fe7a39','Сапожников','Артем','Андреевич',19,'2003-04-16','1981-07-13',NULL),
('sjum@netman.ru','705bf13a931ba1cd743ffab3f4e9b775','Симонова','Анастасия','Викторовна',11,'2010-10-05','1980-02-22',NULL),
('syipyv@rambler.ru','3e8eae42528edea931214e93bd657cd8','Демеш','Кирилл','Антонович',9,'2010-03-05','1976-10-09',NULL),
('taegja@nihuja.net','9e9da41905aa82246ae7790ebdd8edeb','Криницин','Дмитрий','Сергеевич',18,'2001-09-14','1960-05-14',NULL),
('thiuxyifya@umr.ru','fdad00efb1a79172bb5a7c5c4b6af2d8','Леонова','Арина','Генадевна',15,'2016-12-20','1982-02-01',NULL),
('thjurje@rin.ru','adb34b90767a6b2a1ed421fafe82c7b0','Вострикова','Ирина','Трофимовна',29,'2005-11-30','1970-06-09',NULL),
('thyagy@email.ru','2e31592720dbc81fce9da243ba7ecbe1','Тарасов','Дмитрий','Георгиевич',17,'2010-07-04','1988-02-11',NULL),
('tiuzhou@rin.ru','d072cb8f28134139cfb4aabb4ad3650e','Рожков','Петр','Андреевич',15,'2008-05-13','1988-02-29',NULL),
('tyqu@lycos.com','70a2734394310d0154993f45c643fc95','Архипов','Борис','Федорович',8,'2007-07-25','1998-05-07','image_5.png'),
('vecisch@narod.ru','84a12e0be7920ab83439670f50c650c9','Немкина','Марина','Степановна',28,'2001-10-23','1983-12-11',NULL),
('vyuzyi@adelite.com','627994a1e634966fec5279dd104cc762','Кораблин','Михаил','Андреевич',4,'2001-06-27','1990-09-07',NULL),
('xjirae_1998@xaker.ru','1af2d02dca9f52f4c3ef087aee87891a','Ефимов','Вячеслав','Валентинович',2,'2010-09-12','1980-10-25','image_0.png'),
('xjuryo@rambler.ru','f6535790f2521bc9de482d4962746d7f','Битюцких','Игорь','Иванович',33,'2016-08-12','1995-12-31',NULL),
('xyition@chat.ru','de8189bdcce7cebdea8e01108ccf5532','Базилевич','Сергей','Михайлович',29,'2006-10-31','1958-07-09','image_6.png'),
('zhjisyi@land.ru','ea0a18cf233044330aaec0ab28c1d658','Грачева','Анна','Олеговна',27,'2009-04-30','1982-08-30',NULL),
('ziania@hotbox.com','01de700fc0f21c697a73a1f2bf3c4965','Горошина','Анна','Сергеевна',1,'2000-10-30','1967-02-24','image_1.png'),
('zyochyimji@netbox.com','8c2a8128e6464d53d3cf4648b69bb1b9','Конохов','Константин','Грегорьевич',1,'2005-07-16','1951-12-18','image_3.png'),
('zyshokyd@nextmail.ru','a08866f8866429c0095617138f539e0a','Стукалов','Сергей','Потапович',24,'2004-05-10','1993-04-05',NULL),
('zyukishyu@nettaxi.com','3cb39de27289028cfaa936fb16d33c89','Смольянинова','Анастасия','Николаевна',16,'2009-09-06','1982-04-16',NULL);


INSERT INTO med_workers VALUES 
('chixiulou@infobiz.com',1),('fiati@infobiz.com',1),('gjalo@adelite.com',1),('jite@langoo.com',1),('njelu_1986@narod.ru',1),
('njuvio@mail.ru',1),('noxiec@yandex.ru',1),('schium@yahoo.com',1),('thiuxyifya@umr.ru',1),('thjurje@rin.ru',1),
('tiuzhou@rin.ru',1),('vyuzyi@adelite.com',1),('xjirae_1998@xaker.ru',1),('ziania@hotbox.com',1),('zyochyimji@netbox.com',1),
('zyshokyd@nextmail.ru',1),('dochjozji@sexnarod.ru',2),('drugman2190@gmail.com',2),('dyschyequ@newmail.ru',2),('gyisjaga@list.ru',2),
('hepytash@list.ru',2),('liokyuso@lycos.com',2),('olgnest813@rambler.ru',2),('rjeheeg@inbox.ru',2),('schiukiavee@umr.ru',2),
('schooqu@adelite.com',2),('sjum@netman.ru',2),('syipyv@rambler.ru',2),('tyqu@lycos.com',2),('xyition@chat.ru',2),
('nasty212@gmail.com',3),('nozjeth@mail.ru',3),('piezischux@newmail.ru',3),('sjuljed@newmail.ru',3),('taegja@nihuja.net',3),
('thyagy@email.ru',3),('zyukishyu@nettaxi.com',3),('ferenw21@yandex.ru',4),('fiaz@xaker.ru',4),('hiud@orc.ru',4),('lyishiafju@exn.ru',4);


INSERT INTO doctors VALUES 
(1,'gjalo@adelite.com',110,'СПбГУ',3),(2,'jite@langoo.com',111,'ГУАП',3),(3,'njelu_1986@narod.ru',112,'МГУ',4),
(4,'zyochyimji@netbox.com',113,'АТУ',2),(5,'ziania@hotbox.com',114,'УВАИГА',5),(6,'xjirae_1998@xaker.ru',115,'МГУ',3),
(7,'fiati@infobiz.com',116,'ИТМО',7),(8,'vyuzyi@adelite.com',117,'СИБГМУ',1),(9,'njuvio@mail.ru',118,'ПМГМУ',2),
(10,'chixiulou@infobiz.com',119,'ПСПБГМУ',1),(11,'schium@yahoo.com',120,'РНИМУ',3),(12,'tyqu@lycos.com',210,'МГМСУ',4),
(13,'schiukiavee@umr.ru',211,'КГМУ',4),(14,'rjeheeg@inbox.ru',212,'УГМА',5),(15,'syipyv@rambler.ru',213,'САМГМУ',2),
(16,'liokyuso@lycos.com',214,'СПБПМУ',2),(17,'gyisjaga@list.ru',215,'МГУ',4),(18,'schooqu@adelite.com',216,'СИБГМУ',1),
(19,'sjum@netman.ru',217,'ИТМО',1),(20,'hepytash@list.ru',218,'АТУ',2),(21,'dochjozji@sexnarod.ru',219,'ПМГМУ',3),
(22,'dyschyequ@newmail.ru',220,'РНИМУ',2),(23,'tiuzhou@rin.ru',121,'СПБПМУ',5),(24,'thiuxyifya@umr.ru',122,'УВАИГА',3),
(25,'piezischux@newmail.ru',310,'МГМСУ',3),(26,'zyukishyu@nettaxi.com',311,'ГУАП',3),(27,'thyagy@email.ru',312,'МГМСУ',3),
(28,'taegja@nihuja.net',313,'МГМУ',4),(29,'sjuljed@newmail.ru',314,'РНИМУ',5),(30,'nozjeth@mail.ru',315,'СПбГУ',1),
(31,'fiaz@xaker.ru',410,'СПбГУ',2),(32,'hiud@orc.ru',411,'ПСПБГМУ',3),(33,'lyishiafju@exn.ru',412,'ПМГМУ',3);
SELECT setval(pg_get_serial_sequence('doctors', 'id_doctor'), 34, false); --//Следующее значение авторинкремента - 34


INSERT INTO districts VALUES (0, NULL),(1,1),(2,2),(3,3),(4,4),(5,5);

INSERT INTO employments(name) VALUES
('работает'),('пенсионер(ка)'),('студент(ка)'),('не работает'), ('проходит военную службу'), ('прочие');
/*
INSERT INTO lgots VALUES
('нет', 'Без льгот'),
('010', 'Инвалиды войны'),
('011', 'Участники Великой Отечественной войны, ставшие инвалидами'),
('012', 'Военнослужащие и лица рядового и начальствующего состава органов внутренних дел'),
('020', 'Участники Великой Отечественной войны'),
('030', 'Ветераны боевых действий'),
('040', 'Военнослужащие, проходившие военную службу в воинских частях, учреждениях, военно-учебных заведениях, не входивших в состав действующей армии, в период с 22 июня 1941 года по 3 сентября 1945'),
('050', 'Лица, награжденные знаком «Жителю блокадного Ленинграда»'),
('060', 'Члены семей погибших (умерших) инвалидов войны, участников Великой Отечественной войны и ветеранов боевых действий'),
('081', 'Инвалиды (I степень)'),
('082', 'Инвалиды (II степень)'),
('083', 'Инвалиды (III степень)'),
('084', 'Дети-инвалиды'),
('091', 'Граждане, получившие или перенесшие лучевую болезнь и другие заболевания, связанные с радиационным воздействием вследствие чернобыльской катастрофы или с работами по ликвидации последствий катастрофы на Чернобыльской АЭС');
*/

/*
INSERT INTO lgots VALUES
('нет'),('010'),('011'),('012'),('020'),('030'),
('040'),('050'),('060'),('081'),('082'),('083'),('084'),('091');
*/

INSERT INTO addresses VALUES 
(1,'Гладкова','21',2),(2,'Гладкова','10',2),(3,'Гладкова','6',2),(4,'Гладкова','19',2),(5,'Гладкова','17',2),
(6,'Гладкова','13',2),(7,'Гладкова','15',2),(8,'Гладкова','1 лит. А',1),(9,'Гладкова','3',1),(10,'Гладкова','7',1),
(11,'Гладкова','9',2),(12,'Гладкова','11',2),(13,'Гладкова','8',2),(14,'Губина','4',4),(15,'Губина','2',4),
(16,'Губина','6',4),(17,'Губина','8',4),(18,'Губина','10',4),(19,'Губина','12',4),(20,'Губина','14',4),
(21,'Губина','16',4),(22,'Губина','18',4),(23,'Губина','20',4),(24,'Зои Космодемьянской','1',5),
(25,'Зои Космодемьянской','11',5),(26,'Зои Космодемьянской','9',5),(27,'Зои Космодемьянской','15',5),
(28,'Зои Космодемьянской','17',5),(29,'Зои Космодемьянской','3',5),(30,'Зои Космодемьянской','5',5),(31,'Косинова','10',1),
(32,'Косинова','18',1),(33,'Косинова','16',1),(34,'Косинова','14 к.2',1),(35,'Косинова','14 к.1',1),(36,'Косинова','17',2),
(37,'Косинова','15',2),(38,'Косинова','11',2),(39,'Косинова','9',2),(40,'Косинова','8',1),(41,'Косинова','7',2),
(42,'Косинова','6',1),(43,'Косинова','5',2),(44,'Косинова','4',1),(45,'Косинова','13',2),(46,'Оборонная','14',5),
(47,'Оборонная','1',1),(48,'Оборонная','3',1),(49,'Оборонная','21',4),(50,'Оборонная','4',5),(51,'Оборонная','6',5),
(52,'Оборонная','8',5),(53,'Оборонная','19',4),(54,'Оборонная','9',2),(55,'Оборонная','5',1),(56,'Оборонная','7',1),
(57,'Помышленная','30',4),(58,'Помышленная','28',4),(59,'пр. Стачек','1',1),(60,'пр. Стачек','17',5),(61,'пр. Стачек','13',1),
(62,'пр. Стачек','3',1),(63,'пр. Стачек','15',1),(64,'пр. Стачек','9',1),(65,'пр. Стачек','11',1),(66,'Промышленная','8',1),
(67,'Промышленная','14',2),(68,'Промышленная','18',2),(69,'Промышленная','10',1),(70,'Промышленная','16',2),
(71,'Промышленная','20 к.Б',3),(72,'Промышленная','24',3),(73,'Промышленная','22',3),(74,'Промышленная','20',3),
(75,'Промышленная','12',2),(76,'Севастопольская','7',4),(77,'Севастопольская','9',4),(78,'Севастопольская','5',4),
(79,'Севастопольская','13',4),(80,'Севастопольская','19',5),(81,'Севастопольская','3',4),(82,'Севастопольская','1',4),
(83,'Севастопольская','6',3),(84,'Севастопольская','15',5),(85,'Турбинная','10 к.2',2),(86,'Турбинная','24',5),
(87,'Турбинная','4',2),(88,'Турбинная','6',2),(89,'Турбинная','10 к.1',2),(90,'Турбинная','12',2),(91,'Турбинная','14',2),
(92,'Турбинная','14 лит.А',2),(93,'Турбинная','16',2),(94,'Турбинная','18',2),(95,'Турбинная','7',3),(96,'Турбинная','9',3),
(97,'Турбинная','11',3),(98,'Турбинная','15',3),(99,'Турбинная','8',2),(100,'Гладкова','1',1),(101,'Гладкова','18',3),
(102,'Гладкова','16',2),(103,'Гладкова','14',2),(104,'Гладкова','12',2),(105,'Гладкова','33',4),(106,'Гладкова','29',3),
(107,'Гладкова','25',3),(108,'Гладкова','23',3);
SELECT setval(pg_get_serial_sequence('addresses', 'id_address'), 109, false); --//Следующее значение авторинкремента - 109


INSERT INTO patients VALUES 
('2313 1233 5555 4234','Варенцов','Дмитрий','Генадьевич','2016-12-18',45,40,'8-931-453-73-72','1988-12-08','СОГАЗ-Мед',
'нет', NULL, true, 'Завод автозапчастей',2, 100),
('2850 7208 3500 0126','Игнатченко','Ольга','Михайловна','2016-12-18',1,30,'8-956-783-21-34','1971-11-30','СОГАЗ-Мед',
NULL,NULL,NULL,NULL,2,101),
('3263 7288 4844 8843','Савельев','Николай','Юриевич','2016-12-18',79,88,'8-925-267-26-26','1997-01-21','РОСНО-МС',
NULL,NULL,NULL,NULL,2,102),
('3443 6464 3646 4747','Старшин','Николай','Леонидович','2016-12-18',36,67,'8-929-221-31-23','1985-11-06','СОГАЗ-Мед',
NULL,NULL,NULL,NULL,1,103),
('5548 5308 9700 0364','Румянцев','Андрей','Семенович','2016-12-18',60,15,'8-932-633-77-44','1967-06-24','РОСНО-МС',
NULL,NULL,NULL,NULL,2,104),
('5637 3676 3326 7323','Иванов','Иван','Иванович','2016-12-18',107,5,'8-973-256-23-56','1960-09-14','МАКС-М',
NULL,NULL,NULL,NULL,2,105),
('6326 2377 8328 7378','Тивафеев','Андрей','Викторович','2016-12-18',58,46,'8-956-236-53-63','1977-05-17','МАКС-М',
NULL,NULL,NULL,NULL,2,106),
('6652 8008 4100 0384','Кудаев','Александр','Артемович','2016-12-18',25,67,'8-923-775-32-52','1992-12-15','РОСНО-МС',
NULL,NULL,NULL,NULL,2,107),
('6773 4773 7732 7272','Антонов','Борис','Федоровис','2016-12-18',34,3,'8-923-328-12-38','1990-12-23','СОГАЗ-Мед',
NULL,NULL,NULL,NULL,2,108),
('6787 4328 7487 8774','Некифоров','Николай','Андреевич','2016-12-18',32,16,'8-973-267-32-31','1982-07-18','Капитал-Полис',
NULL,NULL,NULL,NULL,2,109),
('7348 7438 3487 7348','Кукушкин','Федор','Андреевич','2017-12-26',8,2,'8-923-893-28-23','1983-10-12','МАКС-М',
NULL,NULL,NULL,NULL,2,110),
('7657 8302 2387 9431','Перцева','Екатерина','Сергеевна','2016-12-18',105,5,'8-964-764-67-32','1989-01-03','МАКС-М',
NULL,NULL,NULL,NULL,2,111),
('7750 0208 2800 0724','Болгов','Алексей','Николаевич','2016-12-18',12,23,'8-956-898-98-08','1967-04-10','Капитал-Полис',
NULL,NULL,NULL,NULL,2,112),
('7782 2525 5251 6612','Конохов','Артем','Валерьевич','2016-12-19',65,17,'8-911-252-43-53','1986-01-18','Медэкспресс',
NULL,NULL,NULL,NULL,2,113),
('7832 7462 6010 3648','Пермяков','Матвей','Максимович','2016-12-20',21,34,'8-945-739-62-12','1975-11-07','РОСНО-МС',
NULL,NULL,NULL,NULL,2,114),
('7832 7832 7837 8473','Кирилов','Андрей','Филипович','2016-12-20',107,14,'8-952-356-31-21','1985-12-21','СОГАЗ-Мед',
NULL,NULL,NULL,NULL,2,115),
('7832 9845 3011 2092','Борисов','Сергей','Федорович','2016-12-20',34,23,'8-993-737-27-76','1988-12-31','РОСНО-МС',
NULL,NULL,NULL,NULL,1,116),
('7852 1108 2300 3091','Кудаев','Роман','Алексеевич','2016-12-21',53,37,'8-982-883-12-34','1955-11-15','МАКС-М',
NULL,NULL,NULL,NULL,4,117);

INSERT INTO templates(temp_name, week_day) VALUES 
('Новый', 1), ('Новый', 2), ('Новый', 3), ('Новый', 4), ('Новый', 5);
INSERT INTO templates VALUES 
('Терапевты', 1, '09:00:00', '15:00:00', 15), ('Терапевты', 2, '09:00:00', '15:00:00', 15), 
('Терапевты', 3, '09:00:00', '15:00:00', 15), ('Терапевты', 4, '09:00:00', '15:00:00', 15),
('Терапевты', 5, '09:00:00', '15:00:00', 15);

INSERT INTO lgots VALUES
('нет',	''),
('001',	'Инвалиды войны'),
('002',	'Участники ВОВ'),
('003',	'Ветераны боевых действий'),
('004',	'Военнослужащие, проходившие военную службу в воинских частях, учреждениях, военно-учебных заведениях, не входивших в состав действующей армии в период с 22 июня 1941 года по 3 сентября 1945 года не менее 6 месяцев, военнослужащие, награжденные орденами'),
('005',	'Лица, награжденные знаком «Жителю блокадного Ленинграда»'),
('006',	'Лица, работавшие в период ВОВ на объектах ПВО, местной ПВО, на строительстве оборонительных сооружений, военно-морских баз, аэродромов и других военных объектов в пределах тыловых границ действующих фронтов, операционных зон действующих фронтов, операционных зон действующих фронтов '),
('007',	'Члены семей погибших (умерших) инвалидов войны, участников ВОВ и ветеранов боевых действий'),
('008',	'Инвалиды (по общему заболеванию)'),
('009',	'Дети-инвалиды'),
('010',	'Лица, подвергшиеся воздействию радиации вследствие катастрофы на Чернобыльской АЭС, а также вследствие ядерных испытаний на Семипалатинском полигоне и приравненные к ним граждане'),
('101',	'Нуждающиеся в лечении ЛС с диагнозом гемофилия'),
('102',	'Нуждающиеся в лечении ЛС с диагнозом муковисцидоз '),
('103',	'Нуждающиеся в лечении ЛС с диагнозом гипофизарный нанизм'),
('104',	'Нуждающиеся в лечении ЛС с диагнозом болезнь Гоше'),
('105',	'Нуждающиеся в лечении ЛС с диагнозом миелолейкоз и другие гемобластозы'),
('106',	'Нуждающиеся в лечении ЛС с диагнозом рассеянный склероз '),
('107',	'Нуждающиеся в лечении ЛС после трансплантации органов и тканей'),
('201',	'Участники гражданской войны и ВОВ'),
('206',	'Ветераны боевых действий на территориях других государств'),
('207',	'Дети первых трех лет жизни'),
('208',	'Инвалиды I группы, неработающие инвалиды II группы, дети-инвалиды в возрасте до 18 лет'),
('209',	'Граждане, подвергшиеся воздействию радиации вследствие катастрофы на Чернобыльской катастрофы'),
('210',	'Лица, из числа военнослужащих и вольнонаемного состава ВС СССР, войск и органов комитета госбезопасности СССР, внутренних, железнодорожных  войск и др. воин. фор.'),
('211',	'Лица, получившие или перенесшие лучевую болезнь или ставшие инвалидами вследствие радиационных аварий их последствий на других (кроме Чернобыльской АЭС) атомных объектах'),
('212',	'Малочисленные народы Севера, проживающие в сельской местности районов Крайнего Севера и приравненные к ним территориях '),
('213',	'Отдельные группы населения, страдающие гельминтозами'),
('214',	'Детские церебральные параличи'),
('215',	'Гепатоцеребральная дистрофия и фенилкетонурия'),
('216',	'Муковисцидоз (больным детям)'),
('217',	'Острая перемежающаяся порфирия'),
('218',	'СПИД, ВИЧ – инфицированные'),
('219',	'Онкологические заболевания'),
('220',	'Гематологические заболевания, гемобластозы, цитопения'),
('221',	'Лучевая болезнь'),
('222',	'Лепра'),
('223',	'Туберкулез'),
('224',	'Тяжелая форма бруцеллеза'),
('225',	'Системные хронические тяжелые заболевания кожи'),
('226',	'Бронхиальная астма '),
('227',	'Ревматизм и ревматоидный артрит, системная (острая) красная волчанка'),
('228',	'Инфаркт миокарда (первые шесть месяцев)'),
('229',	'Состояние после операции по протезированию клапанов сердца'),
('230',	'Пересадка органов и тканей'),
('231',	'Диабет'),
('232',	'Гипофизарный нанизм'),
('233',	'Преждевременное половое развитие'),
('234',	'Рассеянный склероз'),
('235',	'Миастения'),
('236',	'Миопатия'),
('237',	'Мозжечковая атаксия Мари'),
('238',	'Болезнь Паркинсона'),
('239',	'Хронические урологические заболевания'),
('240',	'Сифилис'),
('241',	'Глаукома, катаракта'),
('242',	'Психические заболевания (инвалидам I и II групп, а также больным, работающим в лечебно-производственных государственных предприятиях для проведения трудовой терапии, обучения новым профессиям и трудоустройства на этих предприятиях)'),
('243',	'Аддисоновая болезнь'),
('244',	'Шизофрения и эпилепсия'),
('301',	'Инвалиды войны без ДЛО'),
('302',	'Участники ВОВ без ДЛО'),
('303',	'Ветераны боевых действий без ДЛО'),
('304',	'Военнослужащие ВОВ без ДЛО'),
('305',	'Блокадники без ДЛО'),
('306',	'Работавшие в период ВОВ на военных объектах без ДЛО'),
('307',	'Члены семей погибших (умерших) в ВОВ без ДЛО'),
('308',	'Инвалиды (по общему заболеванию) без ДЛО'),
('309',	'Дети-инвалиды без ДЛО'),
('310',	'Лица, подвергшиеся воздействию радиации без ДЛО'),
('400',	'Беременные'),
('401',	'Кормящие матери'),
('501',	'Пенсионеры, получающие пенсию по старости, инвалидности или по случаю потери кормильца в минимальных размерах'),
('502',	'Работающие инвалиды II группы, инвалиды III группы, признанные в установленном порядке безработными'),
('503',	'Граждане, принимавшие в 1988-1999 годах участие в работах по ликвидации последствий чернобыльской катастрофы в пределах зоны отчуждения  '),
('504',	'Лица, подвергшиеся политическим репрессиям в виде лишения свободы, ссылки, высылки, направления на спецпоселение, привлечения к принудительному труду'),
('505',	'Военнослужащие, в том числе уволенные в запас (отставку) проходившие военную службу в период с 22 июня 1941 года по 3 сентября 1945 года в воинских частях, учреждениях, военно-учебных заведениях, не входивших в состав действующей армии, и награжденные медалью «За победу над Германией в ВОВ 1941-1945гг.» или медалью «За победу над Японией»'),
('506',	'Лица, работавшие в годы ВОВ на объектах противовоздушной обороны'),
('507',	'Лица, проработавшие в тылу в период с 22 июня 1941 года по 9 мая 1945 года не менее 6 месяцев, исключая периоды работы на временно оккупированных территориях СССР');
--// \c postgres
