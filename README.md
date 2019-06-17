# db-backups


### how to use 
```bash backup.sh [-m | -p | -M ] [-h host] [-d dbname] ```

database types: 
-m : mongo 
-p : postgresql 
-M : mysql

-h : host of db

-d : database name 

### how to run 
1- create backup user for each db and grant select privilage

2- credentials
   - create a .pgpass file in /home/user to store passwrods postgresql backup users
   - create .my.cnf file in /home/user to store mysql credentials
   - create .credential file for mongodb credential

3- make backup.sh runnable 
```
    chmod +x backup.sh
```

4- modify crontab to run script
```
0 3 * * *  /bin/bash -c "/home/backup_user/backup.sh -p -h 172.20.1.12 -d db"
0 4 * * *  /bin/bash -c "/home/backup_user/backup.sh -p -h 172.20.1.3 -d anotherdb"
10 4 * * *  /bin/bash -c "/home/backup_user/backup.sh -p -h 172.20.1.18 -d another_postgres_db"
30 4 * * *  /bin/bash -c "/home/backup_user/backup.sh -p -h 172.20.1.18 -d defaultdb"
0 5 * * *  /bin/bash -c "/home/backup_user/backup.sh -m -h 172.20.1.16 -d mongo_db"
30 3 * * *  /bin/bash -c "/home/backup_user/backup.sh -M -h 172.20.1.53 -d mysql_db"
```

* ensure that os user has permission to write in target folder
* ensure that u have created a backup user for mongo on admin db 



1- .pgpass sample 
```
172.20.1.12:5432:db:user:password
172.20.1.3:5433:anotherdb:user:password
172.20.1.18:5434:another_postgres_db:user:password
```

2- .my.cnf sample 
```
[mysqldump]
host = 172.20.1.53
port = 3306
user = backup
password = yourpassword
```

3- .credintial file sample 
```
MONGO_USER=user
MONGO_PASSWORD=password
```

** of course you need each db client version for backups 

1- mysql: apt install mysql-utilities mysql-client
2- mongodb: apt install mongodb-org-tools
3- postgres
