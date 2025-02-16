
# ArgoCD Automation Script

This script automates the installation and management of ArgoCD on a Kubernetes cluster using Helm and the ArgoCD CLI. It includes commands to create Helm templates, manage ArgoCD applications, and handle port forwarding and logins.

As of 2025-02-16, this only works with the `redis` chart, which is a simple Redis Stateful set.

## Prerequisites

Before running this script, ensure that the following tools are installed and configured:

- **Docker:** To manage containerized applications.  
  [Get Docker](https://docs.docker.com/get-docker/)

- **Minikube:** To create a local Kubernetes cluster.  
  [Install Minikube](https://minikube.sigs.k8s.io/docs/start/)

- **kubectl:** To interact with the Kubernetes cluster.  
  [Install kubectl](https://kubernetes.io/docs/tasks/tools/)

- **Helm:** Render Helm Templates
  [Install Helm](https://helm.sh/docs/intro/install/)

- **ArgoCD:** To manage ArgoCD applications from the command line.
  [Install ArgoCD CLI](https://argo-cd.readthedocs.io/en/stable/cli_installation/)

### Verify Installations:
```bash
docker --version
minikube version
kubectl version --client
helm version
argocd version
```

---

## Usage

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/argocd-automation.git
   cd argocd-automation
   ```

2. **Make the script executable:**
   ```bash
   chmod +x argo.bash
   ```

3. **Start Minikube:**
   ```bash
   minikube start
   ```

---

## Commands

### 1. Install ArgoCD
Installs ArgoCD using Helm with a LoadBalancer service type.
```bash
./argo.bash install
```

### 2. Port-forward ArgoCD Server
Exposes ArgoCD on `localhost:8080`. 
```bash
./argo.bash port-forward
```

### 3. Get ArgoCD Initial Admin Password
Displays the initial admin password for ArgoCD.
```bash
./argo.bash password
```

### 4. Login to ArgoCD
Logs in to ArgoCD `cli` using the initial admin password.
```bash
./argo.bash login
```

### 5. Create Helm Template
Generates Helm templates for an application.
```bash
    # input redis and redis
    read namespace
    read app

    helm template "${namespace}-argocdapp" ./charts/"${app}" \
        --namespace "$namespace" \
        --output-dir argocd-apps

git add .; git commit -m "Testing"; git push
```

### 6. Create ArgoCD Application
Creates and syncs an ArgoCD application from the Helm template.
```bash
./argo.bash app-create redis
```

---

---

## Additions and TODOs

- Helm Controller (Helm Operator)
- Argo Auth

---

## License
This script is open-source and available under the [MIT License](LICENSE).
