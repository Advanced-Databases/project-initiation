# 1. Notas promedio por semestre por curso
SELECT C.name AS course
	, G.semester 
	, avg(H.grade) AS avg_grade
FROM HistoryCourse H
INNER JOIN `Group` G ON H.group_id = G.group_id 
INNER JOIN Course C ON G.course_id = C.course_id 
GROUP BY G.semester, C.name

# 2. Numero de historias academicas archivadas por programa
SELECT p.sia_code
	, p.name
	, COUNT(*) AS archived
FROM AcademicHistory ah 
INNER JOIN Program p on ah.program_id = p.program_id 
WHERE ah.status = 'ARCHIVED'
GROUP BY p.sia_code, p.name


# 3. Asignaturas cursadas por semestre por estudiante
SELECT s.student_id
	, s.name
	, g.semester
	, s.lastname
	, count(hc.history_course_id)
FROM Student s
INNER JOIN AcademicHistory ah on s.student_id = ah.student_id
INNER JOIN HistoryCourse hc on ah.academic_history_id = hc.academic_history_id 
INNER JOIN `Group` g on hc.group_id = g.group_id 
GROUP BY s.student_id, s.name, g.semester


# 4. Estudiantes que han finalizado el programa academico
SELECT s.student_id,
	ah.academic_history_id,
	p.name,
	ah.end_date 
FROM Student s 
INNER JOIN AcademicHistory ah ON s.student_id = ah.student_id 
INNER JOIN Program p ON p.program_id = ah.program_id 
WHERE ah.status = 'COMPLETED'

# 5. Profesores que dictan menos de 3 materias en el semestre 2023-1
SELECT p.professor_id
	, p.name 
	, p.lastname
	, count(DISTINCT g.course_id)
FROM Professor p 
INNER JOIN `Group` g on g.professor_id = p.professor_id
WHERE g.semester = '2023-1'
GROUP BY p.professor_id, p.name, p.lastname
HAVING count(DISTINCT g.course_id) < 3


