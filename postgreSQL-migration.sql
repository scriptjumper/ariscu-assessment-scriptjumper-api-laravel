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

TABLESPACE pg_default;

ALTER TABLE tasks
    OWNER to postgres;

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

TABLESPACE pg_default;

