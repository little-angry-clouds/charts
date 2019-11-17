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

Current chart version is `0.1.4`

Source code can be found [here](https://github.com/little-angry-clouds/charts/tree/master/haproxy-network-ingress)

## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| backend.affinity | object | `{}` | node/pod affinities (requires Kubernetes >=1.6) |
| backend.image.pullPolicy | string | `"IfNotPresent"` | backend's image pull policy |
| backend.image.repository | string | `"haproxy"` | backend's docker image |
| backend.image.tag | string | `"2.0-alpine"` | backend's docker image tag (Warning: Should be based on alpine because of the config reloader) |
| backend.name | string | `"backend"` | backend's name |
| backend.nodeSelector | object | `{}` | node labels for pod assignment |
| backend.replicaCount | int | `1` | backend's desired number of pods |
| backend.resources | object | `{}` | backend's pod resource requests & limits |
| backend.tolerations | list | `[]` | node taints to tolerate (requires Kubernetes >=1.6) |
| controller.affinity | object | `{}` | node/pod affinities (requires Kubernetes >=1.6) |
| controller.image.pullPolicy | string | `"IfNotPresent"` | controller's docker image pull policy |
| controller.image.repository | string | `"littleangryclouds/haproxy-network-ingress"` | controller's docker image |
| controller.image.tag | string | `"0.2.0"` | controller's docker image tag |
| controller.name | string | `"controller"` | controller's name |
| controller.nodeSelector | object | `{}` | node labels for pod assignment |
| controller.replicaCount | int | `1` | controller's desired number of pods |
| controller.resources | object | `{}` | controller pod resource requests & limits |
| controller.tolerations | list | `[]` | node taints to tolerate (requires Kubernetes >=1.6) |
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

These parameters can be passed via Helm's `--set` option

```bash
helm install stable/nginx-ingress --name my-release \
    --set controller.metrics.enabled=true
```

Alternatively, a YAML file that specifies the values for the parameters can be
provided while installing the chart. For example,

```bash
helm install stable/nginx-ingress --name my-release -f values.yaml
```

A useful trick to debug issues with ingress is to increase the logLevel
as described [here](https://github.com/kubernetes/ingress-nginx/blob/master/docs/troubleshooting.md#debug)

```bash
helm install stable/nginx-ingress --set controller.extraArgs.v=2
```
> **Tip**: You can use the default [values.yaml](values.yaml)
