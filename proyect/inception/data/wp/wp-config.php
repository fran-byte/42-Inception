<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the web site, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * Localized language
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** Database username */
define( 'DB_USER', 'wp_to_db_user' );

/** Database password */
define( 'DB_PASSWORD', 'wordpresspass' );

/** Database hostname */
define( 'DB_HOST', 'mariadb' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',          '&8Hx@Eo]_r2,&(0IQ`i>v7~*k#34Na[?N<.v1d_ntFJQjndFK.EgV/,hyEXBOnG*' );
define( 'SECURE_AUTH_KEY',   'FqG&Akp<DQ*N0%!5MI%(6>R)PD!=|SW#NCV6NZzbHI[ns^`S75_O0k,];tcv/Mas' );
define( 'LOGGED_IN_KEY',     'Te%EbM4J8?X4I4{9*n}} TC{kArQ[`BI3 Cqh*>g!:XM..acFrO`{&z;r!D3$dfv' );
define( 'NONCE_KEY',         '.fo38`4Yf<a1Lt^-t*(06lv[@E9RCr^94t2+);`edj0@aic/bV.C+[@M.2h[D4UK' );
define( 'AUTH_SALT',         'CfC6DVy ucLlSxY]feh[(P,YjY-8J&:B]%r1yMm4Vf$,S-+)o=kMmb_N+VXis+(w' );
define( 'SECURE_AUTH_SALT',  '~aRI/;W/bN}P4?^;%](gW;}%r79CK,3S7}AyRP#CPAK]/6.ds5z&{I7U[xO@uCEl' );
define( 'LOGGED_IN_SALT',    'C2RJK8C#]~zEW+xm$O7%kg?#/SM1z/;y5KD[tXEH3=Z,@|<T/o4-k@xF6nEr[k*<' );
define( 'NONCE_SALT',        'eTnwPd_xnVo(~Wc S>%MZJdpaP+;<lQNolH;(OKV<68z0T](&1@;^fKJKf#T?|N_' );
define( 'WP_CACHE_KEY_SALT', '[,bd)U`;8H2|jp_B&71eI(ITi#j7(U~O_9[,tsiMNvfF4HXstgzW#2Ck2&m6Lf-)' );


/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';


/* Add any custom values between this line and the "stop editing" line. */



/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
if ( ! defined( 'WP_DEBUG' ) ) {
	define( 'WP_DEBUG', false );
}

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
