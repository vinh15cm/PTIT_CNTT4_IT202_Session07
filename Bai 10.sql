create database b10_s7;
use b10_s7;
CREATE TABLE STUDENT (
  stu_id INT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  class VARCHAR(20) NOT NULL
);

CREATE TABLE SUBJECT (
  subject_id INT PRIMARY KEY,
  subject_name VARCHAR(50) NOT NULL,
  credit INT NOT NULL
);

CREATE TABLE EXAM (
  exam_id INT PRIMARY KEY,
  stu_id INT NOT NULL,
  subject_id INT NOT NULL,
  mark DECIMAL(4,1) NOT NULL,
  exam_date DATE NOT NULL,
  FOREIGN KEY (stu_id) REFERENCES STUDENT(stu_id),
  FOREIGN KEY (subject_id) REFERENCES SUBJECT(subject_id)
);

INSERT INTO STUDENT (stu_id, name, class) VALUES
(1,'An','CNTT1'),
(2,'Bình','CNTT1'),
(3,'Chi','CNTT2');

INSERT INTO SUBJECT (subject_id, subject_name, credit) VALUES
(1,'SQL',3),
(2,'Java',4),
(3,'OOP',3);

INSERT INTO EXAM (exam_id, stu_id, subject_id, mark, exam_date) VALUES
(1,1,1,8,'2024-06-01'),
(2,1,1,9,'2024-07-01'),
(3,2,1,6,'2024-06-01'),
(4,2,2,7,'2024-06-01'),
(5,3,1,9,'2024-06-01');

-- bài 1
SELECT DISTINCT s.stu_id, s.name, s.class
FROM STUDENT s
JOIN EXAM e ON e.stu_id = s.stu_id
JOIN SUBJECT sub ON sub.subject_id = e.subject_id
WHERE sub.subject_name = 'SQL'
  AND e.mark > (
    SELECT AVG(e2.mark)
    FROM EXAM e2
    JOIN SUBJECT sub2 ON sub2.subject_id = e2.subject_id
    WHERE sub2.subject_name = 'SQL'
  );

-- Bài 2
SELECT DISTINCT s.stu_id, s.name
FROM STUDENT s
JOIN EXAM e ON e.stu_id = s.stu_id
WHERE e.mark >= ANY (
  SELECT e1.mark
  FROM EXAM e1
  WHERE e1.stu_id = 1
);

-- Bài 3
SELECT s.stu_id, s.name
FROM STUDENT s
WHERE NOT EXISTS (
  SELECT 1
  FROM EXAM e
  WHERE e.stu_id = s.stu_id
    AND e.mark <= ALL (
      SELECT e2.mark
      FROM EXAM e2
      WHERE e2.stu_id = 2
    )
)
AND EXISTS (SELECT 1 FROM EXAM e0 WHERE e0.stu_id = s.stu_id);

-- Bài 4
SELECT s.stu_id, s.name, s.class
FROM STUDENT s
WHERE EXISTS (
  SELECT 1
  FROM EXAM e
  JOIN SUBJECT sub ON sub.subject_id = e.subject_id
  WHERE e.stu_id = s.stu_id
    AND sub.subject_name = 'SQL'
);

-- Bài 5
SELECT sub.subject_id, sub.subject_name, AVG(e.mark) AS avg_mark
FROM SUBJECT sub
JOIN EXAM e ON e.subject_id = sub.subject_id
GROUP BY sub.subject_id, sub.subject_name
HAVING AVG(e.mark) >= 8;

-- bài 6
SELECT s.stu_id, s.name, t.subject_id, sub.subject_name, t.max_mark
FROM STUDENT s
JOIN (
  SELECT stu_id, subject_id, MAX(mark) AS max_mark
  FROM EXAM
  GROUP BY stu_id, subject_id
) t ON t.stu_id = s.stu_id
JOIN SUBJECT sub ON sub.subject_id = t.subject_id
ORDER BY s.stu_id, t.subject_id;

-- Bài 7
WITH best_sql AS (
  SELECT e.stu_id, MAX(e.mark) AS best_mark
  FROM EXAM e
  WHERE e.subject_id = 1
  GROUP BY e.stu_id
)
SELECT
  s.stu_id, s.name, b.best_mark,
  RANK() OVER (ORDER BY b.best_mark DESC) AS rnk
FROM best_sql b
JOIN STUDENT s ON s.stu_id = b.stu_id
ORDER BY rnk, s.stu_id;

-- Bài 8
WITH ranked AS (
  SELECT
    e.*,
    ROW_NUMBER() OVER (
      PARTITION BY e.stu_id, e.subject_id
      ORDER BY e.mark DESC, e.exam_date ASC
    ) AS rn
  FROM EXAM e
)
SELECT
  r.exam_id, r.stu_id, s.name, r.subject_id, sub.subject_name,
  r.mark, r.exam_date
FROM ranked r
JOIN STUDENT s ON s.stu_id = r.stu_id
JOIN SUBJECT sub ON sub.subject_id = r.subject_id
WHERE r.rn = 1
ORDER BY r.stu_id, r.subject_id;

-- Bài 9
WITH avg_all AS (
  SELECT stu_id, AVG(mark) AS avg_mark
  FROM EXAM
  GROUP BY stu_id
),
mx AS (
  SELECT MAX(avg_mark) AS max_avg FROM avg_all
)
SELECT s.stu_id, s.name, a.avg_mark
FROM avg_all a
JOIN mx ON a.avg_mark = mx.max_avg
JOIN STUDENT s ON s.stu_id = a.stu_id;

-- bài 10
WITH best_per_subject AS (
  SELECT stu_id, subject_id, MAX(mark) AS best_mark
  FROM EXAM
  GROUP BY stu_id, subject_id
),
summary AS (
  SELECT
    stu_id,
    SUM(CASE WHEN best_mark >= 8 THEN 1 ELSE 0 END) AS subjects_ge_8,
    MIN(best_mark) AS min_best_mark
  FROM best_per_subject
  GROUP BY stu_id
)
SELECT s.stu_id, s.name, s.class
FROM summary sm
JOIN STUDENT s ON s.stu_id = sm.stu_id
WHERE sm.subjects_ge_8 >= 2
  AND sm.min_best_mark >= 5;




