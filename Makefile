

all : docker-compose-up 
docker-compose-up : 
	xhost +local:docker
	docker compose ps --services --status running | grep . >/dev/null && docker compose down || docker compose up --build 