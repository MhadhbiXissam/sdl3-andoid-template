# sdl3-andoid-template


1.  edit `generate_android_project.sh`

2.  run `generate_android_project.sh` 
```bash
bash generate_android_project.sh
```
3.  edit `docker-compose.yml` : 
change 
```yml
services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    image: build-sdl2:andoid
    environment:
      - DISPLAY=${DISPLAY}
      - XAUTHORITY=${XAUTHORITY}
      - GIT_USER=${GIT_USER}
      - GIT_EMAIL=${GIT_EMAIL}
      - GIT_TOKEN=${GIT_TOKEN}
    ports:
      - "7001:7000"  # maps container port 7000 to host port 7000
    volumes:
      - /tmp/.X11-unix:/tmp/.X11-unix
      - ${XAUTHORITY}:${XAUTHORITY}:ro
      - /dev/bus/usb:/dev/bus/usb
      - ./com.gameengine.game:/root/project # <-- ./com.gameengine.game is the package of the project created by bash script 
    stdin_open: true
    tty: true
    devices:
      - "/dev/dri:/dev/dri"

4. run the docker image 
```bash
make docker-compose-up 
```
5. open code-server web url 
then open port on [http://127.0.0.1:8080/proxy/7001/?folder=/root/project](http://127.0.0.1:8080/proxy/7001/?folder=/root/project)

6.  run build the game : 
```bash
./gradlew installDebug
```
