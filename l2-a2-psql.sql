CREATE DATABASE conservation_db;

CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    region VARCHAR(50) NOT NULL
);

CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(50),
    scientific_name VARCHAR(50),
    discovery_date DATE,
    conservation_status VARCHAR(40)
);

CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INT REFERENCES rangers (ranger_id) ON DELETE SET NULL,
    species_id INT REFERENCES species (species_id) ON DELETE SET NULL,
    sighting_time TIMESTAMP,
    location VARCHAR(50),
    notes TEXT
);

INSERT INTO
    rangers (name, region)
VALUES (
        'Alice Green',
        'Northern Hills'
    ),
    ('Bob White', 'River Delta'),
    (
        'Carol King',
        'Mountain Range'
    ),
    (
        'David Black',
        'Coastal Plains'
    ),
    ('Eva Brown', 'Desert Edge');

INSERT INTO
    species (
        common_name,
        scientific_name,
        discovery_date,
        conservation_status
    )
VALUES (
        'Snow Leopard',
        'Panthera uncia',
        '1775-01-01',
        'Endangered'
    ),
    (
        'Bengal Tiger',
        'Panthera tigris',
        '1758-01-01',
        'Endangered'
    ),
    (
        'Red Panda',
        'Ailurus fulgens',
        '1825-01-01',
        'Vulnerable'
    ),
    (
        'Asiatic Elephant',
        'Elephas maximus indicus',
        '1758-01-01',
        'Endangered'
    ),
    (
        'Golden Langur',
        'Trachypithecus geei',
        '1953-01-01',
        'Endangered'
    ),
    (
        'Indian Pangolin',
        'Manis crassicaudata',
        '1822-01-01',
        'Near Threatened'
    );

INSERT INTO
    sightings (
        sighting_id,
        species_id,
        ranger_id,
        location,
        sighting_time,
        notes
    )
VALUES (
        1,
        1,
        1,
        'Peak Ridge',
        '2024-05-10 07:45:00',
        'Camera trap image captured'
    ),
    (
        2,
        2,
        2,
        'Bankwood Area',
        '2024-05-12 16:20:00',
        'Juvenile seen'
    ),
    (
        3,
        3,
        3,
        'Bamboo Grove East',
        '2024-05-15 09:10:00',
        'Feeding observed'
    ),
    (
        4,
        1,
        2,
        'Snowfall Pass',
        '2024-05-18 18:30:00',
        NULL
    ),
    (
        5,
        2,
        1,
        'Crystal Creek',
        '2024-05-20 06:50:00',
        'Tracks found near water'
    ),
    (
        6,
        3,
        2,
        'Misty Hollow',
        '2024-05-22 14:15:00',
        'Group resting under trees'
    );

-- problem 1
INSERT INTO
    rangers (name, region)
VALUES ('Derek Fox', 'Coastal Plains');

-- problem 2
SELECT COUNT(DISTINCT species_id) AS unique_species_count
FROM sightings;

-- problem 3
SELECT * FROM sightings WHERE location ILIKE '%Pass%';

-- problem 4
SELECT r.name AS name, count(s.ranger_id) AS total_sightings
FROM sightings s
    JOIN rangers r ON s.ranger_id = r.ranger_id
GROUP BY
    s.ranger_id,
    r.name;

-- problem 5
SELECT sp.common_name
FROM species sp
    LEFT JOIN sightings s ON sp.species_id = s.species_id
WHERE
    s.sighting_id IS NULL;

-- problem 6
SELECT sp.common_name, s.sighting_time, r.name
FROM
    sightings s
    JOIN rangers r ON s.ranger_id = r.ranger_id
    JOIN species sp ON s.species_id = sp.species_id
ORDER BY s.sighting_time DESC
LIMIT 2;

-- problem 7
UPDATE species
SET
    conservation_status = 'Historic'
WHERE
    discovery_date < DATE '1800-01-01';

-- problem - 8
SELECT
    sighting_id,
    CASE
        WHEN DATE_PART('hour', sighting_time) < 12 THEN 'Morning'
        WHEN DATE_PART('hour', sighting_time) BETWEEN 12 AND 16  THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM sightings;

-- problem 9
DELETE FROM rangers r
WHERE NOT EXISTS (
  SELECT *
  FROM sightings s
  WHERE s.ranger_id = r.ranger_id
);



SELECT * FROM rangers;

SELECT * FROM species;

SELECT * FROM sightings;