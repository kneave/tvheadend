# tvheadend [![Docker Pulls](https://img.shields.io/docker/pulls/kneave/tvheadend.svg)](https://hub.docker.com/r/kneave/tvheadend/)
A Dockerfile to Build a TVHeadend Container from Source which includes timeshifting!
Based on https://github.com/hobbsAU/docker-tvheadend.git

The docker container can be found at:
https://hub.docker.com/r/kneave/tvheadend/

It is build each time this repo is updated, typically I do so manually by updating the commit hash indicating what version of the source it is built from.
The latest build should map to the following hash in the [tvheadend](https://github.com/tvheadend/tvheadend) repo:
a9dffb7e96d5d0269840e40575e69ec996351ec1

## Installation - including management scripts and src
```sh
	git clone https://github.com/hobbsAU/docker-tvheadend.git
	cd docker-tvheadend
	make run
```

## Installation - standalone Docker image
```sh
docker pull kneave/tvheadend
```

## Usage - using management scripts

### Creating and running the container
```sh
$ make run
```

### Stopping a running container
```sh
$ make stop
```

### Starting a stopped container
```sh
$ make start
```

### Destroying (deleting) a running or stopped container
```sh
$ make clean
```

### Remotely trigger a container rebuild
```sh
$ make build
```

## Usage - standalone Docker image

First let's setup the data container that will map the config directory from the host to the container as well as the recordings directory. This container will provide persistent storage.
```sh
$ docker create \
 --name tvheadend-data \
 -v <hostdir>:/config \
 -v <hostdir>:/recordings \
 -v <hostdir>:/timeshift \
 kneave/tvheadend \
 /bin/true
```  

Example using my host and the /srv/tvheadend location on my host:
```sh
$ sudo docker create --name tvheadend-data -v /home/keegan/.hts/tvheadend:/config -v /media/four/RecordedTV:/recordings -v /media/four/Timeshift:/timeshift kneave/tvheadend
```  

Next we run the tvheadend-service and this will automatically map the volumes within the new container.
```sh
$ docker run -d \
 --restart=always \
 --net="host" \
 --volumes-from tvheadend-data \
 --name tvheadend-service \
 kneave/tvheadend
```  

You should see two new containers in the docker listing:
```sh
$ docker ps -a
```

## Developing
The [source repo](https://github.com/kneave/tvheadend) is linked to dockerhub using autobuild. Any push to this repo will auto-update the docker image on docker hub [here](https://hub.docker.com/r/kneave/tvheadend).