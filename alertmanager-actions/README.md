alertmanager-actions
====================

An Alert Manager receiver that executes arbitrary commands when receiving alerts.

## TL;DR;

```bash
helm repo add little-angry-clouds https://little-angry-clouds.github.io/
helm upgrade --install alertmanager-actions little-angry-clouds/alertmanager-actions
```

## Introduction
This chart bootstraps an Alertmanaer Actions deployment on a Kubernetes
cluster using the Helm package manager. It also adds the option to pre-install packages.

- Current chart version is `0.1.0`

- Source code can be found [here](https://github.com/little-angry-clouds/alertmanager-actions)

## Chart Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | node/pod affinities (requires Kubernetes >=1.6) |
| config | object | `{"alertmanager_actions":"","pyms":{"content":"","overwrite":false}}` | alertmanager-actions configuration |
| config.alertmanager_actions | string | `""` | alertmanager-actions configuration |
| config.pyms.content | string | `""` | the configuration that will overwrite the default one |
| config.pyms.overwrite | bool | `false` | overwrites the default pyms configuration |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"Always"` |  |
| image.pullSecrets | list | `[]` |  |
| image.repository | string | `"little-angry-clouds/alertmanager-actions"` | container image pull policy |
| image.tag | string | `"latest"` |  |
| ingress.annotations | object | `{}` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts | list | `[]` | ingress accepted hostnames |
| ingress.tls | list | `[]` | ingress TLS configuration |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` | node labels for pod assignment |
| preInstall | string | `""` | commands to execute before launching alertmanaer-actions |
| replicaCount | int | `1` | desired number of pods |
| resources | object | `{}` | pod resource requests & limits |
| service.port | int | `80` | port for the alertmaager-actions http service |
| service.type | string | `"ClusterIP"` | type of service to create |
| tolerations | list | `[]` | node taints to tolerate (requires Kubernetes >=1.6) |

## Prerequisites

`Kubernetes 1.6+`

## Installing the Chart

To install the chart with the release name `alertmanager-actions`:

```console
$ helm install --name alertmanager-actions little-angry-clouds/alertmanager-actions
```

## Configuration options

The main objective of Alertmanager Actions is to execute commands. If you need
to execute them within the pod, you'll need to actually have the tools to
launch the actions.

There's two differente approaches to solve this problem. You could make your
own image. Or you could just use the `preInstall` value. This will modify
the deployments entrypoint so the lines that you define will be executed at
boot, before the Alertmanager Actions. For example:

```
config:
  alertmanager_actions: |
    - labels:
        alertname: IpsecStatus
        action: restart
      command: curl https://gnu.org -L
preInstall: |
  set -euo pipefail
  apk add -U curl
```

This will make possible for the action `IpsecStatus` to execute curl, because
it's installed at boot.

## Uninstalling the Chart

To uninstall/delete the `alertmanager-actions` deployment:

```bash
$ helm delete alertmanager-actions
```
