/* Populate database with sample data. */
INSERT INTO
    animals(
        name,
        date_of_birth,
        escape_attempts,
        neutered,
        weight_kg
    )
VALUES
    ('Agumon', '2020-03-02', 0, true, 10.23),
    ('Gabumon', '2018-11-15', 2, true, 8),
    ('Pikachu', '2021-01-07', 1, false, 15.04),
    ('Devimon', '2017-05-12', 5, true, 11);

INSERT INTO
    animals (
        name,
        date_of_birth,
        weight_kg,
        neutered,
        escape_attempts
    )
VALUES
    ('Charmander', '2-8-2020', -11, '0', 0);

INSERT INTO
    animals (
        name,
        date_of_birth,
        weight_kg,
        neutered,
        escape_attempts
    )
VALUES
    ('Plantmon', '11-15-2021', -5.7, '1', 2);

INSERT INTO
    animals (
        name,
        date_of_birth,
        weight_kg,
        neutered,
        escape_attempts
    )
VALUES
    ('Squirtle', '4-2-1993', -12.13, '0', 3);

INSERT INTO
    animals (
        name,
        date_of_birth,
        weight_kg,
        neutered,
        escape_attempts
    )
VALUES
    ('Angemon', '6-12-2005', -45, '1', 1);

INSERT INTO
    animals (
        name,
        date_of_birth,
        weight_kg,
        neutered,
        escape_attempts
    )
VALUES
    ('Boarmon', '6-7-2005', 20.4, '1', 7);

INSERT INTO
    animals (
        name,
        date_of_birth,
        weight_kg,
        neutered,
        escape_attempts
    )
VALUES
    ('Blossom', '10-13-1998', 17, '1', 3);

INSERT INTO
    animals (
        name,
        date_of_birth,
        weight_kg,
        neutered,
        escape_attempts
    )
VALUES
    ('Ditto', '5-14-2022', 22, '1', 4);

INSERT INTO
    owners (full_name, age)
VALUES
    ('Sam Smith', 34),
    ('Jennifer Orwell', 19),
    ('Bob', 45),
    ('Melody Pond', 77),
    ('Dean Winchester', 14),
    ('Jodie Whittaker', 38);

INSERT INTO
    species (name)
VALUES
    ('Pokemon'),
    ('Digimon');

UPDATE
    animals
SET
    species_id = 2
WHERE
    name LIKE '%mon';

UPDATE
    animals
SET
    species_id = 1
WHERE
    species_id IS NULL;

UPDATE
    animals
SET
    owner_id = (
        select
            id
        from
            owners
        where
            full_name = 'Sam Smith'
        LIMIT
            1
    )
WHERE
    name = 'Agumon';

UPDATE
    animals
SET
    owner_id = (
        select
            id
        from
            owners
        where
            full_name = 'Jennifer Orwell'
        LIMIT
            1
    )
WHERE
    name in ('Gabumon', 'Pikachu');

UPDATE
    animals
SET
    owner_id = (
        select
            id
        from
            owners
        where
            full_name = 'Bob'
        LIMIT
            1
    )
WHERE
    name in('Devimon', 'Plantmon');

UPDATE
    animals
SET
    owner_id = (
        select
            id
        from
            owners
        where
            full_name = 'Melody Pond'
        LIMIT
            1
    )
WHERE
    name in ('Charmander', 'Squirtle', 'Blossom');

UPDATE
    animals
SET
    owner_id = (
        select
            id
        from
            owners
        where
            full_name = 'Dean Winchester'
        LIMIT
            1
    )
WHERE
    name in('Boarmon', 'Angemon');