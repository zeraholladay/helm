
# ArgoCD Automation Script

This script automates the installation and management of ArgoCD on a Kubernetes cluster using Helm and the ArgoCD CLI. It includes commands to create Helm templates, manage ArgoCD applications, and handle port forwarding and logins.

## Prerequisites

Before running this script, ensure that the following tools are installed and configured:

- **Docker:** To manage containerized applications.  
  [Get Docker](https://docs.docker.com/get-docker/)

- **Minikube:** To create a local Kubernetes cluster.  
  [Install Minikube](https://minikube.sigs.k8s.io/docs/start/)

- **kubectl:** To interact with the Kubernetes cluster.  
  [Install kubectl](https://kubernetes.io/docs/tasks/tools/)

- **ArgoCD CLI:** To manage ArgoCD applications from the command line.  
  [Install ArgoCD CLI](https://argo-cd.readthedocs.io/en/stable/cli_installation/)

### Verify Installations:
```bash
docker --version
minikube version
kubectl version --client
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
./argo.bash template <namespace> <app>
```
Example:
```bash
./argo.bash template dev my-app
```

### 6. Create ArgoCD Application
Creates and syncs an ArgoCD application from the Helm template.
```bash
./argo.bash app-create <namespace>
```
Example:
```bash
./argo.bash app-create dev
```

---

## Example Workflow
1. **Install ArgoCD:**  
   ```bash
   ./argo.bash install
   ```
2. **Port-forward to access the dashboard:**  
   ```bash
   ./argo.bash port-forward # & or in another terminal
   ```
3. **Retrieve the initial admin password:**  
   ```bash
   ./argo.bash password
   ```
4. **Log in to ArgoCD:**  
   ```bash
   ./argo.bash login
   ```
5. **Generate Helm templates for an application:**  
   ```bash
   ./argo.bash template dev my-app
   ```
6. **Create and sync the ArgoCD application:**  
   ```bash
   ./argo.bash app-create dev
   ```

---

## Notes
- The script assumes you have a running Kubernetes cluster (e.g., via Minikube).
- Helm will create a namespace called `argocd` if it does not exist.
- Push Helm templates to your repository before running `app-create`.

---

## Troubleshooting

- **If `kubectl` cannot connect to the cluster:**  
  ```bash
  minikube status
  minikube kubectl -- get pods -A
  ```
- **If ArgoCD service is not exposed:**  
  Ensure `port-forward` is running or check ArgoCD service type:
  ```bash
  kubectl get svc -n argocd
  ```

---

## License
This script is open-source and available under the [MIT License](LICENSE).
