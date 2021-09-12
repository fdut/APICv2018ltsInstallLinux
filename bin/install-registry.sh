helm repo add stable https://charts.helm.sh/stable/
helm repo update
helm install registry stable/docker-registry  -f yaml/docker-registry-values.yaml
echo "Waiting for docker registry to start"
bash bin/sleep.sh 60
kubectl get po -A