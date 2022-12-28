#!/bin/bash

#I use this to create a little bash script that will backup the database at regular intervals, and I’ll even chuck in deleting backups older than 15 days and move the dump_file in S3_bucket.
#added lin 2 to test
#added lin 3 to test
#create a few variables to contain the Database_credentials.
#addedd line to test
# Database credentials

USER="DB-USER"
# PASSWORD="PASSWORD"
HOST="DB-host-name"
DB_NAME="Database-name"

#Backup_Directory_Locations

BACKUPROOT="/backup/mysql_dump"
TSTAMP=$(date +"%d-%b-%Y-%H-%M-%S")
S3BUCKET="s3://bucket-name-dump"

#logging
LOG_ROOT="/backup/mysql_dump/logs/dump.log"

#Dump of Mysql Database into S3\
echo "$(tput setaf 2)creating backup of database start at $TSTAMP" >> "$LOG_ROOT"

mysqldump  -h <HOST>  -u <USER>  --database <DB_NAME>  -p"password" > $BACKUPROOT/$DB_NAME-$TSTAMP.sql

or
#mysqldump -h=$HOST -u=$USER --database=$DB_NAME -p=$PASSWORD > $BACKUPROOT/$DB_NAME-$TSTAMP.sql

echo "$(tput setaf 3)Finished backup of database and sending it in S3 Bucket at $TSTAMP" >> "$LOG_ROOT"

#Delete files older than 15 days

find  $BACKUPROOT/*   -mtime +15   -exec rm  {}  \;

s3cmd   put   --recursive   $BACKUPROOT   $S3BUCKET

echo "$(tput setaf 2)Moved the backup file from local to S3 bucket at $TSTAMP" >> "$LOG_ROOT"

echo "$(tput setaf 3)Coll!! Script have been executed successfully at $TSTAMP" >> "$LOG_ROOT"
