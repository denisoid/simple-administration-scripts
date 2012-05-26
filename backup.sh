#/bin/bash
#author: Denis Oleshkevich 
 
YEAR=`date +%Y`
MONTH=`date +%m`
DAY=`date +%d`
 
DAYN=`date +%u`
WEEK=`date +%W`
 
 
BACKUP_SITES='/backup/sites/'
BACKUP_MYSQL='/backup/mysql/'
 
 
MYSQL_USER='root'
MYSQL_PASS='password'
 
 
BACKUP_SITES_DIR_TMP=$BACKUP_SITES$YEAR"_"$WEEK"/"
 
 
BACKUP_SITES_FULL=$BACKUP_SITES_DIR_TMP"00_full/"
BACKUP_SITES_INC=$BACKUP_SITES_DIR_TMP$MONTH"_"$DAY"/"
 
echo "start backuping..."
 
date
 
echo "start backup sites"
 
if [ $DAYN == "1" ];
then
    test -d "$BACKUP_SITES_FULL" || mkdir -p "$BACKUP_SITES_FULL"
else
    test -d "$BACKUP_SITES_INC" || mkdir -p "$BACKUP_SITES_INC"
fi
 
for site in `ls /home/ -1`
do
    echo $site;
    cd "/home/"$site
 
    if [ $DAYN == "1" ]
    then
        tar -czf $BACKUP_SITES_FULL$site".tgz" .
    else
        find ./ -mtime -1 -type f -print | tar -czf $BACKUP_SITES_INC$site".tgz" -T -
 
    fi
 
 
 
done
 
 
date
 
echo "start mysql databases backup"
 
 
 
MYSQL_DIR=$BACKUP_MYSQL$YEAR"_"$MONTH"/"$YEAR"_"$MONTH"_"$DAY"/";
test -d "$MYSQL_DIR" || mkdir -p "$MYSQL_DIR"
 
echo $MYSQL_DIR
 
 
 
for db in `echo "show databases;" | mysql -u$MYSQL_USER -p$MYSQL_PASS`
do
    if [ $db != "Database" -a $db != "information_schema" -a $db != 'mysql' ];
    then
        echo $db
        mysqldump -u$MYSQL_USER -p$MYSQL_PASS $db | gzip --best > $MYSQL_DIR$db".sql.gz"
 
    fi
 
done
 
date
echo "start rsync"
 
rsync -avz /backup/ sitesbackup@remotehost:~/backup
 
 
date
echo "finish!"
