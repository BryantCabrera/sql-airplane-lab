DROP TABLE IF EXISTS airlines;
DROP TABLE IF EXISTS airports;
DROP TABLE IF EXISTS routes;

CREATE TABLE airlines (
  id int,
  name varchar(255) DEFAULT NULL,
  alias varchar(255) DEFAULT NULL,
  iata varchar(255) DEFAULT NULL,
  icao varchar(255) DEFAULT NULL,
  callsign varchar(255) DEFAULT NULL,
  country varchar(255) DEFAULT NULL,
  active varchar(255) DEFAULT NULL
);

CREATE TABLE airports (
  id int,
  name varchar(255) DEFAULT NULL,
  city varchar(255) DEFAULT NULL,
  country varchar(255) DEFAULT NULL,
  iata_faa varchar(255) DEFAULT NULL,
  icao varchar(255) DEFAULT NULL,
  latitude varchar(255) DEFAULT NULL,
  longitude varchar(255) DEFAULT NULL,
  altitude varchar(255) DEFAULT NULL,
  utc_offset varchar(255) DEFAULT NULL,
  dst varchar(255) DEFAULT NULL,
  tz varchar(255) DEFAULT NULL
);

CREATE TABLE routes (
  airline_code varchar(255) DEFAULT NULL,
  airline_id int DEFAULT NULL,
  origin_code varchar(255) DEFAULT NULL,
  origin_id int DEFAULT NULL,
  dest_code varchar(255) DEFAULT NULL,
  dest_id int DEFAULT NULL,
  codeshare varchar(255) DEFAULT NULL,
  stops int DEFAULT NULL,
  equipment varchar(255) DEFAULT NULL
);

COPY routes FROM '/Users/bryantcabrera/code/wdi/w10/d3/sql-airplane-lab/routes.csv' DELIMITER ',' CSV;
COPY airports FROM '/Users/bryantcabrera/code/wdi/w10/d3/sql-airplane-lab/airports.csv' DELIMITER ',' CSV;
COPY airlines FROM '/Users/bryantcabrera/code/wdi/w10/d3/sql-airplane-lab/airlines.csv' DELIMITER ',' CSV;

--all flights in New York
SELECT id FROM airports AS origin WHERE origin.city = 'New York'
UNION
--all flights in Paris
SELECT id FROM airports AS destination WHERE destination.city = 'Paris';

--Find out how many flights go from NYC to Paris with alias
SELECT * FROM routes
  WHERE origin_id IN (SELECT id FROM airports AS origin WHERE origin.city = 'New York')
  AND dest_id IN (SELECT id FROM airports AS destination WHERE destination.city = 'Paris');

--Find out how many flights go from NYC to Paris without alias
SELECT * FROM routes
  WHERE origin_id IN (SELECT id FROM airports WHERE city = 'New York')
  AND dest_id IN (SELECT id FROM airports WHERE city = 'Paris');

--Do this so that just the number appears as the result of only one SQL statement
SELECT COUNT(airline_code) AS total_flights_nyparis FROM routes 
  WHERE origin_id IN (SELECT id FROM airports AS origin WHERE origin.city = 'New York')
  AND dest_id IN (SELECT id FROM airports AS destination WHERE destination.city = 'Paris');

--Which airlines travel from NYC to Paris?
SELECT DISTINCT ON (airline_code) * FROM routes 
  WHERE origin_id IN (SELECT id FROM airports AS origin WHERE origin.city = 'New York')
  AND dest_id IN (SELECT id FROM airports AS destination WHERE destination.city = 'Paris');

SELECT name FROM airlines
  Where id IN (SELECT airline_id FROM routes 
    WHERE origin_id IN (SELECT id FROM airports AS origin WHERE origin.city = 'New York')
    AND dest_id IN (SELECT id FROM airports AS destination WHERE destination.city = 'Paris'));

--Find all the flights that leave NYC. Give me a list of how many go to each destination city.
SELECT * FROM routes
  WHERE origin_id IN (SELECT id FROM airports WHERE city = 'New York');

SELECT DISTINCT dest_id, COUNT(dest_id) FROM routes
  WHERE origin_id IN (SELECT id FROM airports WHERE city = 'New York')
  GROUP BY dest_id;