# Little Angry Cloud's Helm Repository

This is [Little Angry Clouds's](https://little-angry-clouds.github.io/)
[Helm](https://helm.sh) repository.

To configure this repository, you may execute the next command in your computer:

```bash
helm repo add little-angry-clouds https://little-angry-clouds.github.io/
```

To test that it's configured correctly, search the chart
`haproxy-network-ingress`:

```bash
helm search -r "^haproxy-network-ingress"
```

It should return: `little-angry-clouds/haproxy-network-ingress`.

