#!/bin/bash
# number of backups to be saved
KEEP=10
# the path where to place the backup files
BACKUP_PATH="/volume1/Backup/sqlbackup"
# the login/pwd of the db user to use
DBUSER=my_user
DBPWD=my_pwd
# the prefix of the backup folder that will be created for each backup  : [FOLDER_PREFIX]_yyyymmddhhMMss
FOLDER_PREFIX="mysqldump"
DATE=`date +%Y%m%d%H%M%S`
# the path to the mysql bin folder
MYSQL_BIN="/usr/syno/mysql/bin"

mkdir -p ${BACKUP_PATH}
BACKUPS=`find $BACKUP_PATH -type d -name "${FOLDER_PREFIX}*" | wc -l | sed 's/\ //g'`
while [ $BACKUPS -ge $KEEP ]
do
ls -dtr1 ${BACKUP_PATH}/${FOLDER_PREFIX}*/ | head -n 1 | xargs rm -Rf
BACKUPS=`expr $BACKUPS - 1`
done

BACKUP_PATH=${BACKUP_PATH}/${FOLDER_PREFIX}_${DATE}
mkdir ${BACKUP_PATH}

LISTE=`echo "show databases" | ${MYSQL_BIN}/mysql -N -u${DBUSER} -p${DBPWD}`
for BASE in $LISTE ;
do
FILE="mysqldump_${DATE}_${BASE}.gz"
rm -f ${BACKUP_PATH}/.${FILE}_INPROGRESS
${MYSQL_BIN}/mysqldump --single-transaction --opt -u${DBUSER} -p${DBPWD} ${BASE} | gzip -c -9 > ${BACKUP_PATH}/.${FILE}_INPROGRESS
mv -f ${BACKUP_PATH}/.${FILE}_INPROGRESS ${BACKUP_PATH}/${FILE}
done

exit 0