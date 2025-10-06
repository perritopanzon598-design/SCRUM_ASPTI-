<?php
require_once '../templates/header.php';

// --- Procesar el formulario cuando se envía (POST) ---
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $id_equipo = $_POST['id_equipo'];
    $fecha_baja = $_POST['fecha_baja'];
    $motivo = $_POST['motivo'];
    $observaciones = $_POST['observaciones'];
    $acta_path = null;

    // Lógica para subir el archivo del acta (si se adjunta)
    if (isset($_FILES['acta_baja']) && $_FILES['acta_baja']['error'] === UPLOAD_ERR_OK) {
        $upload_dir = '../uploads/bajas/';
        if (!is_dir($upload_dir)) {
            mkdir($upload_dir, 0777, true); // Crear la carpeta si no existe
        }
        $file_name = "acta_baja_" . $id_equipo . "_" . time() . '.' . pathinfo($_FILES['acta_baja']['name'], PATHINFO_EXTENSION);
        $acta_path = $file_name;
        move_uploaded_file($_FILES['acta_baja']['tmp_name'], $upload_dir . $file_name);
    }

    $conexion->begin_transaction();
    try {
        // 1. Actualizar estado del equipo
        $stmt_eq = $conexion->prepare("UPDATE equipos SET estado = 'De Baja' WHERE id = ?");
        $stmt_eq->bind_param("i", $id_equipo);
        $stmt_eq->execute();

        // 2. Insertar registro en la tabla 'bajas'
        $stmt_baja = $conexion->prepare("INSERT INTO bajas (id_equipo, fecha_baja, motivo, observaciones, acta_baja_path) VALUES (?, ?, ?, ?, ?)");
        $stmt_baja->bind_param("issss", $id_equipo, $fecha_baja, $motivo, $observaciones, $acta_path);
        $stmt_baja->execute();

        $conexion->commit();
        header("Location: equipos.php?status=baja_exitosa");
        exit();
    } catch (mysqli_sql_exception $exception) {
        $conexion->rollback();
        die("Error al dar de baja el equipo: " . $exception->getMessage());
    }
}

// --- Mostrar el formulario (GET) ---
if (!isset($_GET['id']) || !is_numeric($_GET['id'])) die("Error: ID de equipo no válido.");
$id_equipo = (int)$_GET['id'];
$equipo = $conexion->query("SELECT e.*, ma.nombre as marca, mo.nombre as modelo FROM equipos e LEFT JOIN marcas ma ON e.id_marca = ma.id LEFT JOIN modelos mo ON e.id_modelo = mo.id WHERE e.id = $id_equipo")->fetch_assoc();
if (!$equipo) die("Equipo no encontrado.");
?>

<h1 class="h2 mb-4">Dar de Baja Equipo</h1>

<div class="card">
    <div class="card-header">
        Confirmar Baja para el Equipo: <?php echo htmlspecialchars($equipo['codigo_inventario']); ?>
    </div>
    <div class="card-body">
        <div class="alert alert-danger">
            <strong>¡Atención!</strong> Esta acción es irreversible. El estado del equipo cambiará a "De Baja" y no podrá ser asignado ni modificado.
        </div>
        
        <form action="equipo_dar_de_baja.php" method="POST" enctype="multipart/form-data">
            <input type="hidden" name="id_equipo" value="<?php echo $id_equipo; ?>">
            
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="fecha_baja" class="form-label">Fecha de Baja *</label>
                    <input type="date" class="form-control" id="fecha_baja" name="fecha_baja" value="<?php echo date('Y-m-d'); ?>" required>
                </div>
                <div class="col-md-6 mb-3">
                    <label for="motivo" class="form-label">Motivo de la Baja *</label>
                    <select class="form-select" id="motivo" name="motivo" required>
                        <option value="">Seleccione un motivo...</option>
                        <option value="Dañado sin reparación">Dañado sin reparación</option>
                        <option value="Obsoleto">Obsoleto</option>
                        <option value="Perdido / Robado">Perdido / Robado</option>
                        <option value="Otro">Otro</option>
                    </select>
                </div>
            </div>
            
            <div class="mb-3">
                <label for="observaciones" class="form-label">Observaciones</label>
                <textarea class="form-control" id="observaciones" name="observaciones" rows="4"></textarea>
            </div>

            <div class="mb-3">
                <label for="acta_baja" class="form-label">Adjuntar Acta de Baja (Opcional)</label>
                <input class="form-control" type="file" id="acta_baja" name="acta_baja">
            </div>
            
            <hr>
            
            <div class="d-flex justify-content-end gap-2">
                <a href="equipos.php" class="btn btn-secondary">Cancelar</a>
                <button type="submit" class="btn btn-danger">Confirmar Baja del Equipo</button>
            </div>
        </form>
    </div>
</div>

<?php require_once '../templates/footer.php'; ?>