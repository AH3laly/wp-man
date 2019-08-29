# WP-MAN

## What is WP-MAN?
**WP-MAN** is a Simple CLI tool to manage and simplify WordPress Tasks.

## Requirements

  - Linux OS.
  - MySQL Client.
  - MySqldump.
  - Wordpress Installation.

## How to install?
Place file 'wpman.sh' inside WordPress root directory (The same directory containing 'wp-config.php' file).

**`WP-MAN parse the wp-config.php to get Database information, So make sure the information is correct in the wp-config.php`**

## Available commands?

### Show Help:
Display list of available parameters.
```bash
./wpman.sh
```

### Export Database:
Export WordPress Database.
```bash
./wpman.sh db-export db_backup.sql
```

### Import Database:
Import WordPress Database.
```bash
./wpman.sh db-import db_backup.sql
```

### Set Home URLs:
Set 'siteurl' and 'home' in wp_options database table.
```bash
./wpman.sh set-urls http://example.com
```

### Display Home URLs:
Display 'siteurl' and 'home' from wp_options database table.
```bash
./wpman.sh get-urls
```

### Display Users List:
Display a list of users in wp_users database table.
```bash
./wpman.sh get-users
```

### Disable User:
Disable WordPress user.
```bash
./wpman.sh disable-user admin
```

### Enable User:
Enable WordPress user.
```bash
./wpman.sh enable-user admin
```

### Reset User Password:
Reset WordPress user Password.
```bash
./wpman.sh reset-password admin my_new_very_complex_password
```

