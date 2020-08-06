#!/bin/bash
# WordPress Management Tool
# Abdelrahman Helaly github.com/AHelaly

parse-config(){

if [ ! -f "wp-config.php" ]
then
    show-message "wp-config.php File Not Found"
    exit
fi

config_blob=$(grep -i "^define.*);$" wp-config.php | sed -e "s/ //g" | sed -e "s/\",\"/','/g" | sed -e "s/^[\"']//g" -e "s/'*\"*);$//g" | sed -e "s/^define(['\"]//g" | sed -e 's/,"/,'"'"'/g' | sed -e 's/",/'"'"',/g')
for conf in $config_blob
do
    var_name=$(echo $conf | awk -F"','*" '{ print $1 }')
    var_value=$(echo $conf | awk -F"','*" '{ print $2 }')
    read $var_name <<< $(echo $var_value)
done

}

show-message(){
    echo
    echo $1
    echo
}

pub-db-export(){
file_path=$1
if [ -z "$file_path" ]; then show-message "Error: Target filename Required"; exit; fi
mysqldump -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME > $file_path 2> /dev/null && echo Done
}

pub-db-import(){
file_path=$1
if [ -z "$file_path" ]; then show-message "Error: Source filename Required"; exit; fi
mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME < $file_path 2> /dev/null && echo Done
}

pub-set-urls(){
url=$1
mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME -e "UPDATE wp_options set option_value = '$url' WHERE option_name in ('home','siteurl')" 2> /dev/null && echo Done
}

pub-get-urls(){
mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME -e "SELECT * FROM wp_options WHERE option_name in ('home','siteurl')" 2> /dev/null
}

pub-get-users(){
mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME -e "SELECT id, user_login, user_email, user_registered, user_status FROM wp_users" 2> /dev/null
}

pub-reset-password(){
user=$1
password=$2
if [ -z "$user" ]; then show-message "Error: Username required."; exit; fi
if [ -z "$password" ]; then show-message "Error: PAssword required."; exit; fi
mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME -e "UPDATE wp_users SET user_status = md5($password) WHERE user_login = '$user'" 2> /dev/null
}

pub-disable-user(){
user=$1
if [ -z "$user" ]; then show-message "Error: Username required."; exit; fi
mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME -e "UPDATE wp_users SET user_status = 0 WHERE user_login = '$user'" 2> /dev/null
}

pub-enable-user(){
user=$1
if [ -z "$user" ]; then show-message "Error: Username required."; exit; fi
mysql -h $DB_HOST -u $DB_USER -p$DB_PASSWORD $DB_NAME -e "UPDATE wp_users SET user_status = 1 WHERE user_login = '$user'" 2> /dev/null
}

show-help(){
echo 
echo "Available Parameters:"
echo "
db-export [target_file_path.sql]

db-import [source_file_path.sql]

set-urls [url] (set siteurl and home in wp_options)

get-urls (Display siteurl and home in wp_options)

get-users (Display list of users in wp_users)

disable-user [user_name] (Disable user to prevent access)

enable-user [user_name] (Enable user to allow access)

reset-password [user_name] [new_password] (Reset user password)
"


echo
}

################################# Start Up ####################################

parse-config

if [ "$(type -t pub-$1)" != 'function' ]
then
    show-help
    exit;
fi

if [ "$2" == '--help' ]
then
    $1-help
    exit;
fi

pub-$1 $2 $3 $4 $5 $6 $7 $8 $9

