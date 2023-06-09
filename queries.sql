/*Queries that provide answers to the questions from all projects.*/
-- Find all animals whose name ends in "mon".
SELECT
    *
FROM
    animals
where
    name LIKE '%mon';

-- List of the name of all animals born between 2016 and 2019.
SELECT
    name
FROM
    animals
where
    date_of_birth BETWEEN '2016-01-01'
    AND '2019-12-31';

-- List of the name of all animals that are neutered and have less than 3 escape attempts.
SELECT
    name
FROM
    animals
where
    escape_attempts < 3
    AND neutered = true;

-- List of date of birth of all animals named either "Agumon" or "Pikachu".
SELECT
    date_of_birth
FROM
    animals
where
    name = 'Agumon'
    OR name = 'Pikachu';

-- List of name and escape attempts of animals that weigh more than 10.5kg
SELECT
    name,
    escape_attempts
FROM
    animals
where
    weight_kg > 10.5;

-- Find all animals that are neutered.
SELECT
    *
FROM
    animals
where
    neutered = true;

-- Find all animals not named Gabumon.
SELECT
    *
FROM
    animals
where
    name != 'Gabumon';

-- Find all animals with a weight between 10.4kg and 17.3kg (including the animals with the weights that equals precisely 10.4kg or 17.3kg)
SELECT
    *
FROM
    animals
where
    weight_kg >= 10.4
    AND weight_kg <= 17.3;

BEGIN;

-- Update the animals table by setting the species column to digimon for all animals that have a name ending in mon.
UPDATE
    animals
SET
    species = 'digimon'
WHERE
    name like '%mon';

-- Update the animals table by setting the species column to pokemon for all animals that don't have species already set.
UPDATE
    animals
SET
    species = 'pokemon'
WHERE
    species is null;

-- Commit the transaction.
COMMIT;

BEGIN;

DELETE FROM
    animals
WHERE
    1 = 1;

ROLLBACK;

BEGIN;

-- Delete all animals born after Jan 1st, 2022.
DELETE From
    animals
WHERE
    date_of_birth > '01-01-2022';

-- Create a savepoint for the transaction.
SAVEPOINT dob_jan_2022;

-- Update all animals' weight to be their weight multiplied by -1.
UPDATE
    animals
SET
    weight_kg = weight_kg * -1;

-- Rollback to the savepoint
ROLLBACK TO dob_jan_2022;

-- Update all animals' weights that are negative to be their weight multiplied by -1.
UPDATE
    animals
SET
    weight_kg = weight_kg * -1
WHERE
    weight_kg < 0;

-- Commit transaction
COMMIT;

-- How many animals are there?
SELECT
    COUNT(*)
FROM
    animals;

-- How many animals have never tried to escape?
SELECT
    COUNT(*)
FROM
    animals
WHERE
    escape_attempts = 0;

-- What is the average weight of animals?
SELECT
    AVG(weight_kg)
FROM
    animals;

-- Who escapes the most, neutered or not neutered animals?
SELECT
    neutered
FROM
    animals
GROUP BY
    neutered
HAVING
    SUM(escape_attempts) = (
        SELECT
            MAX(max_attempt)
        FROM
            (
                SELECT
                    SUM(escape_attempts) AS max_attempt
                FROM
                    animals
                GROUP BY
                    neutered
            ) AS escapes
    );

-- What is the minimum and maximum weight of each type of animal?
SELECT
    MIN(weight_kg) MAX(weight_kg)
FROM
    animals;

-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT
    species,
    AVG(escape_attempts)
FROM
    animals
WHERE
    date_of_birth BETWEEN '01-01-1990'
    AND '12-31-2000'
GROUP BY
    species;

-- What animals belong to Melody Pond?
SELECT
    a.name,
    o.full_name
FROM
    animals a
    JOIN owners o ON a.owner_id = o.id
where
    o.full_name = 'Melody Pond';

-- List of all animals that are pokemon (their type is Pokemon).
SELECT
    a.name,
    s.name,
    a.date_of_birth
FROM
    animals a
    JOIN species s ON a.species_id = s.id
WHERE
    s.name = 'Pokemon';

-- List all owners and their animals, remember to include those that don't own any animal.
SELECT
    o.full_name,
    a.name
FROM
    owners o
    LEFT JOIN animals a ON o.id = a.owner_id;

-- How many animals are there per species?
SELECT
    count(*),
    s.name
FROM
    animals a
    JOIN species s ON a.species_id = s.id
GROUP BY
    s.id;

-- List all Digimon owned by Jennifer Orwell.
SELECT
    s.name,
    o.full_name,
    a.name
FROM
    animals a
    JOIN species s ON a.species_id = s.id
    JOIN owners o ON a.owner_id = o.id
WHERE
    o.full_name = 'Jennifer Orwell'
    AND s.name = 'Digimon';

-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT
    a.name
FROM
    animals a
    JOIN owners o ON a.owner_id = o.id
Where
    a.escape_attempts = 0
    AND o.full_name = 'Dean Winchester';

-- Who owns the most animals?
SELECT
    o2.full_name,
    ao.num
FROM
    (
        SELECT
            count(a.*) as num,
            a.owner_id
        FROM
            animals a
            JOIN owners o ON a.owner_id = o.id
        GROUP BY
            a.owner_id
    ) as ao
    JOIN owners o2 ON ao.owner_id = o2.id
WHERE
    ao.num = (
        select
            max(max_animals.num)
        FROM
            (
                SELECT
                    count(a.*) as num,
                    a.owner_id
                FROM
                    animals a
                    JOIN owners o ON a.owner_id = o.id
                GROUP BY
                    a.owner_id
            ) max_animals
    );

-- Who was the last animal seen by William Tatcher?
SELECT
    animals.name
FROM
    visits
    JOIN vets ON visits.vet_id = vets.id
    JOIN animals ON visits.animal_id = animals.id
WHERE
    vets.name = 'William Tatcher'
    AND visits.date_of_visit = (
        SELECT
            max(date_of_visit)
        FROM
            visits
            JOIN vets ON visits.vet_id = vets.id
        WHERE
            vets.name = 'William Tatcher'
    );

-- How many different animals did Stephanie Mendez see?
SELECT
    count(*)
FROM
    (
        SELECT
            DISTINCT animals.name,
            vets.name
        FROM
            visits
            JOIN vets ON visits.vet_id = vets.id
            JOIN animals ON visits.animal_id = animals.id
        Where
            vets.name = 'Stephanie Mendez'
    ) as counter;

;

-- List all vets and their specialties, including vets with no specialties.
SELECT
    vets.name,
    species.name
FROM
    vets
    LEFT JOIN specializations ON vets.id = specializations.vet_id
    LEFT JOIN species ON species.id = specializations.species_id;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT
    a.name
FROM
    animals a
    JOIN visits v ON a.id = v.animal_id
    JOIN vets ON v.vet_id = vets.id
WHERE
    vets.name = 'Stephanie Mendez'
    AND v.date_of_visit BETWEEN '4-1-2020'
    AND '8-30-2020';

-- What animal has the most visits to vets?
SELECT
    animals.name
FROM
    (
        SELECT
            count (*) as num_of_visit,
            animal_id
        FROM
            visits
        GROUP BY
            animal_id
        ORDER BY
            num_of_visit DESC
        LIMIT
            1
    ) top_visit
    JOIN animals ON top_visit.animal_id = animals.id;

-- Who was Maisy Smith's first visit?
SELECT
    animals.name,
    visits.date_of_visit
FROM
    visits
    JOIN vets ON visits.vet_id = vets.id
    JOIN animals ON animals.id = visits.animal_id
WHERE
    vets.name = 'Maisy Smith'
ORDER BY
    visits.date_of_visit
LIMIT
    1;

-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT
    animals.name as Animal,
    vets.name as Doctor,
    species.name as specializations,
    visits.date_of_visit as Date_of_Visit
FROM
    visits
    JOIN vets ON visits.vet_id = vets.id
    JOIN animals ON animals.id = visits.animal_id
    JOIN specializations ON vets.id = specializations.vet_id
    JOIN species ON species.id = specializations.species_id
ORDER BY
    visits.date_of_visit DESC
LIMIT
    1;

-- How many visits were with a vet that did not specialize in that animal's species?
SELECT
    count (*)
FROM
    (
        SELECT
            vets.name,
            species.name,
            vets.id
        FROM
            vets
            LEFT JOIN specializations ON vets.id = specializations.vet_id
            LEFT JOIN species ON species.id = specializations.species_id
        WHERE
            species.name IS NULL
    ) AS no_specializations
    JOIN visits ON visits.vet_id = no_specializations.id;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT
    top_visited
FROM
    (
        SELECT
            COUNT(*) as most_animal,
            species.name as top_visited
        FROM
            vets
            JOIN visits ON visits.vet_id = vets.id
            JOIN animals ON animals.id = visits.animal_id
            JOIN species ON species.id = animals.species_id
        WHERE
            vets.name = 'Maisy Smith'
        GROUP BY
            species.name
        ORDER BY
            most_animal DESC
        LIMIT
            1
    ) as most_visits;