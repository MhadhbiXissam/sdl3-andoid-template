

all : docker-compose-up 
docker-compose-up : 
	xhost +local:docker
	docker compose  up  --build 