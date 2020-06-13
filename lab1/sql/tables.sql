DROP TABLE IF EXISTS authors;
CREATE TABLE authors
(
    id      INT AUTO_INCREMENT PRIMARY KEY,
    name    VARCHAR(50) NOT NULL,
    surname VARCHAR(50) NOT NULL,
	age INT NOT NULL
);
DROP TABLE IF EXISTS licences;
CREATE TABLE licences 
(
	id      INT AUTO_INCREMENT PRIMARY KEY,
    license_type    VARCHAR(50) NOT NULL,
    description VARCHAR(500) NOT NULL
);


DROP TABLE IF EXISTS software;
CREATE TABLE software 
(
	id      INT AUTO_INCREMENT PRIMARY KEY,
    name    VARCHAR(50) NOT NULL,
    author_id INT REFERENCES author(id),
	description VARCHAR(500) NOT NULL,
	licence_id INT REFERENCES licences(id),
	app_type VARCHAR(50) NOT NULL
);

DROP TABLE IF EXISTS versions;
CREATE TABLE versions 
(
	id           INT AUTO_INCREMENT PRIMARY KEY,
    software_id  INT REFERENCES software(id),
    version      VARCHAR(10) NOT NULL,
	release_info VARCHAR(500) NOT NULL,
	release_date DATETIME DEFAULT now() NOT NULL
);

DROP TABLE IF EXISTS users;
CREATE TABLE users
(
    id      INT AUTO_INCREMENT PRIMARY KEY,
    name    VARCHAR(50) NOT NULL,
    surname VARCHAR(50) NOT NULL,
	age INT NOT NULL
);

DROP TABLE IF EXISTS statistics;
CREATE TABLE statistics 
(
	id           INT AUTO_INCREMENT PRIMARY KEY,
    version_id  INT REFERENCES versions(id),
    downloads_count INT NOT NULL,
	mark FLOAT NOT NULL,
	active_users INT NOT NULL
);

DROP TABLE IF EXISTS userversions;
CREATE TABLE userversions
(
    id      INT AUTO_INCREMENT PRIMARY KEY,
    version_id INT REFERENCES versions(id),
    user_id INT REFERENCES users(id)
);

INSERT INTO authors (name, surname,age)
VALUES ('Vitaliy', 'Tardiev',19);
INSERT INTO authors (name, surname,age)
VALUES ('Oleksandr', 'Raboteev',41);
INSERT INTO authors (name, surname,age)
VALUES ('Oleksiy', 'Andruschenko',33);

INSERT INTO users (name, surname,age)
VALUES ('Ole', 'Tale',19);
INSERT INTO users (name, surname,age)
VALUES ('Marina', 'Taranova',65);
INSERT INTO users (name, surname,age)
VALUES ('Sarah', 'Abramovna',25);


INSERT INTO licences (license_type, description)
VALUES ("MIT License", "A short and simple permissive license with conditions only requiring preservation of copyright and license notices. Licensed works, modifications, and larger works may be distributed under different terms and without source code.");

INSERT INTO licences (license_type, description)
VALUES ("Apache License 2.0", "A permissive license whose main conditions require preservation of copyright and license notices. Contributors provide an express grant of patent rights. Licensed works, modifications, and larger works may be distributed under different terms and without source code.");

INSERT INTO licences (license_type, description)
VALUES ("GNU GPLv3", "Permissions of this strong copyleft license are conditioned on making available complete source code of licensed works and modifications, which include larger works using a licensed work, under the same license. Copyright and license notices must be preserved. Contributors provide an express grant of patent rights.");


INSERT INTO software (name, author_id,description, licence_id, app_type)
VALUES ("Plagiat checker", 1,"Check for plagiat for bachelor thesis", 2, "productive");

INSERT INTO software (name, author_id,description, licence_id, app_type)
VALUES ("Library manager", 2,"Access to a library", 1, "management");

INSERT INTO software (name, author_id,description, licence_id, app_type)
VALUES ("Social network", 2,"a new and fancy socieal network", 1, "networking");

INSERT INTO VERSIONS (software_id, version, release_info, release_date)
VALUES (1,"0.9a", "Add project files", now());

INSERT INTO VERSIONS (software_id, version, release_info, release_date)
VALUES (2,"1.0", "release versio", now());

INSERT INTO VERSIONS (software_id, version, release_info, release_date)
VALUES (3,"0.1.7", "Add share user feature", now());

INSERT INTO statistics(version_id, downloads_count, mark, active_users)
VALUES (1, 100, 4.5, 15);

INSERT INTO statistics(version_id, downloads_count, mark, active_users)
VALUES (2, 10000, 3.8, 1314);

INSERT INTO statistics(version_id, downloads_count, mark, active_users)
VALUES (3, 100, 4.9, 19);

INSERT INTO userversions(version_id, user_id)
VALUES (1, 2);

INSERT INTO userversions(version_id, user_id)
VALUES (2, 1);

INSERT INTO userversions(version_id, user_id)
VALUES (3, 3);

INSERT INTO userversions(version_id, user_id)
VALUES (2, 1);

INSERT INTO userversions(version_id, user_id)
VALUES (2, 3);