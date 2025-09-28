<?php
require_once('/var/www/html/wp-load.php');

function create_user_if_not_exists($username, $email, $password, $role) {
    if (!username_exists($username) && !email_exists($email)) {
        $user_id = wp_create_user($username, $password, $email);
        if (!is_wp_error($user_id)) {
            $user = new WP_User($user_id);
            $user->set_role($role);
            error_log("✅ Usuario '$username' creado con rol '$role'");
            echo "✅ Usuario '$username' creado con rol '$role'\n";
        } else {
            $error_msg = $user_id->get_error_message();
            error_log("❌ Error al crear usuario '$username': $error_msg");
            echo "❌ Error al crear usuario '$username': $error_msg\n";
        }
    } else {
        error_log("ℹ Usuario '$username' ya existe");
        echo "ℹ Usuario '$username' ya existe\n";
    }
}

// Usar variables de entorno (más flexible)
$admin_user = getenv('WORDPRESS_ADMIN_USER') ?: 'wp_manager_user';
$admin_pass = trim(file_get_contents('/run/secrets/wp_manager_password'));
$admin_email = getenv('WORDPRESS_ADMIN_EMAIL') ?: 'manager@42.fr';

$editor_user = getenv('WORDPRESS_REGULAR_USER') ?: 'wp_editor_user';
$editor_pass = trim(file_get_contents('/run/secrets/wp_editor_password'));
$editor_email = getenv('WORDPRESS_REGULAR_EMAIL') ?: 'editor@42.fr';

echo "🎯 Creando usuarios de WordPress...\n";
echo "Admin: $admin_user ($admin_email)\n";
echo "Editor: $editor_user ($editor_email)\n";

// Crear usuarios
create_user_if_not_exists($admin_user, $admin_email, $admin_pass, 'administrator');
create_user_if_not_exists($editor_user, $editor_email, $editor_pass, 'editor');

echo "✅ Script de usuarios completado\n";
?>
