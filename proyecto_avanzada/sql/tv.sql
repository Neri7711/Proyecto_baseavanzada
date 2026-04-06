-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Servidor: db:3306
-- Tiempo de generación: 06-03-2026 a las 19:54:25
-- Versión del servidor: 8.0.45
-- Versión de PHP: 8.2.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `escuela`
--

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_alumnos_carrera`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_alumnos_carrera` (
`id_alumno` int
,`alumno` varchar(201)
,`correo` varchar(120)
,`telefono` varchar(30)
,`estatus_alumno` enum('Activo','Baja','Egresado')
,`carrera` varchar(100)
,`facultad` varchar(100)
,`facultad_clave` varchar(20)
,`fecha_inscripcion_carrera` date
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_alumnos_por_estatus`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_alumnos_por_estatus` (
`estatus` enum('Activo','Baja','Egresado')
,`total` bigint
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_boleta_alumno`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_boleta_alumno` (
`id_alumno` int
,`alumno` varchar(201)
,`carrera` varchar(100)
,`facultad` varchar(100)
,`periodo` varchar(20)
,`materia_clave` varchar(20)
,`materia_nombre` varchar(120)
,`creditos` int
,`evaluacion` varchar(50)
,`orden` tinyint
,`porcentaje` decimal(5,2)
,`calificacion` decimal(5,2)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_calificaciones_detalle`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_calificaciones_detalle` (
`id_alumno` int
,`alumno` varchar(201)
,`periodo` varchar(20)
,`materia_clave` varchar(20)
,`materia_nombre` varchar(120)
,`evaluacion_nombre` varchar(50)
,`evaluacion_orden` tinyint
,`evaluacion_porcentaje` decimal(5,2)
,`calificacion` decimal(5,2)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_calificaciones_por_materia`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_calificaciones_por_materia` (
`id_alumno` int
,`alumno` varchar(201)
,`periodo` varchar(20)
,`materia_clave` varchar(20)
,`materia_nombre` varchar(120)
,`evaluacion` varchar(50)
,`orden` tinyint
,`porcentaje` decimal(5,2)
,`calificacion` decimal(5,2)
,`ponderado` decimal(10,2)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_cursos_detalle`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_cursos_detalle` (
`id_curso` int
,`materia_clave` varchar(20)
,`materia_nombre` varchar(120)
,`creditos` int
,`num_empleado` varchar(20)
,`docente` varchar(201)
,`periodo` varchar(20)
,`cupo_max` int
,`esta_lleno` varchar(2)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_distribucion_ingresos_concepto`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_distribucion_ingresos_concepto` (
`concepto` varchar(100)
,`monto_total` decimal(32,2)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_docentes_cursos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_docentes_cursos` (
`id_docente` int
,`num_empleado` varchar(20)
,`docente` varchar(201)
,`correo` varchar(120)
,`total_cursos` bigint
,`periodos` text
,`materias` text
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_estado_cuenta`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_estado_cuenta` (
`id_alumno` int
,`alumno` varchar(201)
,`periodo` varchar(20)
,`pagos_realizados` bigint
,`total_pagado` decimal(32,2)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_facultades_carreras`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_facultades_carreras` (
`id_facultad` int
,`facultad_clave` varchar(20)
,`facultad_nombre` varchar(100)
,`id_carrera` int
,`carrera_nombre` varchar(100)
,`num_materias` bigint
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_grupos_detalle`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_grupos_detalle` (
`id_grupo` int
,`materia_clave` varchar(20)
,`materia_nombre` varchar(120)
,`num_empleado` varchar(20)
,`docente` varchar(201)
,`periodo` varchar(20)
,`creditos` int
,`cupo_max` int
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_horario_curso`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_horario_curso` (
`id_horario` int
,`id_curso` int
,`materia_clave` varchar(20)
,`materia_nombre` varchar(120)
,`docente` varchar(201)
,`periodo` varchar(20)
,`dia_semana` tinyint
,`dia_nombre` varchar(9)
,`hora_inicio` time
,`hora_fin` time
,`edificio` varchar(20)
,`nombre_aula` varchar(30)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_horario_grupo`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_horario_grupo` (
`id_horario` int
,`id_grupo` int
,`materia_clave` varchar(20)
,`materia_nombre` varchar(120)
,`docente` varchar(201)
,`periodo` varchar(20)
,`dia_semana` tinyint
,`dia_nombre` varchar(9)
,`hora_inicio` time
,`hora_fin` time
,`edificio` varchar(20)
,`nombre_aula` varchar(30)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_ingresos_mensuales`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_ingresos_mensuales` (
`mes` varchar(7)
,`total_ingresos` decimal(32,2)
,`numero_transacciones` bigint
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_kardex`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_kardex` (
`id_alumno` int
,`alumno` varchar(201)
,`periodo` varchar(20)
,`id_curso` int
,`materia_clave` varchar(20)
,`materia_nombre` varchar(120)
,`calificacion_final` decimal(32,2)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_lista_curso`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_lista_curso` (
`id_curso` int
,`materia_clave` varchar(20)
,`materia_nombre` varchar(120)
,`docente` varchar(201)
,`periodo` varchar(20)
,`id_alumno` int
,`alumno` varchar(201)
,`fecha_inscripcion` date
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_lista_grupo`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_lista_grupo` (
`id_grupo` int
,`materia_clave` varchar(20)
,`materia_nombre` varchar(120)
,`docente` varchar(201)
,`periodo` varchar(20)
,`id_alumno` int
,`alumno` varchar(201)
,`fecha_inscripcion` date
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_materias_criticas`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_materias_criticas` (
`materia` varchar(120)
,`clave` varchar(20)
,`promedio` decimal(6,2)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_matricula_por_carrera`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_matricula_por_carrera` (
`carrera` varchar(100)
,`total_alumnos` bigint
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_morosidad_alumnos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_morosidad_alumnos` (
`nombre` varchar(80)
,`apellidos` varchar(120)
,`correo` varchar(120)
,`estatus` enum('Activo','Baja','Egresado')
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_ocupacion_aulas_resumen`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_ocupacion_aulas_resumen` (
`edificio` varchar(20)
,`total_aulas` bigint
,`capacidad_total` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_promedio_por_materia`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_promedio_por_materia` (
`id_alumno` int
,`alumno` varchar(201)
,`periodo` varchar(20)
,`materia_clave` varchar(20)
,`materia_nombre` varchar(120)
,`calificacion_final` decimal(32,2)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_ranking_docentes_promedio`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_ranking_docentes_promedio` (
`nombre` varchar(80)
,`apellidos` varchar(120)
,`num_empleado` varchar(20)
,`promedio_alumnos` decimal(6,2)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_rendimiento_por_carrera`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_rendimiento_por_carrera` (
`carrera` varchar(100)
,`promedio_general` decimal(6,2)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_resumen_pagos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_resumen_pagos` (
`periodo` varchar(20)
,`concepto` varchar(100)
,`cantidad_pagos` bigint
,`total_recaudado` decimal(32,2)
,`promedio_pago` decimal(11,2)
,`pago_minimo` decimal(10,2)
,`pago_maximo` decimal(10,2)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vw_saturacion_cursos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vw_saturacion_cursos` (
`materia` varchar(120)
,`cupo_max` int
,`inscritos` bigint
,`porcentaje_llenado` decimal(26,2)
,`esta_lleno` tinyint(1)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_alumnos_carrera`
--
DROP TABLE IF EXISTS `vw_alumnos_carrera`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_alumnos_carrera`  AS SELECT `a`.`id_alumno` AS `id_alumno`, concat(`a`.`nombre`,' ',`a`.`apellidos`) AS `alumno`, `a`.`correo` AS `correo`, `a`.`telefono` AS `telefono`, `a`.`estatus` AS `estatus_alumno`, `cr`.`nombre` AS `carrera`, `f`.`nombre` AS `facultad`, `f`.`clave` AS `facultad_clave`, `i`.`fecha_inscripcion` AS `fecha_inscripcion_carrera` FROM (((`alumnos` `a` join `inscripciones` `i` on(((`i`.`id_alumno` = `a`.`id_alumno`) and (`i`.`tipo` = 'carrera')))) join `carreras` `cr` on((`cr`.`id_carrera` = `i`.`id_carrera`))) join `facultades` `f` on((`f`.`id_facultad` = `cr`.`id_facultad`))) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_alumnos_por_estatus`
--
DROP TABLE IF EXISTS `vw_alumnos_por_estatus`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_alumnos_por_estatus`  AS SELECT `alumnos`.`estatus` AS `estatus`, count(0) AS `total` FROM `alumnos` GROUP BY `alumnos`.`estatus` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_boleta_alumno`
--
DROP TABLE IF EXISTS `vw_boleta_alumno`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_boleta_alumno`  AS SELECT `a`.`id_alumno` AS `id_alumno`, concat(`a`.`nombre`,' ',`a`.`apellidos`) AS `alumno`, `cr`.`nombre` AS `carrera`, `f`.`nombre` AS `facultad`, `p`.`nombre` AS `periodo`, `m`.`clave` AS `materia_clave`, `m`.`nombre` AS `materia_nombre`, `m`.`creditos` AS `creditos`, `e`.`nombre` AS `evaluacion`, `e`.`orden` AS `orden`, `e`.`porcentaje` AS `porcentaje`, `c`.`calificacion` AS `calificacion` FROM (((((((((`alumnos` `a` left join `inscripciones` `ic` on(((`ic`.`id_alumno` = `a`.`id_alumno`) and (`ic`.`tipo` = 'carrera')))) left join `carreras` `cr` on((`cr`.`id_carrera` = `ic`.`id_carrera`))) left join `facultades` `f` on((`f`.`id_facultad` = `cr`.`id_facultad`))) join `inscripciones` `i` on(((`i`.`id_alumno` = `a`.`id_alumno`) and (`i`.`tipo` = 'curso')))) join `cursos` `cu` on((`cu`.`id_curso` = `i`.`id_curso`))) join `materias` `m` on((`m`.`id_materia` = `cu`.`id_materia`))) join `periodos` `p` on((`p`.`id_periodo` = `cu`.`id_periodo`))) join `calificaciones` `c` on((`c`.`id_inscripcion` = `i`.`id_inscripcion`))) join `evaluaciones` `e` on((`e`.`id_evaluacion` = `c`.`id_evaluacion`))) ORDER BY `a`.`id_alumno` ASC, `p`.`nombre` ASC, `m`.`clave` ASC, `e`.`orden` ASC ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_calificaciones_detalle`
--
DROP TABLE IF EXISTS `vw_calificaciones_detalle`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_calificaciones_detalle`  AS SELECT `a`.`id_alumno` AS `id_alumno`, concat(`a`.`nombre`,' ',`a`.`apellidos`) AS `alumno`, `p`.`nombre` AS `periodo`, `m`.`clave` AS `materia_clave`, `m`.`nombre` AS `materia_nombre`, `e`.`nombre` AS `evaluacion_nombre`, `e`.`orden` AS `evaluacion_orden`, `e`.`porcentaje` AS `evaluacion_porcentaje`, `c`.`calificacion` AS `calificacion` FROM ((((((`calificaciones` `c` join `inscripciones` `i` on((`i`.`id_inscripcion` = `c`.`id_inscripcion`))) join `evaluaciones` `e` on((`e`.`id_evaluacion` = `c`.`id_evaluacion`))) join `alumnos` `a` on((`a`.`id_alumno` = `i`.`id_alumno`))) join `cursos` `cu` on((`cu`.`id_curso` = `i`.`id_curso`))) join `materias` `m` on((`m`.`id_materia` = `cu`.`id_materia`))) join `periodos` `p` on((`p`.`id_periodo` = `cu`.`id_periodo`))) WHERE (`i`.`tipo` = 'curso') ORDER BY `a`.`id_alumno` ASC, `p`.`nombre` ASC, `m`.`clave` ASC, `e`.`orden` ASC ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_calificaciones_por_materia`
--
DROP TABLE IF EXISTS `vw_calificaciones_por_materia`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_calificaciones_por_materia`  AS SELECT `a`.`id_alumno` AS `id_alumno`, concat(`a`.`nombre`,' ',`a`.`apellidos`) AS `alumno`, `p`.`nombre` AS `periodo`, `m`.`clave` AS `materia_clave`, `m`.`nombre` AS `materia_nombre`, `e`.`nombre` AS `evaluacion`, `e`.`orden` AS `orden`, `e`.`porcentaje` AS `porcentaje`, `c`.`calificacion` AS `calificacion`, round((`c`.`calificacion` * (`e`.`porcentaje` / 100.0)),2) AS `ponderado` FROM ((((((`calificaciones` `c` join `inscripciones` `i` on((`i`.`id_inscripcion` = `c`.`id_inscripcion`))) join `evaluaciones` `e` on((`e`.`id_evaluacion` = `c`.`id_evaluacion`))) join `alumnos` `a` on((`a`.`id_alumno` = `i`.`id_alumno`))) join `cursos` `cu` on((`cu`.`id_curso` = `i`.`id_curso`))) join `materias` `m` on((`m`.`id_materia` = `cu`.`id_materia`))) join `periodos` `p` on((`p`.`id_periodo` = `cu`.`id_periodo`))) WHERE (`i`.`tipo` = 'curso') ORDER BY `a`.`id_alumno` ASC, `p`.`nombre` ASC, `m`.`clave` ASC, `e`.`orden` ASC ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_cursos_detalle`
--
DROP TABLE IF EXISTS `vw_cursos_detalle`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_cursos_detalle`  AS SELECT `c`.`id_curso` AS `id_curso`, `m`.`clave` AS `materia_clave`, `m`.`nombre` AS `materia_nombre`, `m`.`creditos` AS `creditos`, `d`.`num_empleado` AS `num_empleado`, concat(`d`.`nombre`,' ',`d`.`apellidos`) AS `docente`, `p`.`nombre` AS `periodo`, `c`.`cupo_max` AS `cupo_max`, if(`c`.`esta_lleno`,'SI','NO') AS `esta_lleno` FROM (((`cursos` `c` join `materias` `m` on((`m`.`id_materia` = `c`.`id_materia`))) join `docentes` `d` on((`d`.`id_docente` = `c`.`id_docente`))) join `periodos` `p` on((`p`.`id_periodo` = `c`.`id_periodo`))) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_distribucion_ingresos_concepto`
--
DROP TABLE IF EXISTS `vw_distribucion_ingresos_concepto`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_distribucion_ingresos_concepto`  AS SELECT `c`.`concepto` AS `concepto`, sum(`p`.`monto`) AS `monto_total` FROM (`pagos` `p` join `cargos` `c` on((`c`.`id_cargo` = `p`.`id_concepto`))) GROUP BY `c`.`concepto` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_docentes_cursos`
--
DROP TABLE IF EXISTS `vw_docentes_cursos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_docentes_cursos`  AS SELECT `d`.`id_docente` AS `id_docente`, `d`.`num_empleado` AS `num_empleado`, concat(`d`.`nombre`,' ',`d`.`apellidos`) AS `docente`, `d`.`correo` AS `correo`, count(`c`.`id_curso`) AS `total_cursos`, group_concat(distinct `p`.`nombre` order by `p`.`nombre` ASC separator ',') AS `periodos`, group_concat(distinct `m`.`nombre` order by `m`.`nombre` ASC separator ',') AS `materias` FROM (((`docentes` `d` left join `cursos` `c` on((`c`.`id_docente` = `d`.`id_docente`))) left join `materias` `m` on((`m`.`id_materia` = `c`.`id_materia`))) left join `periodos` `p` on((`p`.`id_periodo` = `c`.`id_periodo`))) GROUP BY `d`.`id_docente`, `d`.`num_empleado`, `d`.`nombre`, `d`.`apellidos`, `d`.`correo` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_estado_cuenta`
--
DROP TABLE IF EXISTS `vw_estado_cuenta`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_estado_cuenta`  AS SELECT `a`.`id_alumno` AS `id_alumno`, concat(`a`.`nombre`,' ',`a`.`apellidos`) AS `alumno`, `p`.`nombre` AS `periodo`, count(`pg`.`id_pago`) AS `pagos_realizados`, round(ifnull(sum(`pg`.`monto`),0),2) AS `total_pagado` FROM ((`alumnos` `a` join `periodos` `p`) left join `pagos` `pg` on(((`pg`.`id_alumno` = `a`.`id_alumno`) and (`pg`.`id_periodo` = `p`.`id_periodo`)))) GROUP BY `a`.`id_alumno`, `a`.`nombre`, `a`.`apellidos`, `p`.`id_periodo`, `p`.`nombre` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_facultades_carreras`
--
DROP TABLE IF EXISTS `vw_facultades_carreras`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_facultades_carreras`  AS SELECT `f`.`id_facultad` AS `id_facultad`, `f`.`clave` AS `facultad_clave`, `f`.`nombre` AS `facultad_nombre`, `cr`.`id_carrera` AS `id_carrera`, `cr`.`nombre` AS `carrera_nombre`, (select count(0) from `carreras_materias` `cm` where (`cm`.`id_carrera` = `cr`.`id_carrera`)) AS `num_materias` FROM (`facultades` `f` join `carreras` `cr` on((`cr`.`id_facultad` = `f`.`id_facultad`))) ORDER BY `f`.`nombre` ASC, `cr`.`nombre` ASC ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_grupos_detalle`
--
DROP TABLE IF EXISTS `vw_grupos_detalle`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_grupos_detalle`  AS SELECT `c`.`id_curso` AS `id_grupo`, `m`.`clave` AS `materia_clave`, `m`.`nombre` AS `materia_nombre`, `d`.`num_empleado` AS `num_empleado`, concat(`d`.`nombre`,' ',`d`.`apellidos`) AS `docente`, `p`.`nombre` AS `periodo`, `m`.`creditos` AS `creditos`, `c`.`cupo_max` AS `cupo_max` FROM (((`cursos` `c` join `materias` `m` on((`m`.`id_materia` = `c`.`id_materia`))) join `docentes` `d` on((`d`.`id_docente` = `c`.`id_docente`))) join `periodos` `p` on((`p`.`id_periodo` = `c`.`id_periodo`))) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_horario_curso`
--
DROP TABLE IF EXISTS `vw_horario_curso`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_horario_curso`  AS SELECT `h`.`id_horario` AS `id_horario`, `h`.`id_curso` AS `id_curso`, `cd`.`materia_clave` AS `materia_clave`, `cd`.`materia_nombre` AS `materia_nombre`, `cd`.`docente` AS `docente`, `cd`.`periodo` AS `periodo`, `h`.`dia_semana` AS `dia_semana`, (case `h`.`dia_semana` when 1 then 'Lunes' when 2 then 'Martes' when 3 then 'Miercoles' when 4 then 'Jueves' when 5 then 'Viernes' when 6 then 'Sabado' when 7 then 'Domingo' end) AS `dia_nombre`, `h`.`hora_inicio` AS `hora_inicio`, `h`.`hora_fin` AS `hora_fin`, `a`.`edificio` AS `edificio`, `a`.`nombre_aula` AS `nombre_aula` FROM ((`horarios` `h` join `vw_cursos_detalle` `cd` on((`cd`.`id_curso` = `h`.`id_curso`))) join `aulas` `a` on((`a`.`id_aula` = `h`.`id_aula`))) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_horario_grupo`
--
DROP TABLE IF EXISTS `vw_horario_grupo`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_horario_grupo`  AS SELECT `h`.`id_horario` AS `id_horario`, `h`.`id_curso` AS `id_grupo`, `gd`.`materia_clave` AS `materia_clave`, `gd`.`materia_nombre` AS `materia_nombre`, `gd`.`docente` AS `docente`, `gd`.`periodo` AS `periodo`, `h`.`dia_semana` AS `dia_semana`, (case `h`.`dia_semana` when 1 then 'Lunes' when 2 then 'Martes' when 3 then 'Miercoles' when 4 then 'Jueves' when 5 then 'Viernes' when 6 then 'Sabado' when 7 then 'Domingo' end) AS `dia_nombre`, `h`.`hora_inicio` AS `hora_inicio`, `h`.`hora_fin` AS `hora_fin`, `a`.`edificio` AS `edificio`, `a`.`nombre_aula` AS `nombre_aula` FROM ((`horarios` `h` join `vw_grupos_detalle` `gd` on((`gd`.`id_grupo` = `h`.`id_curso`))) join `aulas` `a` on((`a`.`id_aula` = `h`.`id_aula`))) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_ingresos_mensuales`
--
DROP TABLE IF EXISTS `vw_ingresos_mensuales`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_ingresos_mensuales`  AS SELECT date_format(`pagos`.`fecha_pago`,'%Y-%m') AS `mes`, sum(`pagos`.`monto`) AS `total_ingresos`, count(`pagos`.`id_pago`) AS `numero_transacciones` FROM `pagos` GROUP BY `mes` ORDER BY `mes` DESC ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_kardex`
--
DROP TABLE IF EXISTS `vw_kardex`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_kardex`  AS SELECT `a`.`id_alumno` AS `id_alumno`, concat(`a`.`nombre`,' ',`a`.`apellidos`) AS `alumno`, `gd`.`periodo` AS `periodo`, `gd`.`id_grupo` AS `id_curso`, `gd`.`materia_clave` AS `materia_clave`, `gd`.`materia_nombre` AS `materia_nombre`, round(`k`.`final_ponderado`,2) AS `calificacion_final` FROM (((select `i`.`id_inscripcion` AS `id_inscripcion`,`i`.`id_alumno` AS `id_alumno`,`i`.`id_curso` AS `id_curso`,sum((`c`.`calificacion` * (`e`.`porcentaje` / 100.0))) AS `final_ponderado` from ((`inscripciones` `i` join `calificaciones` `c` on((`c`.`id_inscripcion` = `i`.`id_inscripcion`))) join `evaluaciones` `e` on((`e`.`id_evaluacion` = `c`.`id_evaluacion`))) where (`i`.`tipo` = 'curso') group by `i`.`id_inscripcion`,`i`.`id_alumno`,`i`.`id_curso`) `k` join `alumnos` `a` on((`a`.`id_alumno` = `k`.`id_alumno`))) join `vw_grupos_detalle` `gd` on((`gd`.`id_grupo` = `k`.`id_curso`))) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_lista_curso`
--
DROP TABLE IF EXISTS `vw_lista_curso`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_lista_curso`  AS SELECT `i`.`id_curso` AS `id_curso`, `cd`.`materia_clave` AS `materia_clave`, `cd`.`materia_nombre` AS `materia_nombre`, `cd`.`docente` AS `docente`, `cd`.`periodo` AS `periodo`, `a`.`id_alumno` AS `id_alumno`, concat(`a`.`nombre`,' ',`a`.`apellidos`) AS `alumno`, `i`.`fecha_inscripcion` AS `fecha_inscripcion` FROM ((`inscripciones` `i` join `alumnos` `a` on((`a`.`id_alumno` = `i`.`id_alumno`))) join `vw_cursos_detalle` `cd` on((`cd`.`id_curso` = `i`.`id_curso`))) WHERE (`i`.`tipo` = 'curso') ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_lista_grupo`
--
DROP TABLE IF EXISTS `vw_lista_grupo`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_lista_grupo`  AS SELECT `i`.`id_curso` AS `id_grupo`, `gd`.`materia_clave` AS `materia_clave`, `gd`.`materia_nombre` AS `materia_nombre`, `gd`.`docente` AS `docente`, `gd`.`periodo` AS `periodo`, `a`.`id_alumno` AS `id_alumno`, concat(`a`.`nombre`,' ',`a`.`apellidos`) AS `alumno`, `i`.`fecha_inscripcion` AS `fecha_inscripcion` FROM ((`inscripciones` `i` join `alumnos` `a` on((`a`.`id_alumno` = `i`.`id_alumno`))) join `vw_grupos_detalle` `gd` on((`gd`.`id_grupo` = `i`.`id_curso`))) WHERE (`i`.`tipo` = 'curso') ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_materias_criticas`
--
DROP TABLE IF EXISTS `vw_materias_criticas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_materias_criticas`  AS SELECT `m`.`nombre` AS `materia`, `m`.`clave` AS `clave`, round(avg(`ca`.`calificacion`),2) AS `promedio` FROM (((`materias` `m` join `cursos` `cu` on((`m`.`id_materia` = `cu`.`id_materia`))) join `inscripciones` `i` on((`cu`.`id_curso` = `i`.`id_curso`))) join `calificaciones` `ca` on((`i`.`id_inscripcion` = `ca`.`id_inscripcion`))) GROUP BY `m`.`id_materia` HAVING (`promedio` < 70) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_matricula_por_carrera`
--
DROP TABLE IF EXISTS `vw_matricula_por_carrera`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_matricula_por_carrera`  AS SELECT `c`.`nombre` AS `carrera`, count(`i`.`id_alumno`) AS `total_alumnos` FROM (`carreras` `c` left join `inscripciones` `i` on(((`c`.`id_carrera` = `i`.`id_carrera`) and (`i`.`tipo` = 'carrera')))) GROUP BY `c`.`id_carrera` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_morosidad_alumnos`
--
DROP TABLE IF EXISTS `vw_morosidad_alumnos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_morosidad_alumnos`  AS SELECT distinct `a`.`nombre` AS `nombre`, `a`.`apellidos` AS `apellidos`, `a`.`correo` AS `correo`, `a`.`estatus` AS `estatus` FROM (`alumnos` `a` join `cargos` `c` on((`c`.`id_alumno` = `a`.`id_alumno`))) WHERE ((`a`.`estatus` = 'Activo') AND (`c`.`estado` in ('pendiente','parcial'))) ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_ocupacion_aulas_resumen`
--
DROP TABLE IF EXISTS `vw_ocupacion_aulas_resumen`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_ocupacion_aulas_resumen`  AS SELECT `aulas`.`edificio` AS `edificio`, count(`aulas`.`id_aula`) AS `total_aulas`, sum(`aulas`.`capacidad`) AS `capacidad_total` FROM `aulas` GROUP BY `aulas`.`edificio` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_promedio_por_materia`
--
DROP TABLE IF EXISTS `vw_promedio_por_materia`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_promedio_por_materia`  AS SELECT `a`.`id_alumno` AS `id_alumno`, concat(`a`.`nombre`,' ',`a`.`apellidos`) AS `alumno`, `p`.`nombre` AS `periodo`, `m`.`clave` AS `materia_clave`, `m`.`nombre` AS `materia_nombre`, round(sum((`c`.`calificacion` * (`e`.`porcentaje` / 100.0))),2) AS `calificacion_final` FROM ((((((`calificaciones` `c` join `inscripciones` `i` on((`i`.`id_inscripcion` = `c`.`id_inscripcion`))) join `evaluaciones` `e` on((`e`.`id_evaluacion` = `c`.`id_evaluacion`))) join `alumnos` `a` on((`a`.`id_alumno` = `i`.`id_alumno`))) join `cursos` `cu` on((`cu`.`id_curso` = `i`.`id_curso`))) join `materias` `m` on((`m`.`id_materia` = `cu`.`id_materia`))) join `periodos` `p` on((`p`.`id_periodo` = `cu`.`id_periodo`))) WHERE (`i`.`tipo` = 'curso') GROUP BY `a`.`id_alumno`, `a`.`nombre`, `a`.`apellidos`, `p`.`id_periodo`, `p`.`nombre`, `m`.`id_materia`, `m`.`clave`, `m`.`nombre` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_ranking_docentes_promedio`
--
DROP TABLE IF EXISTS `vw_ranking_docentes_promedio`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_ranking_docentes_promedio`  AS SELECT `d`.`nombre` AS `nombre`, `d`.`apellidos` AS `apellidos`, `d`.`num_empleado` AS `num_empleado`, round(avg(`ca`.`calificacion`),2) AS `promedio_alumnos` FROM (((`docentes` `d` join `cursos` `cu` on((`d`.`id_docente` = `cu`.`id_docente`))) join `inscripciones` `i` on((`cu`.`id_curso` = `i`.`id_curso`))) join `calificaciones` `ca` on((`i`.`id_inscripcion` = `ca`.`id_inscripcion`))) GROUP BY `d`.`id_docente` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_rendimiento_por_carrera`
--
DROP TABLE IF EXISTS `vw_rendimiento_por_carrera`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_rendimiento_por_carrera`  AS SELECT `c`.`nombre` AS `carrera`, round(avg(`ca`.`calificacion`),2) AS `promedio_general` FROM ((`carreras` `c` join `inscripciones` `i` on((`c`.`id_carrera` = `i`.`id_carrera`))) join `calificaciones` `ca` on((`i`.`id_inscripcion` = `ca`.`id_inscripcion`))) GROUP BY `c`.`id_carrera` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_resumen_pagos`
--
DROP TABLE IF EXISTS `vw_resumen_pagos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_resumen_pagos`  AS SELECT `p`.`nombre` AS `periodo`, `c`.`concepto` AS `concepto`, count(`pg`.`id_pago`) AS `cantidad_pagos`, round(sum(`pg`.`monto`),2) AS `total_recaudado`, round(avg(`pg`.`monto`),2) AS `promedio_pago`, min(`pg`.`monto`) AS `pago_minimo`, max(`pg`.`monto`) AS `pago_maximo` FROM ((`pagos` `pg` join `periodos` `p` on((`p`.`id_periodo` = `pg`.`id_periodo`))) join `cargos` `c` on((`c`.`id_cargo` = `pg`.`id_concepto`))) GROUP BY `p`.`nombre`, `c`.`concepto` ORDER BY `p`.`nombre` ASC, `c`.`concepto` ASC ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vw_saturacion_cursos`
--
DROP TABLE IF EXISTS `vw_saturacion_cursos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `vw_saturacion_cursos`  AS SELECT `m`.`nombre` AS `materia`, `cu`.`cupo_max` AS `cupo_max`, (select count(0) from `inscripciones` `i` where (`i`.`id_curso` = `cu`.`id_curso`)) AS `inscritos`, round((((select count(0) from `inscripciones` `i` where (`i`.`id_curso` = `cu`.`id_curso`)) / `cu`.`cupo_max`) * 100),2) AS `porcentaje_llenado`, `cu`.`esta_lleno` AS `esta_lleno` FROM (`cursos` `cu` join `materias` `m` on((`cu`.`id_materia` = `m`.`id_materia`))) ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
