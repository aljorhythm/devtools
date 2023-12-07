log all

`for i in $(docker ps --format '{{.Names}}'); do echo $i >> temp; docker logs $i --tail 20 >> temp; done;`

restart all containers 
`docker restart $(docker ps -q)`


docker rm -f $(docker ps -a -q --filter ancestor=confluentinc/cp-kafka:7.2.2)

sudo ln -sf $HOME/.colima/default/docker.sock /var/run/docker.sock
export DOCKER_HOST=unix:///Users/<name>/.colima/local/docker.sock