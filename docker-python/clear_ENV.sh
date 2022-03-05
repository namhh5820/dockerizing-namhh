#Stop docker container
docker stop rest-server
docker stop mysqldb


#Remove volume and network
docker volume rm mysql
docker volume rm mysql_config
docker volume list
docker network rm mysqlnet
docker network list

