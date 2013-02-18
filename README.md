This is simple scripts for multi-site management.


## CREATING SITE TOOL 

### Usage
  ./addsite.sh example.com


### Features:
- creating unix group and user for website without password
- creating mysql user with random password
- creating mysql database named same as mysql user
- adding virtual host for apache2 assigned to created user and group
- adding virtual host for nginx
- easy editing virtual host templates for apache and nginx


### Required packages
- apache2
- apache2-mpm-itk
- nginx
- mysql
- mysql-client


## BACKUP TOOL == 

### Installation
1. Run cron edit:

sudo crontab -e

2. add

0 3 * * * /root/simple-administration-scripts/run_backup.sh



### Features
- create backup of all directories in /home/, packing each in a separate archive
- create backup mySQL database, each placed in a separate gzip archive
- on Monday make backup of the all files, at another days making backup of only changed files
- backup databases happens everyday and include all data
- all backups are coping nicely to the directories
- after the all operations, the backup directory to be synchronized with another host with rsync

### Required packages
- mysqldump
- rsync


