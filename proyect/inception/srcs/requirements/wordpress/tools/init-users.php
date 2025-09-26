<?php
require_once('/var/www/html/wp-load.php');

function create_user_if_not_exists($username, $email, $password, $role) {
    if (!username_exists($username) && !email_exists($email)) {
        $user_id = wp_create_user($username, $password, $email);
        if (!is_wp_error($user_id)) {
            $user = new WP_User($user_id);
            $user->set_role($role);
            error_log("✅ Usuario '$username' creado con rol '$role'");
        } else {
            error_log("⚠️ Error al crear usuario '$username': " . $user_id->get_error_message());
        }
    } else {
        error_log("ℹ️ Usuario '$username' ya existe");
    }
}

// Leer secretos
$admin_user = trim(file_get_contents('/run/secrets/wp_manager_user'));
$admin_pass = trim(file_get_contents('/run/secrets/wp_manager_password'));
$admin_email = getenv('WP_ADMIN_EMAIL');

$editor_user = trim(file_get_contents('/run/secrets/wp_editor_user'));
$editor_pass = trim(file_get_contents('/run/secrets/wp_editor_password'));
$editor_email = getenv('WP_REGULAR_EMAIL');

// Crear usuarios
create_user_if_not_exists($admin_user, $admin_email, $admin_pass, 'administrator');
create_user_if_not_exists($editor_user, $editor_email, $editor_pass, 'editor');
?>
