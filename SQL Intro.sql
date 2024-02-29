CREATE TABLE student (
   student_id INT PRIMARY KEY,
   name VARCHAR(20),
   major VARCHAR(20)
);
-- OR you can do it like this:
CREATE TABLE student (
   student_id INT,
   name VARCHAR(20),
   major VARCHAR(20),
   PRIMARY KEY(student_id));
-- View the database
DESCRIBE student

-- Delete the database
DROP TABLE student

-- Add and Delete a colum
ALTER TABLE student ADD gpa DECIMAL(3,2);

ALTER TABLE student DROP COLUMN gpa;

-- Add values to the table
INSERT INTO student VALUES(1,'Jack','Biology');
-- Just like in R, values need to be inserted in order of the column names 
-- Then select the whole table:
SELECT * FROM student

-- CONSTRAINTS
CREATE TABLE student (
   student_id INT,
   name VARCHAR(20) NOT NULL, -- You cannot enter null values for this field
   major VARCHAR(20) UNIQUE, -- Each value for this field must be different
   PRIMARY KEY(student_id)
);
SELECT * FROM student


INSERT INTO student VALUES(1,'Jack','Biology');
INSERT INTO student VALUES(2,'Kate','Sociology');
INSERT INTO student VALUES(3, 'Claire','Chemistry');
INSERT INTO student VALUES(4,'Jack',"Biology");
INSERT INTO student VALUES(5,'Mike','Computer Science');

-- CREATING DEFAULT VALUES 
CREATE TABLE student (
   student_id INT,
   name VARCHAR(20),
   major VARCHAR(20) DEFAULT 'undecided',
   PRIMARY KEY(student_id)
);
SELECT * FROM student

INSERT INTO student(student_id,name) VALUES(1,'Jack');
INSERT INTO student VALUES(2,'Kate','Sociology');
INSERT INTO student VALUES(3, 'Claire','Chemistry');
INSERT INTO student VALUES(4,'Jack',"Biology");
INSERT INTO student VALUES(5,'Mike','Computer Science');

-- UPDATE AND DELETE 
UPDATE student
SET major = 'Bio'
WHERE major = 'Biology';
-- Students with biology and chem majors are now biochem major
UPDATE student
SET major =  'Biochemistry'
WHERE major = 'Bio' OR major = 'Chemistry';

-- Change multiple things at once
UPDATE student
SET name = 'Tom', major = 'Undecided'
WHERE student_id = 1;
-- If you take out the where condition, it will apply it to all rows

DELETE FROM student
WHERE student_id = 5;
-- Delete on multiple conditions
DELETE FROM student
WHERE name = 'Tom' AND major = 'Undecided';

--Delete everything from the table
DELETE FROM student;

-- QUERIES 
SELECT student.name, student.major -- typing it this way helps to keep it organized when the queries get more complex 
FROM student;

-- Selecting and Ordering output
SELECT *
FROM student
ORDER BY major, student_id; -- It will order by major first and THEN by student_id
-- Can order it by DESCENDING
SELECT *  
FROM student
ORDER BY student_id DESC;
-- OR
SELECT *
FROM student
ORDER BY student_id ASC;

-- Can also limit the number of entries that are returned
SELECT *
FROM student
ORDER BY student_id
LIMIT 2;

-- OPTIONAL SELECTING --
SELECT *
FROM student
WHERE major = 'Chemistry';

SELECT name, major
FROM student
WHERE major = 'Chemistry' OR major = 'Biology';

SELECT name, major
FROM student
WHERE major = 'Chemistry' OR name = 'Kate';

-- OPERATIONAL SIGNS --
-- < , > , <= , >= Less than or equal to
-- = , <> Not Equal to, AND, OR
SELECT name, major
FROM student
WHERE major <> 'Chemistry';

SELECT name, major
FROM student
WHERE student_id <3;

SELECT name, major
FROM student
WHERE student_id <3 AND name <> 'Jack';

-- Using IN keyword --
SELECT *
FROM student
WHERE name IN('Claire', 'Kate', 'Mike');

SELECT *
FROM student
WHERE major IN('Biology', 'Chemistry') AND student_id >2;

-- MORE COMPLEX DATABASE EXAMPLE -- 
-- THE OFFICE EXAMPLE -- 
CREATE TABLE employee (
  emp_id INT PRIMARY KEY,
  first_name VARCHAR(40),
  last_name VARCHAR(40),
  birth_day DATE,
  sex VARCHAR(1),
  salary INT,
  super_id INT,
  branch_id INT
);

CREATE TABLE branch (
  branch_id INT PRIMARY KEY,
  branch_name VARCHAR(40),
  mgr_id INT,
  mgr_start_date DATE,
  FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL
);
ALTER TABLE employee
ADD FOREIGN KEY(branch_id)
REFERENCES branch(branch_id)
ON DELETE SET NULL;

ALTER TABLE employee
ADD FOREIGN KEY(super_id)
REFERENCES employee(emp_id)
ON DELETE SET NULL;

CREATE TABLE client (
  client_id INT PRIMARY KEY,
  client_name VARCHAR(40),
  branch_id INT,
  FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL
);

CREATE TABLE works_with (
  emp_id INT,
  client_id INT,
  total_sales INT,
  PRIMARY KEY(emp_id, client_id),
  FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
  FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE
);

CREATE TABLE branch_supplier (
  branch_id INT,
  supplier_name VARCHAR(40),
  supply_type VARCHAR(40),
  PRIMARY KEY(branch_id, supplier_name),
  FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);


-- -----------------------------------------------------------------------------

-- Corporate
INSERT INTO employee VALUES(100, 'David', 'Wallace', '1967-11-17', 'M', 250000, NULL, NULL);

INSERT INTO branch VALUES(1, 'Corporate', 100, '2006-02-09');

UPDATE employee
SET branch_id = 1
WHERE emp_id = 100;

INSERT INTO employee VALUES(101, 'Jan', 'Levinson', '1961-05-11', 'F', 110000, 100, 1);

-- Scranton
INSERT INTO employee VALUES(102, 'Michael', 'Scott', '1964-03-15', 'M', 75000, 100, NULL);

INSERT INTO branch VALUES(2, 'Scranton', 102, '1992-04-06');

UPDATE employee
SET branch_id = 2
WHERE emp_id = 102;

INSERT INTO employee VALUES(103, 'Angela', 'Martin', '1971-06-25', 'F', 63000, 102, 2);
INSERT INTO employee VALUES(104, 'Kelly', 'Kapoor', '1980-02-05', 'F', 55000, 102, 2);
INSERT INTO employee VALUES(105, 'Stanley', 'Hudson', '1958-02-19', 'M', 69000, 102, 2);

-- Stamford
INSERT INTO employee VALUES(106, 'Josh', 'Porter', '1969-09-05', 'M', 78000, 100, NULL);

INSERT INTO branch VALUES(3, 'Stamford', 106, '1998-02-13');

UPDATE employee
SET branch_id = 3
WHERE emp_id = 106;

INSERT INTO employee VALUES(107, 'Andy', 'Bernard', '1973-07-22', 'M', 65000, 106, 3);
INSERT INTO employee VALUES(108, 'Jim', 'Halpert', '1978-10-01', 'M', 71000, 106, 3);


-- BRANCH SUPPLIER
INSERT INTO branch_supplier VALUES(2, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Patriot Paper', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'J.T. Forms & Labels', 'Custom Forms');
INSERT INTO branch_supplier VALUES(3, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(3, 'Stamford Lables', 'Custom Forms');

-- CLIENT
INSERT INTO client VALUES(400, 'Dunmore Highschool', 2);
INSERT INTO client VALUES(401, 'Lackawana Country', 2);
INSERT INTO client VALUES(402, 'FedEx', 3);
INSERT INTO client VALUES(403, 'John Daly Law, LLC', 3);
INSERT INTO client VALUES(404, 'Scranton Whitepages', 2);
INSERT INTO client VALUES(405, 'Times Newspaper', 3);
INSERT INTO client VALUES(406, 'FedEx', 2);

-- WORKS_WITH
INSERT INTO works_with VALUES(105, 400, 55000);
INSERT INTO works_with VALUES(102, 401, 267000);
INSERT INTO works_with VALUES(108, 402, 22500);
INSERT INTO works_with VALUES(107, 403, 5000);
INSERT INTO works_with VALUES(108, 403, 12000);
INSERT INTO works_with VALUES(105, 404, 33000);
INSERT INTO works_with VALUES(107, 405, 26000);
INSERT INTO works_with VALUES(102, 406, 15000);
INSERT INTO works_with VALUES(105, 406, 130000);

-- QUERYING
-- Find all employees/clients
SELECT * 
FROM employee;

SELECT *
FROM client 

-- Find all employees ordered by salary
SELECT *
FROM employee
ORDER BY salary DESC;

-- Find all employees ordered by sex than name
SELECT *
FROM employee
ORDER BY sex, first_name, last_name;

-- Find the first five employees in the table
SELECT *
FROM employee
LIMIT 5;

-- Find the first and last names of all employees
SELECT first_name, last_name
FROM employee;

-- Find the forename and surname of all employees
-- CAN USE "AS" to rename the column in the dataset
SELECT first_name AS forename, last_name AS surname
FROM employee;

-- Find out all the different genders
-- Can use "DISTINCT" to find unique values in a column
SELECT DISTINCT branch_id
FROM employee;

-- FUNCTIONS -- 
-- Find the number of employees
SELECT COUNT(emp_id) -- Counting how many employee id's are in a table
FROM employee;

SELECT COUNT(super_id)
FROM employee;

-- Find the number of female employees born after 1970
SELECT COUNT(emp_id)
FROM employee
WHERE sex = 'F' AND birth_day > '1971-01-01';

-- Find the average of all employee salaries
SELECT AVG(salary)
FROM employee;
-- Find the average of all male employee salaries
SELECT AVG(salary)
FROM employee
WHERE sex = 'M';

-- Find the sum of all employee salaries
SELECT SUM(salary)
FROM employee;

-- Find out how many and how many females there are
-- USING "GROUP BY" aggregates the values into categories 
SELECT COUNT(sex), sex
FROM employee
GROUP BY sex;

-- Find the total sales of each salesman
SELECT SUM(total_sales), emp_id
FROM works_with
GROUP BY emp_id;

-- Find how much each client spent 
SELECT SUM(total_sales), client_id
FROM works_with
GROUP BY client_id;

-- WILDCARDS AND KEYWORDS --
-- Can use certain characters to create an expression
---- % = any number of characters
---- _ = one character 

-- Find any clients who are an LLC
SELECT *
FROM client
WHERE client_name LIKE '%LLC';

-- Find any branch suppliers that are in the label business
SELECT *
FROM branch_supplier
WHERE supplier_name LIKE '%Labels%';

-- Find employees born in October
SELECT *
FROM employee
WHERE birth_day LIKE '____-10%';

-- Find clients who are schools
SELECT *
FROM client
WHERE client_name LIKE '%school';

---- UNIONS ----
--- Find a list of employee and branch names
--Just employees
SELECT first_name
FROM employee;
-- Branch names
SELECT branch_name
FROM branch;
-- United them
----- you must have the same number of columns in the query ask
----- must also both be the same data type: two numbers or two strings, etc
SELECT first_name
FROM employee
UNION
SELECT branch_name
FROM branch
UNION
SELECT client_name
FROM client;

-- Find a list of all clients and branch suppliers names with branch id
SELECT client_name, client.branch_id
FROM client
UNION
SELECT supplier_name, branch_supplier.branch_id
FROM branch_supplier;

-- Find all money earned or spent by the company
SELECT salary
FROM employee
UNION
SELECT total_sales
FROM works_with;

-- JOINS --
INSERT INTO branch VALUES(4, 'Buffalo', NULL, NULL);

-- Find all branches and the names of their managers
-- INNER JOIN -- 
SELECT employee.emp_id, employee.first_name, branch.branch_name 
FROM employee
JOIN branch
ON employee.emp_id = branch.mgr_id;

-- LEFT JOIN --
-- You will get all results from the left input table, employees
SELECT employee.emp_id, employee.first_name, branch.branch_name 
FROM employee
LEFT JOIN branch
ON employee.emp_id = branch.mgr_id;

-- RIGHT JOIN --
-- You will get all results from the right input table, branch
SELECT employee.emp_id, employee.first_name, branch.branch_name 
FROM employee
RIGHT JOIN branch
ON employee.emp_id = branch.mgr_id;

-- NESTED QUERIES -- 

-- Find names of all employees who have sold over 30,000 to a single client
Select employee.first_name, employee.last_name
From employee
Where employee.emp_id IN(
    Select works_with.emp_id
    FROM works_with
    Where works_with.total_sales > 30000
);

-- Non-nested version
Select works_with.emp_id
From works_with
Where works_with.total_sales > 30000;

Select employee.emp_id, employee.first_name, employee.last_name 
From employee
Where emp_id = 102 OR emp_id = 105;

-- Find all clients who are handled by the branch that Micheal Scott manages
-- Assume you know Michaels id
Select client.client_name
From client
Where client.branch_id = (
Select branch.branch_id
From branch
Where branch.mgr_id = 102);

-- DELETING --
-- SET NULL
Create Table branch(
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(40),
    mgr_id INT,
    mgr_start_date DATE,
    FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL -- This means that when the employee_id is deleted the manager id in the branch table gets set to NULL 
    -- Okay to use NULL because mgr_id is not a primary key, so it is not essential for the branch table
);

Delete FROM employee 
Where emp_id = 102;
Select *
From branch;
Select *
From employee;

-- CASCADE
Create Table branch_supplier(
    branch_id INT,
    supplier_name VARCHAR(40),
    supply_type VARCHAR(40),
    PRIMARY KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE -- This means that when the employee_id is deleted the whole row in the branch table gets deleted
   -- The branch_id is the primary key and that cannot be a NULL value, so the row must be deleted 
);

Delete FROM branch
Where branch_id = 2;
Select *
From branch_supplier;

-- TRIGGERS --
Create Table trigger_test (
    message VARCHAR(100)
);

--The SQL delimiter is the ; 
-- So the delimiter needs to be changed to process the trigger 
DELIMITER $$
Create
Trigger my_trigger BEFORE INSERT
ON employee
For Each Row Begin 
Insert Into trigger_test VALUES('added new employee');
END $$
DELIMITER ; -- Then at the end of it you change the delimiter back 

Insert Into employee
VALUES(109, 'Oscar', 'Martinez', '1968-02-19', 'M', 69000, 106, 3);

-- See if the trigger test worked
Select *
From trigger_test;

-- Pulling the first name for the newly added employee when added to the employee table 
DELIMITER $$
Create 
Trigger my_trigger1 Before Insert 
On employee
For Each Row Begin 
Insert Into trigger_test VALUES(New.first_name);
END $$
DELIMITER ; 

Insert Into employee
VALUES(110, 'Kevin', 'Malone', '1978-02-19', 'M', 69000, 106, 3);

Select * 
From trigger_test;
-- You get added new employee, and the new employee name added 

-- Conditional Trigger 
DELIMITER $$
Create 
Trigger my_trigger2 Before Insert 
On employee 
For Each Row Begin 
IF New.sex = 'M' THEN 
Insert Into trigger_test VALUES('added male employee');
ELSEIF New.sex = 'F' THEN
Insert Into trigger_test VALUES('added female employee');
ELSE
Insert Into trigger_test VALUES('added other employee');
END IF;
END $$
DELIMITER ; 

Insert Into employee 
VALUES(111, 'Pam', 'Beesly', '1988-02-19', 'F', 69000, 106, 3);

Select * 
From trigger_test;

-- Dropping a trigger
DROP TRIGGER my_trigger;
