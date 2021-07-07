load "../../bats/lib/detik"
load "../../bats/lib/linter"
load "../../bats/lib/bats-support/load"
load "../../bats/lib/bats-assert/load"

DETIK_CLIENT_NAME="kubectl"

@test "lint assertions" {
    run lint "particle/default/test.bats"
    # echo -e "$output" > /tmp/errors.txt
    assert_success
}

@test "verify the chart resources" {
    run verify "there are 1 pods named 'alertmanager-actions'"
    assert_success

    run verify "there is 1 service named 'alertmanager-actions'"
    assert_success

    run verify "there is 1 configmap named 'alertmanager-actions-pre-install'"
    assert_success
}

@test "verify the deployment mounts" {
    run verify "'.spec.template.spec.containers[0].volumeMounts[0].name' is 'entrypoint' for deployment named 'alertmanager-actions'"
    assert_success

    run verify "'.spec.template.spec.containers[0].volumeMounts[1].name' is 'config' for deployment named 'alertmanager-actions'"
    assert_success

    run verify "'.spec.template.spec.volumes[0].name' is 'config' for deployment named 'alertmanager-actions'"
    assert_success

    run verify "'.spec.template.spec.volumes[1].name' is 'entrypoint' for deployment named 'alertmanager-actions'"
    assert_success
}

@test "verify that the pre-install works" {
    run $DETIK_CLIENT_NAME exec -ti -c alertmanager-actions $($DETIK_CLIENT_NAME get pod --no-headers=true | cut -d " " -f1) -- bash -c "command -v ssh"
    assert_success
}

@test "verify that the alertmanager-actions reacts to an incoming request" {
    # Install ingress to test via http
    VERSION=$(curl https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/stable.txt)
    $DETIK_CLIENT_NAME apply -f "https://raw.githubusercontent.com/kubernetes/ingress-nginx/${VERSION}/deploy/static/provider/kind/deploy.yaml"
    $DETIK_CLIENT_NAME wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=90s

    # Test a correct request
    run curl -XPOST --silent --data @particle/default/receiver-good.json -H "Content-Type: application/json" localhost:8080/
    assert_success
    assert_output --partial "OK"
    run $DETIK_CLIENT_NAME logs deploy/alertmanager-actions alertmanager-actions
    assert_success
    assert_output --partial "Command output: /bin/ls"

    # Test a correct request
    run curl -XPOST --silent --data @particle/default/receiver-bad.json -H "Content-Type: application/json" localhost:8080/
    assert_success
    assert_output --partial "KO"
    run $DETIK_CLIENT_NAME logs deploy/alertmanager-actions alertmanager-actions
    assert_success
    assert_output --partial "Invalid request"

    $DETIK_CLIENT_NAME delete -f "https://raw.githubusercontent.com/kubernetes/ingress-nginx/${VERSION}/deploy/static/provider/kind/deploy.yaml"
}
