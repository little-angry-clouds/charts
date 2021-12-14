# alertmanager-actions

An Alert Manager receiver that executes arbitrary commands when receiving alerts.

## TL;DR;

```bash
helm repo add little-angry-clouds https://little-angry-clouds.github.io/
helm upgrade --install alertmanager-actions little-angry-clouds/alertmanager-actions
```

## Introduction
This chart bootstraps an Alertmanaer Actions deployment on a Kubernetes
cluster using the Helm package manager. It also adds the option to pre-install packages.

- Current chart version is `0.2.3`

- Source code can be found [here](https://github.com/little-angry-clouds/alertmanager-actions)

## Values

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
| image.repository | string | `"littleangryclouds/alertmanager-actions"` | container image pull policy |
| image.tag | string | `"0.3.0"` |  |
| ingress.annotations | object | `{}` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts | list | `[]` | ingress accepted hostnames |
| ingress.tls | list | `[]` | ingress TLS configuration |
| livenessDelay | int | `15` | seconds to wait until beginning liveness probes |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` | node labels for pod assignment |
| preInstall | object | `{"enabled":false}` | commands to execute before launching alertmanager-actions |
| preInstall.enabled | bool | `false` | value to declare if preInstall is activated |
| readinessDelay | int | `15` | seconds to wait until beginning readiness probes |
| replicaCount | int | `1` | desired number of pods |
| resources | object | `{}` | pod resource requests & limits |
| secrets | object | `{"enabled":false}` | list of secrets |
| secrets.enabled | bool | `false` | value to declare if secrets are enabled |
| service.port | int | `80` | port for the alertmaager-actions http service |
| service.type | string | `"ClusterIP"` | type of service to create |
| serviceMonitor | object | `{"enabled":false,"interval":"30s","prometheus":"kube-prometheus"}` | prometehus operator configuration |
| serviceMonitor.enabled | bool | `false` | value to declare if serviceMonitor is enabled |
| serviceMonitor.interval | string | `"30s"` | interval of time between metrics requests |
| serviceMonitor.prometheus | string | `"kube-prometheus"` | prometehus name |
| tolerations | list | `[]` | node taints to tolerate (requires Kubernetes >=1.6) |

## Prerequisites

`Kubernetes 1.6+`

## Installing the Chart

To install the chart with the release name `alertmanager-actions`:

```console
$ helm install --name alertmanager-actions little-angry-clouds/alertmanager-actions
```

## Configuration options

### Pre-install tools
The main objective of Alertmanager Actions is to execute commands. If you need
to execute them within the pod, you'll need to actually have the tools to
launch the actions.

There's two differente approaches to solve this problem. You could make your
own image. Or you could just use the `preInstall` value. This will modify
the deployments entrypoint so the lines that you define will be executed at
boot, before the Alertmanager Actions. For example:

```yaml
config:
  alertmanager_actions: |
    - labels:
        alertname: IpsecStatus
        action: restart
      command: curl https://gnu.org -L
preInstall:
  enabled: true
  value: |
    set -euo pipefail
    apt update && apt install -y curl
```

This will make possible for the action `IpsecStatus` to execute curl, because
it's installed at boot.

Note: alertmanager-actions base image uses debian:stable-slim.

### Add secrets

You may want to clone a git repository that happens to be private, or ssh to a
machine. And you'll surely won't want to have those credentiales harcoded all
over the place. So, there's the possibility to declare secrets that will be
mounted on the deployment at `/secrets/` directory.

Following the example, if you'd like to clone a private git repository first
you'll create the secrets. All secrets must be passed base64 encoded:

```bash
echo -n "user:password" | base64
```

Copy the output and set it to the `secrets` values:

```yaml
...
secrets:
  enabled: true
  values:
  - key: git_credentials
    value: dXNlcjpwYXNzd29yZA==
```

And you could use those credentials like:

```yaml
preInstall:
  enabled: true
  value: |
    git_credentials=$(cat /secrets/git_credentials)
    git clone "https://${git_credentials}@git.example.com/project/deployments"

```

## Uninstalling the Chart

To uninstall/delete the `alertmanager-actions` deployment:

```bash
$ helm delete alertmanager-actions
```
