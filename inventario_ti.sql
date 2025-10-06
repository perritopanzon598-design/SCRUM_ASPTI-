-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 01-10-2025 a las 18:05:20
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `inventario_ti`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `areas`
--

CREATE TABLE `areas` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `estado` enum('Activo','Inactivo') NOT NULL DEFAULT 'Activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `areas`
--

INSERT INTO `areas` (`id`, `nombre`, `estado`) VALUES
(1, 'ADMINISTRACIÓN', 'Activo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `asignaciones`
--

CREATE TABLE `asignaciones` (
  `id` int(11) NOT NULL,
  `id_equipo` int(11) NOT NULL,
  `id_empleado` int(11) NOT NULL,
  `fecha_entrega` datetime NOT NULL,
  `fecha_devolucion` datetime DEFAULT NULL,
  `estado_asignacion` enum('Activa','Finalizada') NOT NULL DEFAULT 'Activa',
  `observaciones_entrega` text DEFAULT NULL,
  `observaciones_devolucion` text DEFAULT NULL,
  `acta_firmada_path` varchar(255) DEFAULT NULL,
  `acta_devolucion_path` varchar(255) DEFAULT NULL,
  `imagen_devolucion_1` varchar(255) DEFAULT NULL,
  `imagen_devolucion_2` varchar(255) DEFAULT NULL,
  `imagen_devolucion_3` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `asignaciones`
--

INSERT INTO `asignaciones` (`id`, `id_equipo`, `id_empleado`, `fecha_entrega`, `fecha_devolucion`, `estado_asignacion`, `observaciones_entrega`, `observaciones_devolucion`, `acta_firmada_path`, `acta_devolucion_path`, `imagen_devolucion_1`, `imagen_devolucion_2`, `imagen_devolucion_3`) VALUES
(1, 1, 1, '2025-08-29 22:35:11', '2025-10-01 07:51:00', 'Finalizada', 'NUEVO EMPLEADO', 'el equipo no enciende', 'acta_1_1759297817.pdf', 'acta_devolucion_1_1759304717.pdf', 'devolucion_1_1759297860.png', 'devolucion_2_1759297860.png', 'devolucion_3_1759297860.png'),
(2, 3, 2, '2025-09-25 01:26:40', '2025-10-01 07:48:50', 'Finalizada', 'EMPLEADO NUEVO, SE PROCEDE A ASIGNAR EL EQUIPO A EMPLEADO', 'el usuario hace entrega del equipo asignado', 'acta_2_1758756606.pdf', 'acta_devolucion_2_1759297759.pdf', 'devolucion_1_1759297730.png', 'devolucion_2_1759297730.png', 'devolucion_3_1759297730.png'),
(3, 2, 2, '2025-10-01 09:00:54', '2025-10-01 09:01:39', 'Finalizada', '', '', 'acta_3_1759302070.pdf', 'acta_devolucion_3_1759303444.pdf', 'devolucion_1_1759302099.png', 'devolucion_2_1759302099.png', 'devolucion_3_1759302099.png');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bajas`
--

CREATE TABLE `bajas` (
  `id` int(11) NOT NULL,
  `id_equipo` int(11) NOT NULL,
  `fecha_baja` date NOT NULL,
  `motivo` enum('Tiempo de uso','Falla tecnica','Perdida') NOT NULL,
  `observaciones` text DEFAULT NULL,
  `acta_baja_path` varchar(255) DEFAULT NULL,
  `descripcion_motivo` text DEFAULT NULL,
  `id_usuario_responsable` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `bajas`
--

INSERT INTO `bajas` (`id`, `id_equipo`, `fecha_baja`, `motivo`, `observaciones`, `acta_baja_path`, `descripcion_motivo`, `id_usuario_responsable`) VALUES
(1, 3, '2025-10-01', '', 'no ubico el equipo', 'acta_baja_3_1759330915.pdf', NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cargos`
--

CREATE TABLE `cargos` (
  `id` int(11) NOT NULL,
  `id_area` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `estado` enum('Activo','Inactivo') NOT NULL DEFAULT 'Activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cargos`
--

INSERT INTO `cargos` (`id`, `id_area`, `nombre`, `estado`) VALUES
(1, 1, 'JEFE ADMINISTRATIVO', 'Activo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empleados`
--

CREATE TABLE `empleados` (
  `id` int(11) NOT NULL,
  `id_sucursal` int(11) NOT NULL,
  `dni` varchar(20) NOT NULL,
  `nombres` varchar(100) NOT NULL,
  `apellidos` varchar(100) NOT NULL,
  `id_cargo` int(11) DEFAULT NULL,
  `id_area` int(11) DEFAULT NULL,
  `estado` enum('Activo','Inactivo') NOT NULL DEFAULT 'Activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `empleados`
--

INSERT INTO `empleados` (`id`, `id_sucursal`, `dni`, `nombres`, `apellidos`, `id_cargo`, `id_area`, `estado`) VALUES
(1, 1, '12121212', 'VICTOR', 'RAMOS', 1, 1, 'Activo'),
(2, 1, '30303040', 'CARLOS', 'RAMIREZ', 1, 1, 'Activo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `equipos`
--

CREATE TABLE `equipos` (
  `id` int(11) NOT NULL,
  `id_sucursal` int(11) NOT NULL,
  `codigo_inventario` varchar(50) NOT NULL,
  `id_tipo_equipo` int(11) NOT NULL,
  `id_marca` int(11) NOT NULL,
  `id_modelo` int(11) NOT NULL,
  `numero_serie` varchar(100) NOT NULL,
  `caracteristicas` text DEFAULT NULL,
  `tipo_adquisicion` enum('Propio','Arrendado','Prestamo') NOT NULL,
  `fecha_adquisicion` date DEFAULT NULL,
  `proveedor` varchar(150) DEFAULT NULL,
  `estado` enum('Disponible','Asignado','En Reparacion','De Baja') NOT NULL DEFAULT 'Disponible',
  `observaciones` text DEFAULT NULL,
  `fecha_registro` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `equipos`
--

INSERT INTO `equipos` (`id`, `id_sucursal`, `codigo_inventario`, `id_tipo_equipo`, `id_marca`, `id_modelo`, `numero_serie`, `caracteristicas`, `tipo_adquisicion`, `fecha_adquisicion`, `proveedor`, `estado`, `observaciones`, `fecha_registro`) VALUES
(1, 1, 'INEVNTARIO2025- 001', 1, 1, 1, 'SERIE-001', 'PROCESADOR: CORE I5, MEMORIA RAM: 8GB, ALMACENAMIENTO: SSD', 'Propio', '2025-08-29', 'PROVEEDOR 1', 'En Reparacion', '', '2025-08-29 20:34:54'),
(2, 1, 'INVENTARIO2025- 002', 1, 1, 1, 'SERIE-002', 'PROCESADOR: CORE I5, MEMORIA RAM 8G, ALMACENAMIENTO SSD', 'Prestamo', '2025-08-29', '', 'Disponible', '', '2025-08-29 20:41:19'),
(3, 1, 'INVENTARIO2025- 003', 1, 2, 2, 'SERIE-003', 'PROCESADOR INTEL CORE I5, MEMORIA RAM 8GB, SSD', 'Propio', '2025-09-24', 'PROVEEDOR 1', 'De Baja', '', '2025-09-24 23:24:37');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `marcas`
--

CREATE TABLE `marcas` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `estado` enum('Activo','Inactivo') NOT NULL DEFAULT 'Activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `marcas`
--

INSERT INTO `marcas` (`id`, `nombre`, `estado`) VALUES
(1, 'LENOVO', 'Activo'),
(2, 'DELL', 'Activo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `modelos`
--

CREATE TABLE `modelos` (
  `id` int(11) NOT NULL,
  `id_marca` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `estado` enum('Activo','Inactivo') NOT NULL DEFAULT 'Activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `modelos`
--

INSERT INTO `modelos` (`id`, `id_marca`, `nombre`, `estado`) VALUES
(1, 1, 'LENOVO A-2025', 'Activo'),
(2, 2, 'DELL-2025', 'Activo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reparaciones`
--

CREATE TABLE `reparaciones` (
  `id` int(11) NOT NULL,
  `id_equipo` int(11) NOT NULL,
  `fecha_ingreso` date NOT NULL,
  `fecha_salida` date DEFAULT NULL,
  `motivo` text NOT NULL,
  `proveedor_servicio` varchar(255) DEFAULT NULL,
  `costo` decimal(10,2) DEFAULT 0.00,
  `observaciones_salida` text DEFAULT NULL,
  `estado_reparacion` enum('En Proceso','Finalizada') NOT NULL DEFAULT 'En Proceso'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `reparaciones`
--

INSERT INTO `reparaciones` (`id`, `id_equipo`, `fecha_ingreso`, `fecha_salida`, `motivo`, `proveedor_servicio`, `costo`, `observaciones_salida`, `estado_reparacion`) VALUES
(1, 3, '2025-10-01', '2025-10-01', 'no enciende', 'PROVEEDOR 1', 100.00, 'solucionado', 'Finalizada');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `nombre_rol` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id`, `nombre_rol`) VALUES
(1, 'Administrador'),
(2, 'Usuario');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sucursales`
--

CREATE TABLE `sucursales` (
  `id` int(11) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `direccion` text DEFAULT NULL,
  `telefono` varchar(50) DEFAULT NULL,
  `estado` enum('Activo','Inactivo') NOT NULL DEFAULT 'Activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `sucursales`
--

INSERT INTO `sucursales` (`id`, `nombre`, `direccion`, `telefono`, `estado`) VALUES
(1, 'SUCURSAL #1', '', NULL, 'Activo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipos_equipo`
--

CREATE TABLE `tipos_equipo` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `estado` enum('Activo','Inactivo') NOT NULL DEFAULT 'Activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tipos_equipo`
--

INSERT INTO `tipos_equipo` (`id`, `nombre`, `estado`) VALUES
(1, 'NOTEBOOK', 'Activo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `id_sucursal` int(11) DEFAULT NULL,
  `nombre` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `id_sucursal`, `nombre`, `email`, `password`, `activo`, `fecha_creacion`) VALUES
(1, NULL, 'Admin', 'admin@correo.com', '$2y$10$67jd7Gb0Tlp/FDj/43CQdOLmEj3eKVnP7uLeJ4X9Zp7y3BnOdywgW', 1, '2025-08-03 06:56:20');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario_roles`
--

CREATE TABLE `usuario_roles` (
  `id_usuario` int(11) NOT NULL,
  `id_rol` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuario_roles`
--

INSERT INTO `usuario_roles` (`id_usuario`, `id_rol`) VALUES
(1, 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `areas`
--
ALTER TABLE `areas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `asignaciones`
--
ALTER TABLE `asignaciones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_equipo_asignado` (`id_equipo`),
  ADD KEY `fk_empleado_asignado` (`id_empleado`);

--
-- Indices de la tabla `bajas`
--
ALTER TABLE `bajas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_equipo_baja` (`id_equipo`);

--
-- Indices de la tabla `cargos`
--
ALTER TABLE `cargos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`),
  ADD KEY `fk_cargo_area` (`id_area`);

--
-- Indices de la tabla `empleados`
--
ALTER TABLE `empleados`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `dni` (`dni`),
  ADD KEY `fk_empleado_cargo` (`id_cargo`),
  ADD KEY `fk_empleado_area` (`id_area`),
  ADD KEY `fk_empleado_sucursal` (`id_sucursal`);

--
-- Indices de la tabla `equipos`
--
ALTER TABLE `equipos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `codigo_inventario` (`codigo_inventario`),
  ADD UNIQUE KEY `numero_serie` (`numero_serie`),
  ADD KEY `fk_equipo_tipo` (`id_tipo_equipo`),
  ADD KEY `fk_equipo_marca` (`id_marca`),
  ADD KEY `fk_equipo_modelo` (`id_modelo`),
  ADD KEY `fk_equipo_sucursal` (`id_sucursal`);

--
-- Indices de la tabla `marcas`
--
ALTER TABLE `marcas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `modelos`
--
ALTER TABLE `modelos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_modelo_marca` (`id_marca`);

--
-- Indices de la tabla `reparaciones`
--
ALTER TABLE `reparaciones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_equipo` (`id_equipo`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre_rol` (`nombre_rol`);

--
-- Indices de la tabla `sucursales`
--
ALTER TABLE `sucursales`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `tipos_equipo`
--
ALTER TABLE `tipos_equipo`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `fk_usuario_sucursal` (`id_sucursal`);

--
-- Indices de la tabla `usuario_roles`
--
ALTER TABLE `usuario_roles`
  ADD PRIMARY KEY (`id_usuario`,`id_rol`),
  ADD KEY `fk_rol` (`id_rol`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `areas`
--
ALTER TABLE `areas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `asignaciones`
--
ALTER TABLE `asignaciones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `bajas`
--
ALTER TABLE `bajas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `cargos`
--
ALTER TABLE `cargos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `empleados`
--
ALTER TABLE `empleados`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `equipos`
--
ALTER TABLE `equipos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `marcas`
--
ALTER TABLE `marcas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `modelos`
--
ALTER TABLE `modelos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `reparaciones`
--
ALTER TABLE `reparaciones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `sucursales`
--
ALTER TABLE `sucursales`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `tipos_equipo`
--
ALTER TABLE `tipos_equipo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `asignaciones`
--
ALTER TABLE `asignaciones`
  ADD CONSTRAINT `fk_empleado_asignado` FOREIGN KEY (`id_empleado`) REFERENCES `empleados` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_equipo_asignado` FOREIGN KEY (`id_equipo`) REFERENCES `equipos` (`id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `bajas`
--
ALTER TABLE `bajas`
  ADD CONSTRAINT `fk_equipo_baja` FOREIGN KEY (`id_equipo`) REFERENCES `equipos` (`id`) ON UPDATE CASCADE;

--
-- Filtros para la tabla `cargos`
--
ALTER TABLE `cargos`
  ADD CONSTRAINT `fk_cargo_area` FOREIGN KEY (`id_area`) REFERENCES `areas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `empleados`
--
ALTER TABLE `empleados`
  ADD CONSTRAINT `fk_empleado_area` FOREIGN KEY (`id_area`) REFERENCES `areas` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_empleado_cargo` FOREIGN KEY (`id_cargo`) REFERENCES `cargos` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_empleado_sucursal` FOREIGN KEY (`id_sucursal`) REFERENCES `sucursales` (`id`);

--
-- Filtros para la tabla `equipos`
--
ALTER TABLE `equipos`
  ADD CONSTRAINT `fk_equipo_marca` FOREIGN KEY (`id_marca`) REFERENCES `marcas` (`id`),
  ADD CONSTRAINT `fk_equipo_modelo` FOREIGN KEY (`id_modelo`) REFERENCES `modelos` (`id`),
  ADD CONSTRAINT `fk_equipo_sucursal` FOREIGN KEY (`id_sucursal`) REFERENCES `sucursales` (`id`),
  ADD CONSTRAINT `fk_equipo_tipo` FOREIGN KEY (`id_tipo_equipo`) REFERENCES `tipos_equipo` (`id`);

--
-- Filtros para la tabla `modelos`
--
ALTER TABLE `modelos`
  ADD CONSTRAINT `fk_modelo_marca` FOREIGN KEY (`id_marca`) REFERENCES `marcas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `reparaciones`
--
ALTER TABLE `reparaciones`
  ADD CONSTRAINT `reparaciones_ibfk_1` FOREIGN KEY (`id_equipo`) REFERENCES `equipos` (`id`);

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `fk_usuario_sucursal` FOREIGN KEY (`id_sucursal`) REFERENCES `sucursales` (`id`);

--
-- Filtros para la tabla `usuario_roles`
--
ALTER TABLE `usuario_roles`
  ADD CONSTRAINT `fk_rol` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
