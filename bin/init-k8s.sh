pwd
. $(pwd)/envfile

echo "kubeadm init --pod-network-cidr $pod_network_cidr --apiserver-advertise-address=$apiserver_advertise_address"

sudo kubeadm init --pod-network-cidr $pod_network_cidr --apiserver-advertise-address=$apiserver_advertise_address | tee kubeinit.log
sudo cp kubeinit.log kubeinit.log.save
# mkdir -p ~/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
export KUBECONFIG=$HOME/.kube/config
#Install the Tigera Calico operator and custom resource definitions.
kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml

# Wait a few time
bash scripts/sleep.sh 60
	
# Only one master/node
kubectl taint nodes --all node-role.kubernetes.io/master-
bash scripts/sleep.sh 80
kubectl get nodes -o wide
echo "----------------------------"
kubectl get po -A