-- Drop tables if they exist
DROP TABLE IF EXISTS nobel_laureates CASCADE;
DROP TABLE IF EXISTS discoveries CASCADE;

-- Nobel laureates table
CREATE TABLE nobel_laureates (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    field VARCHAR(50) NOT NULL,
    year_award INT NOT NULL,
    prize_amount DECIMAL(12, 2) NOT NULL,
    age_at_award INT NOT NULL
);

-- Discoveries table
CREATE TABLE discoveries (
    id SERIAL PRIMARY KEY,
    laureate_id INT REFERENCES nobel_laureates(id) ON DELETE CASCADE,
    discovery VARCHAR(255) NOT NULL,
    year_discovery INT NOT NULL,
    research_funding DECIMAL(12, 2) NOT NULL,
    citation_count INT NOT NULL
);

-- Insert data into nobel_laureates table
INSERT INTO nobel_laureates (name, field, year_award, prize_amount, age_at_award) VALUES  
('Marie Curie', 'Physics', 1903, 15000.00, 36),
('Dorothy Hodgkin', 'Chemistry', 1964, 273000.00, 54),
('Barbara McClintock', 'Physiology', 1983, 1900000.00, 81),
('Richard Feynman', 'Physics', 1965, 282000.00, 47),
('Frederick Sanger', 'Chemistry', 1958, 250000.00, 40),
('Werner Heisenberg', 'Physics', 1932, 159917.00, 31),
('Gertrude Elion', 'Physiology', 1988, 2100000.00, 70),
('Linus Pauling', 'Chemistry', 1954, 236000.00, 53),
('Max Planck', 'Physics', 1918, 38840.00, 60),
('Elizabeth Blackburn', 'Physiology', 2009, 10000000.00, 61);

-- Insert data into discoveries table
INSERT INTO discoveries (laureate_id, discovery, year_discovery, research_funding, citation_count) VALUES  
(1, 'Discovery of Radium and Polonium', 1898, 5000.00, 12500),
(2, 'Structure of Vitamin B12', 1954, 30000.00, 8900),
(3, 'Mobile Genetic Elements', 1950, 35000.00, 7800),
(4, 'Quantum Electrodynamics', 1948, 25000.00, 13400),
(5, 'Protein and Insulin Sequencing', 1951, 28000.00, 9500),
(6, 'Uncertainty Principle', 1927, 8000.00, 9800),
(7, 'Drug Development Through Rational Design', 1980, 150000.00, 9200),
(8, 'Chemical Bond Nature', 1931, 15000.00, 11200),
(9, 'Quantum Theory', 1900, 3000.00, 14000),
(10, 'Telomeres and Telomerase', 1984, 180000.00, 10500);

-- Question 1: List the names of laureates who were awarded the Nobel Prize after the age of 50.
SELECT name 
FROM nobel_laureates
WHERE age_at_award > 50;

-- Question 2: Calculate the total prize money awarded to laureates in the field of Physiology.
SELECT SUM(prize_amount) AS total_prize_money
FROM nobel_laureates
WHERE field = 'Physiology';

-- Question 3: What is the average citation count for discoveries made before 1950?
SELECT AVG(citation_count) AS average_citation_count
FROM discoveries
WHERE year_discovery < 1950;

-- Question 4: Calculate the average age of laureates when they received their award, grouped by field.
SELECT field, AVG(age_at_award) AS average_age_at_award
FROM nobel_laureates
GROUP BY field;

-- Question 5: List the top three most cited discoveries along with their citation counts.
SELECT discovery, citation_count
FROM discoveries
ORDER BY citation_count DESC
LIMIT 3;

-- Question 6: Find all laureates who have more than one discovery listed in the database.
SELECT nl.name
FROM nobel_laureates nl
JOIN discoveries d ON nl.id = d.laureate_id
GROUP BY nl.name
HAVING COUNT(d.id) > 1;

-- Question 7: Calculate the total research funding for discoveries made by laureates in each field.
SELECT nl.field, SUM(d.research_funding) AS total_research_funding
FROM nobel_laureates nl
JOIN discoveries d ON nl.id = d.laureate_id
GROUP BY nl.field;

-- Question 8: Which laureate had the longest gap between their discovery and receiving their Nobel Prize?
SELECT nl.name, (nl.year_award - d.year_discovery) AS gap_years
FROM nobel_laureates nl
JOIN discoveries d ON nl.id = d.laureate_id
ORDER BY gap_years DESC
LIMIT 1;

-- Question 9: Find all laureates whose names contain the string "in".
SELECT name
FROM nobel_laureates
WHERE name ILIKE '%in%';


-- Question 10: Find all discoveries that had research funding over $10,000 and more than 1000 citations.
SELECT discovery, research_funding, citation_count
FROM discoveries
WHERE research_funding > 10000 AND citation_count > 1000;

-- Question 11: What percentage of all discoveries were funded with more than $20,000?
SELECT (COUNT(*) FILTER (WHERE research_funding > 20000) * 100.0 / COUNT(*)) AS percentage_funded_over_20000
FROM discoveries;

-- Question 12: Rank all discoveries by citation count within each field (Physics, Chemistry, etc.).
SELECT nl.field, d.discovery, d.citation_count,
       RANK() OVER (PARTITION BY nl.field ORDER BY d.citation_count DESC) AS citation_rank
FROM nobel_laureates nl
JOIN discoveries d ON nl.id = d.laureate_id
ORDER BY nl.field, citation_rank;