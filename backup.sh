#/bin/bash
#author: Denis Oleshkevich 


#check config file

if [ ! -f backup.cfg ];
then
    echo "Config file 'backup.cfg' not found, create it from 'backup.cfg.sample'"
    exit
fi


#loading config
source backup.cfg
 
YEAR=`date +%Y`
MONTH=`date +%m`
DAY=`date +%d`
 
DAYN=`date +%u`
WEEK=`date +%W`
 

 
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
 
for site in `ls $SITES_DIR/ -1`
do
    echo $site;
    cd $SITES_DIR"/"$site
 
    if [ $DAYN == "1" ];
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
 
 
for db in `echo "show databases;" | mysql -u$MYSQL_USER -p$MYSQL_PASS`
do
    if [ $db != "Database" -a $db != "information_schema" -a $db != 'mysql' ];
    then
        echo $db
        mysqldump -u$MYSQL_USER -p$MYSQL_PASS $db | gzip --best > $MYSQL_DIR$db".sql.gz"
 
    fi
 
done
 
date

chmod -R 0600 $BACKUP_DIR

echo "start rsync"
 
rsync -avz $BACKUP_DIR $REMOTE_USER@$REMOTE_HOST:$REMOTE_BACKUP_DIR
 
 
date
echo "finish!"
