<?php
require_once '../templates/header.php';

// --- LÓGICA PARA FILTROS ---
$filtro_codigo = $_GET['codigo_inventario'] ?? '';
$filtro_serie = $_GET['numero_serie'] ?? '';
$filtro_sucursal = $_GET['sucursal'] ?? '';
$filtro_tipo = $_GET['tipo_equipo'] ?? '';
$filtro_marca = $_GET['marca'] ?? '';
$filtro_estado = $_GET['estado'] ?? '';

$sucursales = $conexion->query("SELECT id, nombre FROM sucursales WHERE estado = 'Activo' ORDER BY nombre");
$tipos_equipo = $conexion->query("SELECT id, nombre FROM tipos_equipo ORDER BY nombre");
$marcas = $conexion->query("SELECT id, nombre FROM marcas ORDER BY nombre");

$sql = "SELECT e.*, s.nombre AS sucursal_nombre, t.nombre AS tipo_nombre, ma.nombre as marca_nombre, mo.nombre as modelo_nombre
        FROM equipos e
        LEFT JOIN sucursales s ON e.id_sucursal = s.id
        LEFT JOIN tipos_equipo t ON e.id_tipo_equipo = t.id
        LEFT JOIN marcas ma ON e.id_marca = ma.id
        LEFT JOIN modelos mo ON e.id_modelo = mo.id";

$where_clauses = [];
if (!empty($filtro_codigo)) $where_clauses[] = "e.codigo_inventario LIKE '%" . $conexion->real_escape_string($filtro_codigo) . "%'";
if (!empty($filtro_serie)) $where_clauses[] = "e.numero_serie LIKE '%" . $conexion->real_escape_string($filtro_serie) . "%'";
if (!empty($filtro_sucursal)) $where_clauses[] = "e.id_sucursal = " . (int)$filtro_sucursal;
if (!empty($filtro_tipo)) $where_clauses[] = "e.id_tipo_equipo = " . (int)$filtro_tipo;
if (!empty($filtro_marca)) $where_clauses[] = "e.id_marca = " . (int)$filtro_marca;
if (!empty($filtro_estado)) $where_clauses[] = "e.estado = '" . $conexion->real_escape_string($filtro_estado) . "'";

if (!empty($where_clauses)) {
    $sql .= " WHERE " . implode(" AND ", $where_clauses);
}

$sql .= " ORDER BY e.id DESC";
$resultado = $conexion->query($sql);
?>

<h1 class="h2 mb-4">Gestión de Equipos</h1>

<div class="card mb-4">
    <div class="card-header"><i class="bi bi-funnel-fill me-2"></i> Filtros y Reportes</div>
    <div class="card-body">
        <form action="equipos.php" method="GET" class="mb-4">
            <div class="row g-3">
                <div class="col-md-3"><label class="form-label">Código de Inventario</label><input type="text" class="form-control form-control-sm" name="codigo_inventario" value="<?php echo htmlspecialchars($filtro_codigo); ?>"></div>
                <div class="col-md-3"><label class="form-label">Número de Serie</label><input type="text" class="form-control form-control-sm" name="numero_serie" value="<?php echo htmlspecialchars($filtro_serie); ?>"></div>
                <div class="col-md-3"><label class="form-label">Sucursal</label><select class="form-select form-select-sm" name="sucursal"><option value="">Todas</option><?php mysqli_data_seek($sucursales, 0); while($s = $sucursales->fetch_assoc()) { echo "<option value='{$s['id']}' ".($filtro_sucursal == $s['id'] ? 'selected' : '').">".htmlspecialchars($s['nombre'])."</option>"; } ?></select></div>
                <div class="col-md-3"><label class="form-label">Tipo de Equipo</label><select class="form-select form-select-sm" name="tipo_equipo"><option value="">Todos</option><?php while($t = $tipos_equipo->fetch_assoc()) { echo "<option value='{$t['id']}' ".($filtro_tipo == $t['id'] ? 'selected' : '').">".htmlspecialchars($t['nombre'])."</option>"; } ?></select></div>
                <div class="col-md-3"><label class="form-label">Marca</label><select class="form-select form-select-sm" name="marca"><option value="">Todas</option><?php while($m = $marcas->fetch_assoc()) { echo "<option value='{$m['id']}' ".($filtro_marca == $m['id'] ? 'selected' : '').">".htmlspecialchars($m['nombre'])."</option>"; } ?></select></div>
                <div class="col-md-3"><label class="form-label">Estado</label><select class="form-select form-select-sm" name="estado"><option value="">Todos</option><option value="Disponible" <?php if($filtro_estado == 'Disponible') echo 'selected'; ?>>Disponible</option><option value="Asignado" <?php if($filtro_estado == 'Asignado') echo 'selected'; ?>>Asignado</option><option value="En Reparación" <?php if($filtro_estado == 'En Reparación') echo 'selected'; ?>>En Reparación</option><option value="De Baja" <?php if($filtro_estado == 'De Baja') echo 'selected'; ?>>De Baja</option></select></div>
                <div class="col-md-6 d-flex align-items-end"><button type="submit" class="btn btn-primary btn-sm me-2">Filtrar</button><a href="equipos.php" class="btn btn-secondary btn-sm">Limpiar</a></div>
            </div>
        </form>
        <hr>
        <div class="d-flex gap-2">
            <button class="btn btn-success"><i class="bi bi-file-earmark-excel me-2"></i> Excel</button>
            <button class="btn btn-danger"><i class="bi bi-file-earmark-pdf me-2"></i> PDF</button>
            <button class="btn btn-info"><i class="bi bi-printer me-2"></i> Imprimir</button>
        </div>
    </div>
</div>

<div class="card">
    <div class="card-header d-flex justify-content-between align-items-center">
        <span>Inventario Actual</span>
        <a href="equipo_agregar.php" class="btn btn-primary"><i class="bi bi-plus-circle me-2"></i> Registrar Nuevo Equipo</a>
    </div>
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead class="table-dark">
                    <tr><th>Sucursal</th><th>Código</th><th>Tipo</th><th>Marca / Modelo</th><th>N/S</th><th>Fecha Adquisición</th><th>Estado</th><th>Acciones</th></tr>
                </thead>
                <tbody>
                    <?php if ($resultado && $resultado->num_rows > 0): ?>
                        <?php while ($equipo = $resultado->fetch_assoc()): ?>
                            <tr>
                                <td><?php echo htmlspecialchars($equipo['sucursal_nombre']); ?></td>
                                <td><?php echo htmlspecialchars($equipo['codigo_inventario']); ?></td>
                                <td><?php echo htmlspecialchars($equipo['tipo_nombre']); ?></td>
                                <td><?php echo htmlspecialchars($equipo['marca_nombre'] . ' / ' . $equipo['modelo_nombre']); ?></td>
                                <td><?php echo htmlspecialchars($equipo['numero_serie']); ?></td>
                                <td><?php echo date('d/m/Y', strtotime($equipo['fecha_adquisicion'])); ?></td>
                                <td>
                                    <?php
                                    $estado = htmlspecialchars($equipo['estado']);
                                    $clase_badge = 'bg-secondary';
                                    if ($estado == 'Disponible') $clase_badge = 'bg-success';
                                    if ($estado == 'Asignado') $clase_badge = 'bg-primary';
                                    if ($estado == 'En Reparación') $clase_badge = 'bg-warning text-dark';
                                    if ($estado == 'De Baja') $clase_badge = 'bg-danger';
                                    ?>
                                    <span class="badge <?php echo $clase_badge; ?>"><?php echo $estado; ?></span>
                                </td>
                                <td>
                                    <div class="btn-group" role="group">
                                        <a href="equipo_detalle.php?id=<?php echo $equipo['id']; ?>" class="btn btn-primary btn-sm" title="Ver Detalle"><i class="bi bi-eye-fill"></i></a>
                                        <a href="equipo_editar.php?id=<?php echo $equipo['id']; ?>" class="btn btn-warning btn-sm" title="Editar Equipo"><i class="bi bi-pencil-fill"></i></a>
                                        <?php if ($equipo['estado'] === 'Disponible'): ?>
                                            <a href="equipo_enviar_reparacion.php?id=<?php echo $equipo['id']; ?>" class="btn btn-info btn-sm" title="Enviar a Reparación"><i class="bi bi-wrench"></i></a>
                                        <?php endif; ?>
                                        <?php if ($equipo['estado'] !== 'Asignado' && $equipo['estado'] !== 'De Baja'): ?>
                                             <a href="equipo_dar_de_baja.php?id=<?php echo $equipo['id']; ?>" class="btn btn-danger btn-sm" title="Dar de Baja"><i class="bi bi-trash-fill"></i></a>
                                        <?php endif; ?>
                                    </div>
                                </td>
                            </tr>
                        <?php endwhile; ?>
                    <?php else: ?>
                        <tr><td colspan="8" class="text-center">No se encontraron equipos que coincidan con los filtros.</td></tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>
</div>

<?php require_once '../templates/footer.php'; ?>