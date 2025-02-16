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
    echo "$password"
}

function argo-login {
    password=$(argo_password)
    argocd login localhost:8080 --username admin --password "$password"
}


function argo_app_create {
    namespace=$1

    argocd app create "${namespace}-argocdapp" \
        --repo https://github.com/zeraholladay/helm.git \
        --path argocd-apps/"${namespace}"/templates \
        --dest-server https://kubernetes.default.svc \
        --dest-namespace "$namespace"

    argocd app sync "${namespace}-argocdapp"
}

# Case statement for command selection
case "$1" in
  install)
    argo_install
    ;;
  port-forward)
    argo_port_forward
    ;;
  password)
    argo_password
    ;;
  login)
    argo-login
    ;;
  app-create)
    if [ -z "$2" ]; then
      echo "Usage: $0 app-create <namespace>"
      exit 1
    fi
    argo_app_create "$2"
    ;;
  *)
    echo "Usage: $0 {install|port-forward|password|login|template|app-create}"
    exit 1
    ;;
esac
