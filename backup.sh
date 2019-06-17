#/!bin/bash
set -e

TODAY=$(date +'%Y-%m-%d')
DAYS=1
DAYS_AGO_DATE="$(date "+%Y-%m-%d" -d "$DAYS days ago")"

source .credential;

ip=
db=
type=
backup_file_name=
backup_removing_file_name=

function backup_name {
	backup_file_name="$db-$TODAY"
	backup_removing_file_name="$db-$DAYS_AGO_DATE"
}


function create_backup_dir_if_not_exsists {
	mkdir -p /backup/$type/$db/
}

function pg_backup {
	pg_dump --format=c  -U backup  -h $ip $db > /backup/$type/$db/$backup_file_name.sql.in_progress
	mv /backup/$type/$db/$backup_file_name.sql.in_progress /backup/$type/$db/$backup_file_name.sql
}

function mongo_backup {
	mongodump --host $ip --username $MONGO_USER --password $MONGO_PASSWORD --gzip --archive=/backup/$type/$db/$backup_file_name.gz.in_progress
	mv /backup/$type/$db/$backup_file_name.gz.in_progress /backup/$type/$db/$backup_file_name.gz
}


function mysql_backup {

        mysqldump --host $ip --all-databases> /backup/$type/$db/$backup_file_name.sql.in_progress
         mv /backup/$type/$db/$backup_file_name.sql.in_progress /backup/$type/$db/$backup_file_name.sql
}

function remove_daily_backups {
	rm -f /backup/$type/$db/$backup_removing_file_name*
}


print_usage() {
  printf "Usage: bash backup.sh [-m mongo| -p postgres -M mysql] [-h host] [-d db]"
}

while getopts 'h:d:mpM' flag; do
  case "${flag}" in
    d)
     db="${OPTARG}"
     backup_name ;;
    h) ip="${OPTARG}" ;;
    m) type='mongo' ;;
    p) type='postgres' ;;
    M) type='mysql' ;;
    *) print_usage
       exit 1 ;;
  esac
done
shift $((OPTIND-1))

# echo "$ip $db $type $backup_file_name $yesterday"

create_backup_dir_if_not_exsists

if [[ $type = "postgres" ]]; then
  pg_backup
elif [[ $type = "mongo" ]]; then
  mongo_backup
elif [[ $type = "mysql" ]]; then
  mysql_backup
fi

remove_daily_backups