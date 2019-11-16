haproxy-network-ingress
=======================

![Haproxy Network Ingress](https://github.com/little-angry-clouds/haproxy-network-ingress) is a Network
Ingress Controller that uses ConfigMap to store the haproxy configuration.

To use it, add the `kubernetes.io/networkingress.class: haproxy` annotation to
your Network Ingress resources.

## TL;DR;

```bash
helm repo add little-angry-clouds https://little-angry-clouds.github.io/
helm upgrade --install exposer little-angry-clouds/haproxy-network-ingress
```

## Introduction
This chart bootstraps an haproxy network ingress deployment on a Kubernetes
cluster using the Helm package manager.

Current chart version is `0.1.2`

Source code can be found [here](https://github.com/little-angry-clouds/charts/tree/master/haproxy-network-ingress)

## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| controller.affinity | object | `{}` | node/pod affinities (requires Kubernetes >=1.6) |
| controller.image.pullPolicy | string | `"IfNotPresent"` | controller's docker image pull policy |
| controller.image.repository | string | `"littleangryclouds/haproxy-network-ingress"` | controller's docker image |
| controller.image.tag | string | `"0.1.5"` | controller's docker image tag |
| controller.name | string | `"controller"` | controller's name |
| controller.nodeSelector | object | `{}` | node labels for pod assignment |
| controller.replicaCount | int | `1` | controller's desired number of pods |
| controller.resources | object | `{}` | controller pod resource requests & limits |
| controller.tolerations | list | `[]` | node taints to tolerate (requires Kubernetes >=1.6) |
| defaultBackend.affinity | object | `{}` | node/pod affinities (requires Kubernetes >=1.6) |
| defaultBackend.image.pullPolicy | string | `"IfNotPresent"` | backend's image pull policy |
| defaultBackend.image.repository | string | `"haproxy"` | backend's docker image |
| defaultBackend.image.tag | string | `"2.0-alpine"` | backend's docker image tag (Warning: Should be based on alpine because of the config reloader) |
| defaultBackend.name | string | `"default-backend"` | backend's name |
| defaultBackend.nodeSelector | object | `{}` | node labels for pod assignment |
| defaultBackend.replicaCount | int | `1` | backend's desired number of pods |
| defaultBackend.resources | object | `{}` | backend's pod resource requests & limits |
| defaultBackend.tolerations | list | `[]` | node taints to tolerate (requires Kubernetes >=1.6) |
| fullnameOverride | string | `""` |  |
| nameOverride | string | `""` |  |
| rbac.create | bool | `true` | if true, create & use RBAC resources |


## Prerequisites

`Kubernetes 1.6+`

## Installing the Chart

To install the chart with the release name `exposer`:

```console
$ helm install --name exposer littleangryclouds/haproxy-network-ingress
```

The command deploys haproxy-network-ingress on the Kubernetes cluster in the default
configuration. The [configuration](#charts-values) section lists the parameters
that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `exposer` deployment:

```bash
helm delete exposer
```

The command removes all the Kubernetes components associated with the chart and
deletes the release.
