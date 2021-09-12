
export PATH=$PATH:$HOME/bin
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-controller ingress-nginx/ingress-nginx --namespace kube-system --values yaml/ingress-config.yaml
bash bin/sleep.sh 20
kubectl --namespace kube-system get services -o wide ingress-controller-ingress-nginx-controller