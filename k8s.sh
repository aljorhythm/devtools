alias k='kubectl -n services'

function kDeletePodsByLabel {
    k delete pod $(k get pods -l $1 --no-headers -o custom-columns=NAME:metadata.name)
}

function kDescribePodsByLabel {
    k describe pod $(k get pods -l $1 --no-headers -o custom-columns=NAME:metadata.name)
}

function kFollowLogsPodsByLabel {
    k logs --follow --tail 100 $(k get pods -l $1 --no-headers -o custom-columns=NAME:metadata.name)
}

function kGetPods {
    k get pods -o wide --show-labels
}

function kGetDeploys {
    k get deployments -o wide --show-labels
}

function kDeleteDeploy {
    k delete deployments $1
}

function kGetServices {
    k get services -o wide
}

function kShell {
    k exec -it $(k get pods -l $1 --no-headers -o custom-columns=NAME:metadata.name) -- /bin/sh
}