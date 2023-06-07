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


BEGIN;

-- Update the animals table by setting the species column to digimon for all animals that have a name ending in mon.

UPDATE animals
SET species = 'digimon'
WHERE name like '%mon';

-- Update the animals table by setting the species column to pokemon for all animals that don't have species already set.

UPDATE animals
SET species = 'pokemon'
WHERE species is null;

-- Commit the transaction.

COMMIT;

BEGIN;

DELETE FROM animals WHERE 1=1;

ROLLBACK;


BEGIN; 

-- Delete all animals born after Jan 1st, 2022.

DELETE From animals
WHERE date_of_birth > '01-01-2022';

-- Create a savepoint for the transaction.

SAVEPOINT dob_jan_2022;

-- Update all animals' weight to be their weight multiplied by -1.

UPDATE animals
SET weight_kg = weight_kg * -1;

-- Rollback to the savepoint

ROLLBACK TO dob_jan_2022;

-- Update all animals' weights that are negative to be their weight multiplied by -1.

UPDATE animals
SET weight_kg = weight_kg * -1
WHERE weight_kg < 0;

-- Commit transaction

COMMIT;

-- How many animals are there?
SELECT COUNT(*) FROM animals;

-- How many animals have never tried to escape?
SELECT COUNT(*) FROM animals
WHERE escape_attempts = 0;

-- What is the average weight of animals?
SELECT AVG(weight_kg) FROM animals;

-- Who escapes the most, neutered or not neutered animals?
SELECT neutered
FROM animals
GROUP BY neutered
HAVING SUM(escape_attempts) = (
    SELECT MAX(max_attempt)
    FROM (
        SELECT SUM(escape_attempts) AS max_attempt
        FROM animals
        GROUP BY neutered
    ) AS escapes
);

-- What is the minimum and maximum weight of each type of animal?
SELECT MIN(weight_kg) MAX(weight_kg) FROM animals;

-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT species,AVG(escape_attempts) FROM animals
WHERE date_of_birth BETWEEN '01-01-1990' AND '12-31-2000' 
GROUP BY species;