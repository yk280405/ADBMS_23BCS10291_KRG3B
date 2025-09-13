--easy problem
CREATE TABLE Employees (
    EmpID INT
);
INSERT INTO Employees (EmpID) VALUES
(101),(102),(103),(101),(104),(102),(105);
SELECT MAX(EmpID) AS MaxEmpID
FROM (
    SELECT DISTINCT EmpID
    FROM Employees
) AS DistinctEmpIDs;

--medium problem
CREATE TABLE Departments (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50)
);

CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(100),
    DeptID INT,
    Salary DECIMAL(10, 2),
    FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
);
INSERT INTO Departments (DeptID, DeptName) VALUES
(1, 'Sales'),
(2, 'Engineering'),
(3, 'HR');

INSERT INTO Employees (EmpID, EmpName, DeptID, Salary) VALUES
(101, 'Alice', 1, 70000),
(102, 'Bob', 1, 85000),
(103, 'Charlie', 2, 90000),
(104, 'David', 2, 90000), 
(105, 'Eve', 3, 60000),
(106, 'Frank', 3, 58000);

SELECT 
    E.EmpID, 
    E.EmpName, 
    E.DeptID, 
    D.DeptName, 
    E.Salary
FROM 
    Employees E
JOIN 
    Departments D ON E.DeptID = D.DeptID
WHERE 
    E.Salary = (
        SELECT MAX(Salary)
        FROM Employees
        WHERE DeptID = E.DeptID
    )
ORDER BY 
    E.DeptID, E.EmpName;
    
 
    -- Hard Problem 
    CREATE TABLE TableA (
    EmpID INT,
    EmpName VARCHAR(100),
    Salary DECIMAL(10, 2)
);

CREATE TABLE TableB (
    EmpID INT,
    EmpName VARCHAR(100),
    Salary DECIMAL(10, 2)
);

INSERT INTO TableA (EmpID, EmpName, Salary) VALUES
(101, 'Alice', 70000),
(102, 'Bob', 85000),
(103, 'Charlie', 90000),
(104, 'David', 78000);

INSERT INTO TableB (EmpID, EmpName, Salary) VALUES
(102, 'Bob', 82000),    
(103, 'Charlie', 91000), 
(105, 'Eve', 60000),
(106, 'Frank', 58000);

SELECT 
    M.EmpID,
    M.EmpName,
    M.Salary
FROM
(
    
    SELECT EmpID, EmpName, Salary FROM TableA
    UNION ALL
    SELECT EmpID, EmpName, Salary FROM TableB
) AS M
WHERE 
    M.Salary = (
        
        SELECT MIN(Salary)
        FROM
        (
            SELECT Salary FROM TableA WHERE EmpID = M.EmpID
            UNION ALL
            SELECT Salary FROM TableB WHERE EmpID = M.EmpID
        ) AS Salaries
    )
ORDER BY M.EmpID;






