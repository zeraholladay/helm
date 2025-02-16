#!/bin/bash

function argo-install {
    helm repo add argo https://argoproj.github.io/argo-helm
    helm repo update
    helm install argocd argo/argo-cd \
        --namespace argocd \
        --create-namespace \
        --set server.service.type=LoadBalancer
}

function argo-portForward {
    kubectl port-forward svc/argocd-server -n argocd 8080:443
}

function argo-password {
    password=$(kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d)
    echo "$password"
}

function argo-login {
    password=$(argo-password)
    argocd login localhost:8080 --username admin --password "$password"
}

function helm_template {
    namespace=$1
    app=$2

    helm template "${namespace}-argocdapp" ./charts/"${app}" \
        --namespace "$namespace" \
        --output-dir argocd-apps

    echo "Helm template created for namespace: $namespace, app: $app"
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
    argo-install
    ;;
  port-forward)
    argo-portForward
    ;;
  password)
    argo-password
    ;;
  login)
    argo-login
    ;;
  template)
    if [ -z "$2" ] || [ -z "$3" ]; then
      echo "Usage: $0 template <namespace> <app>"
      exit 1
    fi
    helm_template "$2" "$3"
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
