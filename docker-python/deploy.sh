# Let’s create our volumes now. We’ll create one for the data and one for configuration of MySQL.
docker volume create mysql
docker volume create mysql_config
docker volume list

#Now we’ll create a network that our application and database will use to talk to each other
docker network create mysqlnet
docker network list

#Now we can run MySQL in a container and attach to the volumes and network we created above
docker run --rm -d -v mysql:/var/lib/mysql \
  -v mysql_config:/etc/mysql -p 3306:3306 \
  --network mysqlnet \
  --name mysqldb \
  -e MYSQL_ROOT_PASSWORD=p@ssw0rd1 \
  mysql

#First, let’s add the mysql-connector-python module to our application using pip.
pip3 install mysql-connector-python
pip3 freeze | grep mysql-connector-python >> requirements.txt

#Now we can build our image.
docker build --tag python-docker-dev .

#Now, let’s add the container to the database network and then run our container
docker run \
  --rm -d \
  --network mysqlnet \
  --name rest-server \
  -p 8000:5000 \
  python-docker-dev

#Let’s test that our application is connected to the database and is able to add a note.
echo "Sleep 5s"
sleep 5

echo "Init and test"
curl http://localhost:8000/initdb
curl http://localhost:8000/widgets

#docker-compose -f docker-compose.dev.yml up --build
