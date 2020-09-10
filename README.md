# Palinta

Playground project for Golang micro services.

It contains simple micro services as examples in Golang.

Note: the listed commands, params are heavily specific. To able to run in your
environment please change the kube configs, docker hub specific parameters to your
configuration.

## Overview

```
.
├── build               // Build folder for the generated binaries
├── cmd                 // Setup module for the microservices
│   ├── data-generator
│   ├── demeter
│   ├── device
│   └── user
├── kube                // Kubernetes microservice configuration
├── doc                 // Documentation
├── pkg                 // Common package for microservices
└── service             // Service package
```

## Build the project

To generate the binaries run the following command:

```sh
make build
```

It is going to generate the macOS and Linux binaries for each microservice.

Makefile contains separate target for each service. A compile command in case of macOS:

```sh
cd cmd/device;   GOOS=linux   GOARCH=amd64 go build -o ../../build/linux-amd64/device; cd ../..
```

## Build the project using docker

In order to build the microservices into docker please run the following command:

```sh
make docker-build
```

It is going to compile each service and build the corresponding docker image for it.

## Upload it to Kubernetes

Kubernetes config files can be found under the `kube` folder. For each deployment
there is a target created in the `Makefile`.

For further information please check the `Makefile`.
