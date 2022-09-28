log all

`for i in $(docker ps --format '{{.Names}}'); do echo $i >> temp; docker logs $i --tail 20 >> temp; done;`

restart all containers 
`docker restart $(docker ps -q)`