CREATE DATABASE airdnp;
\c airdnp

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email character varying(255) NOT NULL,
  name character varying(255) NOT NULL
);

CREATE TABLE hotels (
  id SERIAL PRIMARY KEY,
  name character varying(255) NOT NULL,
  longitude float NOT NULL,
  latitude float NOT NULL
);

CREATE TABLE bookings (
  id SERIAL PRIMARY KEY,
  start_date timestamp NOT NULL,
  end_date timestamp NOT NULL
);
