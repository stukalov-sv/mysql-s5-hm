DROP DATABASE IF EXISTS lesson_5_hm;
CREATE DATABASE lesson_5_hm;
USE lesson_5_hm;

CREATE TABLE cars_cost
(
	id INT NOT NULL,
    `name` VARCHAR(45),
    cost INT,
	PRIMARY KEY(id)
);

/*                    
- файл test_db.csv скопирован в папку по указанному ниже адресу, 
- добавлена строчка в 'OPT_LOCAL_INFILE=1' во вкладку Server -> Management Access Settings -> Connection -> Advanced -> Other       
*/

LOAD DATA INFILE "C://ProgramData//MySQL//MySQL Server 8.0//Uploads//test_db.csv" INTO TABLE cars_cost 
FIELDS TERMINATED BY ','                              
LINES TERMINATED BY '\n'                              
IGNORE 1 ROWS;                                        

SELECT * FROM cars_cost;

/* 1.
Создайте представление, в которое попадут автомобили стоимостью до 25 000 долларов
*/

CREATE VIEW cars_to_cost AS
SELECT * 
FROM cars_cost
WHERE cost < 25000;

SELECT * 
FROM cars_to_cost;

/* 2.
Изменить в существующем представлении порог для стоимости: пусть цена будет до 
30 000 долларов (используя оператор ALTER VIEW)
*/

ALTER VIEW cars_to_cost AS
SELECT * 
FROM cars_cost
WHERE cost < 30000;

SELECT * 
FROM cars_to_cost;

/* 3.
Создайте представление, в котором будут только автомобили марки “Шкода” и “Ауди”
*/

CREATE VIEW skoda_audi AS
SELECT * 
FROM cars_cost
WHERE `name` IN ('Skoda ', 'Audi ');

SELECT * 
FROM skoda_audi;

CREATE TABLE stations
(
train_id INT NOT NULL,
station varchar(20) NOT NULL,
station_time TIME NOT NULL
);

INSERT stations(train_id, station, station_time)
VALUES (110, "SanFrancisco", "10:00:00"),
(110, "Redwood Sity", "10:54:00"),
(110, "Palo Alto", "11:02:00"),
(110, "San Jose", "12:35:00"),
(120, "SanFrancisco", "11:00:00"),
(120, "Palo Alto", "12:49:00"),
(120, "San Jose", "13:30:00");

/* 4.
Добавьте новый столбец под названием «время до следующей станции». Чтобы получить это значение, мы вычитаем время станций для пар
смежных станций. Мы можем вычислить это значение без использования оконной функции SQL, но это может быть очень сложно. Проще это 
сделать с помощью оконной функции LEAD . Эта функция сравнивает значения из одной строки со следующей строкой, чтобы получить
результат. В этом случае функция сравнивает значения в столбце «время» для станции со станцией сразу после нее 
*/

CREATE VIEW time_to_next_point AS
SELECT train_id, station, station_time, TIMEDIFF(t, station_time) AS time_to_next_point
FROM (
	SELECT *, LEAD(station_time) OVER(PARTITION BY train_id) AS t
    FROM stations
	) AS time_to;

SELECT *
FROM time_to_next_point;