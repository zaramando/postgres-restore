#! /bin/bash

BACKUP_NAME=parking_2022-06-16T22_22_45Z # This variable must exist in the container.
CONTAINER_NAME=postgres13
LOCAL_VOLUME_PATH=/home/pi/pg_db

chmod 777 ${LOCAL_VOLUME_PATH}

docker cp $BACKUP_NAME.sql.gz ${CONTAINER_NAME}:/${BACKUP_NAME}.sql.gz

cat <<'EOF' | docker exec -it --tty=false ${CONTAINER_NAME} /bin/bash -
    if [ -f ${BACKUP_NAME}.sql ]; then
        rm -rf ${BACKUP_NAME}.sql
    fi
EOF
docker exec -it ${CONTAINER_NAME} gzip -d ${BACKUP_NAME}.sql.gz
cat <<'EOF' | docker exec -it --tty=false ${CONTAINER_NAME} /bin/bash -
    psql -U ${POSTGRES_USER} -d ${POSTGRES_DB} < ${BACKUP_NAME}.sql
EOF

exit 0
