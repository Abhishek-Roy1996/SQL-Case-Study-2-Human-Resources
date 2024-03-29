create database hr_database;

use hr_database;

CREATE TABLE departments (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    manager_id INT
);

CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    hire_date DATE,
    job_title VARCHAR(50),
    department_id INT REFERENCES departments(id)
);

CREATE TABLE projects (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    start_date DATE,
    end_date DATE,
    department_id INT REFERENCES departments(id)
);

INSERT INTO departments (name, manager_id)
VALUES ('HR', 1), ('IT', 2), ('Sales', 3);

INSERT INTO employees (name, hire_date, job_title, department_id)
VALUES ('John Doe', '2018-06-20', 'HR Manager', 1),
       ('Jane Smith', '2019-07-15', 'IT Manager', 2),
       ('Alice Johnson', '2020-01-10', 'Sales Manager', 3),
       ('Bob Miller', '2021-04-30', 'HR Associate', 1),
       ('Charlie Brown', '2022-10-01', 'IT Associate', 2),
       ('Dave Davis', '2023-03-15', 'Sales Associate', 3);
       
INSERT INTO projects (name, start_date, end_date, department_id)
VALUES ('HR Project 1', '2023-01-01', '2023-06-30', 1),
       ('IT Project 1', '2023-02-01', '2023-07-31', 2),
       ('Sales Project 1', '2023-03-01', '2023-08-31', 3);
       
UPDATE departments
SET manager_id = (SELECT id FROM employees WHERE name = 'John Doe')
WHERE name = 'HR';

UPDATE departments
SET manager_id = (SELECT id FROM employees WHERE name = 'Jane Smith')
WHERE name = 'IT';

UPDATE departments
SET manager_id = (SELECT id FROM employees WHERE name = 'Alice Johnson')
WHERE name = 'Sales';

/* 1. Find the longest ongoing project for each department.
2. Find all employees who are not managers.
3. Find all employees who have been hired after the start of a project in their department.
4. Rank employees within each department based on their hire date (earliest hire gets the highest rank).
5. Find the duration between the hire date of each employee and the hire date of the next employee 
hired in the same department.*/

-- 1. Find the longest ongoing project for each department.

select d.name as DepartmentName,p.name,p.start_date,p.end_date,datediff(end_date,start_date) as LongestProject
from departments d inner join projects p on p.department_id=d.id;

select d.name as DepartmentName,p.name,p.start_date,p.end_date,timestampdiff(day,start_date,end_date) as LongestProject
from departments d inner join projects p on p.department_id=d.id;

-- 2. Find all employees who are not managers.

select name,job_title
from employees
where job_title not like "%manager%";

select name,job_title
from employees
where id not in (select manager_id from departments);

-- 3. Find all employees who have been hired after the start of a project in their department.

select e.name,e.hire_date,p.start_date
from employees e join projects p using(department_id)
where e.hire_date>p.start_date;

-- 4. Rank employees within each department based on their hire date (earliest hire gets the highest rank).

select *,rank () over (partition by department_id order by hire_date asc) as Rnk
from employees;


