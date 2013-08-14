CREATE DATABASE airdnp;
\c airdnp

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email character varying(255) NOT NULL,
  zip_code character varying(255) NOT NULL,
  price integer NOT NULL
);

CREATE TABLE deals (
  id SERIAL PRIMARY KEY,
  search_id integer NOT NULL,
  zip_code character varying(255) NOT NULL,
  start_date date NOT NULL,
  price integer NOT NULL,
  found_date date,
  currency_code character varying(255),
  night_duration integer,
  headline character varying(255),
  is_weekend_stay boolean,
  city character varying(255),
  state_code character varying(255),
  country_code character varying(255),
  neighborhood_latitude float,
  neighborhood_longitude float,
  neighborhood character varying(255),
  star_rating integer
);

CREATE TABLE searches (
  id SERIAL PRIMARY KEY,
  zip_code character varying(255) NOT NULL,
  search_date date NOT NULL
)
