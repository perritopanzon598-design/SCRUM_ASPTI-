<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar Sesión - Sistema de Inventario TI</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="css/login-style.css">
</head>
<body>
    
    <?php
    $error_message = '';
    if (isset($_GET['error'])) {
        if ($_GET['error'] == 'credenciales_invalidas') {
            $error_message = 'El correo o la contraseña son incorrectos.';
        } elseif ($_GET['error'] == 'campos_vacios') {
            $error_message = 'Por favor, completa todos los campos.';
        }
    }
    ?>

    <div class="login-container">
        <div class="welcome-section">
            <div class="logo">
                <img src="img/logo.png" alt="Logo del Sistema">
            </div>
            <h1>¡Bienvenido de Nuevo!</h1>
            <p>Inicia sesión para acceder al panel de control de inventario de TI.</p>
        </div>

        <div class="form-section">
            <div class="form-box">
                
                <?php if (!empty($error_message)): ?>
                    <div class="error-alert"><?php echo $error_message; ?></div>
                <?php endif; ?>

                <h2>Iniciar Sesión</h2>
                <form action="auth.php" method="POST">
                    <div class="input-group">
                        <label for="email">Correo Electrónico</label>
                        <input type="email" id="email" name="email" placeholder="nombre@mail.com" required>
                    </div>
                    <div class="input-group">
                        <label for="password">Contraseña</label>
                        <input type="password" id="password" name="password" placeholder="••••••••" required>
                    </div>
                    
                    <button type="submit" class="btn-login">Ingresar</button>
                </form>
            </div>
        </div>
    </div>

</body>
</html>