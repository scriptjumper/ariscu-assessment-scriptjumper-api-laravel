/*
** PostgreSQL database migration file
*/

-- Database: staging

-- DROP DATABASE staging;

CREATE DATABASE staging
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'C'
    LC_CTYPE = 'C'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

-- Table: users

-- DROP TABLE users;

CREATE TABLE users
(
    id integer NOT NULL DEFAULT nextval('users_id_seq'::regclass),
    "firstName" character varying(255) COLLATE pg_catalog."default" NOT NULL,
    "lastName" character varying(255) COLLATE pg_catalog."default" NOT NULL,
    email character varying(255) COLLATE pg_catalog."default" NOT NULL,
    avatar text COLLATE pg_catalog."default" NOT NULL DEFAULT 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mMsevenHgAHEwLd6swckQAAAABJRU5ErkJggg=='::text,
    email_verified_at timestamp(0) without time zone,
    password character varying(255) COLLATE pg_catalog."default" NOT NULL,
    remember_token character varying(100) COLLATE pg_catalog."default",
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    CONSTRAINT users_pkey PRIMARY KEY (id),
    CONSTRAINT users_email_unique UNIQUE (email)
)

-- INSERT Users

/* 
    INSERT INTO users(
        "firstName", "lastName", email, avatar, email_verified_at, password, remember_token, created_at, updated_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);
 */

INSERT INTO users(
    id, "firstName", "lastName", email, avatar, email_verified_at, password, remember_token, created_at, updated_at)
    VALUES  (1, 'Shaeen', 'Singh', 'shaeenkevinsingh@gmail.com', 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mMsevenHgAHEwLd6swckQAAAABJRU5ErkJggg==', null, '$2y$10$T/uHvuPbMW.Cl6g.HhaUJOugTkt68zekKuSFLsuIYW21DrHIFCwN2', null, '2020-04-07 05:04:07', '2020-04-07 05:05:33'),
            (2, 'Test', 'User', 'testuser@test.com', 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mMsevenHgAHEwLd6swckQAAAABJRU5ErkJggg==', null, '$2y$10$T/uHvuPbMW.Cl6g.HhaUJOugTkt68zekKuSFLsuIYW21DrHIFCwN2', null, '2020-04-07 05:06:15', '2020-04-07 05:06:15');

-- Table: tasks

-- DROP TABLE tasks;

CREATE TABLE tasks
(
    id integer NOT NULL DEFAULT nextval('tasks_id_seq'::regclass),
    user_id integer NOT NULL,
    title character varying(255) COLLATE pg_catalog."default" NOT NULL,
    "isComplete" boolean NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    CONSTRAINT tasks_pkey PRIMARY KEY (id)
)

-- INSERT to-do Tasks

/* 
    INSERT INTO tasks(
        user_id, title, "isComplete", created_at, updated_at)
        VALUES (?, ?, ?, ?, ?);
*/

INSERT INTO tasks(
user_id, title, "isComplete", created_at, updated_at)
	VALUES (1,	'Repeat',	false,	'2020-04-07 05:04:23',	'2020-04-07 05:04:23'),
	(1,	'Sleep',	false,	'2020-04-07 05:04:34',	'2020-04-07 05:04:34'),
	(1,	'Code',	false,	'2020-04-07 05:04:40',	'2020-04-07 05:04:40'),
	(1,	'Eat',	false,	'2020-04-07 05:04:59',	'2020-04-07 05:04:59'),
	(2,	'Each user sees their own to-do tasks ;)', true, '2020-04-07 05:06:38',	'2020-04-07 05:09:32'),
	(2,	'User can create, read, update and delete to-do tasks', true, '2020-04-07 05:07:16',	'2020-04-07 05:09:33'),
	(2,	'New users can create an account', true, '2020-04-07 05:07:39',	'2020-04-07 05:09:34'),
	(2,	'Users can login and logout', true, '2020-04-07 05:07:58',	'2020-04-07 05:10:40'),
	(2,	'Users can change their own avatar image', true, '2020-04-07 05:08:25',	'2020-04-07 05:09:36'),
	(2,	'Avatar is displayed in the navigation bar', true, '2020-04-07 05:08:49',	'2020-04-07 05:09:36'),
	(2,	'All users have the access to click on the Settings link in the navbar', true, '2020-04-07 05:09:30',	'2020-04-07 05:09:37');