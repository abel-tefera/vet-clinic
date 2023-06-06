/*Queries that provide answers to the questions from all projects.*/

-- Find all animals whose name ends in "mon".
SELECT * FROM animals where name LIKE '%mon';
-- List of the name of all animals born between 2016 and 2019.
SELECT name FROM animals where date_of_birth  BETWEEN '2016-01-01' AND '2019-12-31';
-- List of the name of all animals that are neutered and have less than 3 escape attempts.
SELECT name FROM animals where escape_attempts < 3 AND neutered =true;
-- List of date of birth of all animals named either "Agumon" or "Pikachu".
SELECT date_of_birth FROM animals where name='Agumon' OR name='Pikachu';
-- List of name and escape attempts of animals that weigh more than 10.5kg
SELECT name,escape_attempts FROM animals where weight_kg > 10.5;
-- Find all animals that are neutered.
SELECT * FROM animals where neutered =true;
-- Find all animals not named Gabumon.
SELECT * FROM animals where name!='Gabumon' ;
-- Find all animals with a weight between 10.4kg and 17.3kg (including the animals with the weights that equals precisely 10.4kg or 17.3kg)
SELECT * FROM animals where weight_kg>=10.4 AND weight_kg<=17.3;