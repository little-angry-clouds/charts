#!/usr/bin/env bash

function update_minor() {
    updated_version="$(echo "$1" | awk -F. -v OFS=. 'NF==1{print ++$NF}; NF>1{if(length($NF+1)>length($NF))$(NF-1)++; $NF=sprintf("%0*d", length($NF), ($NF+1)%(10^length($NF))); print}')"
    echo "$updated_version"
}

haproxy_network_ingress="/tmp/hne"

# Idempotent script
if [[ -d $haproxy_network_ingress ]]
then
    rm -rf $haproxy_network_ingress
fi

git clone https://github.com/little-angry-clouds/haproxy-network-ingress $haproxy_network_ingress

cp $haproxy_network_ingress/config/crd/bases/little-angry-clouds.k8s.io_networkingresses.yaml \
    haproxy-network-ingress/templates/crd.yaml

# Update minor version
changed_directories=$(git diff --diff-filter=AM --name-only HEAD~1 HEAD | xargs -n1 dirname | grep -v "/")
for changed_chart in $changed_directories
do
    echo git status --porcelain $changed_chart/Chart.yaml
    check_if_staged_version="$(git status --porcelain $changed_chart/Chart.yaml)"
    if [[ "$check_if_staged_version" -eq "" ]]
    then
        version="$(grep "^version:" $changed_chart/Chart.yaml)"
        updated_version="$(update_minor $(echo "$version" | cut -d" " -f2))"
        sed -i "s/$version/version: $updated_version/" $changed_chart/Chart.yaml
    fi
done
