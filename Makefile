#  ____            _   _           _
# |  _ \    __ _  | | (_)  _ __   | |_    __ _
# | |_) |  / _` | | | | | | '_ \  | __|  / _` |
# |  __/  | (_| | | | | | | | | | | |_  | (_| |
# |_|      \__,_| |_| |_| |_| |_|  \__|  \__,_|
#

.PHONY: all

all: build

palinta-up:
	oc apply -f ${DEVOPS}/devops-palinta/devops/palinta/palinta-user.yaml -n msz-palinta
	oc apply -f ${DEVOPS}/devops-palinta/devops/palinta/palinta-device.yaml -n msz-palinta

palinta-down:
	oc delete -f ${DEVOPS}/devops-palinta/devops/palinta/palinta-user.yaml -n msz-palinta
	oc delete -f ${DEVOPS}/devops-palinta/devops/palinta/palinta-device.yaml -n msz-palinta

up: palinta-up

down: palinta-down

#  __
# |__)     . |  _|
# |__) |_| | | (_|
#

build-demeter:
	cd cmd/demeter;   GOOS=linux   GOARCH=amd64 go build -o ../../build/linux-amd64/demeter; cd ../..
	cd cmd/demeter;   GOOS=darwin  GOARCH=amd64 go build -o ../../build/macos-amd64/demeter; cd ../..

build-data-generator:
	cd cmd/data-generator; GOOS=linux   GOARCH=amd64 go build -o ../../build/linux-amd64/data-generator; cd ../..
	cd cmd/data-generator; GOOS=darwin  GOARCH=amd64 go build -o ../../build/macos-amd64/data-generator; cd ../..

build-device:
	cd cmd/device;   GOOS=linux   GOARCH=amd64 go build -o ../../build/linux-amd64/device; cd ../..
	cd cmd/device;   GOOS=darwin  GOARCH=amd64 go build -o ../../build/macos-amd64/device; cd ../..

build-user:
	cd cmd/user;   GOOS=linux   GOARCH=amd64 go build -o ../../build/linux-amd64/user; cd ../..
	cd cmd/user;   GOOS=darwin  GOARCH=amd64 go build -o ../../build/macos-amd64/user; cd ../..

build: clean build-demeter build-data-generator build-device build-user

clean:
	rm -rf build

test:
	go test ./...

deps:
	go mod download
	go mod verify

#  __
# |__)     . |  _|    _|  _   _ |   _  _
# |__) |_| | | (_|   (_| (_) (_ |( (- |
#

docker-demeter: build-demeter
	docker build --build-arg target=demeter -t demeter -f ./Dockerfile .

docker-generator: build-data-generator
	docker build --build-arg target=data-generator -t data-generator -f ./Dockerfile .

docker-device: build-device
	docker build --build-arg target=device -t device -f ./Dockerfile .

docker-user: build-user
	docker build --build-arg target=user -t user -f ./Dockerfile .

docker-build: docker-demeter docker-generator docker-device docker-user

#  __
# |__)      _ |_
# |    |_| _) | )
#

tag ?= latest
docker-push-device: clean docker-device
	docker tag device mszg/palinta-device:${tag}
	docker push mszg/palinta-device:${tag}

tag ?= latest
docker-push-user: clean docker-user
	docker tag user mszg/palinta-user:${tag}
	docker push mszg/palinta-user:${tag}

tag ?= latest
docker-push: build docker-build
	docker tag demeter mszg/palinta-demeter:${tag}
	docker push mszg/palinta-demeter:${tag}
	docker tag data-generator mszg/palinta-generator:${tag}
	docker push mszg/palinta-generator:${tag}
	docker tag device mszg/palinta-device:${tag}
	docker push mszg/palinta-device:${tag}
	docker push mszg/palinta-generator:${tag}
	docker tag user mszg/palinta-user:${tag}
	docker push mszg/palinta-user:${tag}
