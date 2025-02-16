#!/bin/bash

function argo_install {
    helm repo add argo https://argoproj.github.io/argo-helm
    helm repo update
    helm install argocd argo/argo-cd \
        --namespace argocd \
        --create-namespace \
        --set server.service.type=LoadBalancer
}

function argo_port_forward {
    kubectl port-forward svc/argocd-server -n argocd 8080:443
}

function argo_password {
    password=$(kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d)
    echo $password
}

function argo_login {
    password=$(argo_password)
    argocd login localhost:8080 --username admin --password $password
}

function helm_template {
    namespace=$1
    app=$2

    # --values ./my-app-chart/values.yaml \
    helm template ${namespace}-argocdapp ./charts/${app} \
        --namespace $namespace \
        --output-dir argocd-apps

    # Then push to git before running argo_install
}

function argo_install {
    namespace=$1

    argocd app create ${namespace}-argocdapp \
        --repo https://github.com/zeraholladay/helm.git \
        --path argocd-apps/${namespace} \
        --dest-server https://kubernetes.default.svc \
        --dest-namespace $namespace
}


