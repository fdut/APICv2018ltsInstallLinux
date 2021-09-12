# APICv2018lts Install

===========================

`APICv2018ltsInstall` provide tools and scripts to install and configure API Connect v2018 on a single kubernetes master node on Ubuntu Linux 18.04.x

# Installing

Download the latest release on the home repository on your operating system where you want install API Connect v2018.

# Requirement

To install all components of API Connect (API Gateway, API Manager, API Portal, API Analytics) you need the following requirement :

- Ubuntu Linux 18.04.x
- 16 vCPU
- 64 Gb of RAM
- 100 Gb of HDD

- sudo user (to install kubernetes + docker)

# Usage

- (optional) Create a sudo user for kubernetes client admin A

```
  sudo useradd -s /bin/bash -m kadmin
  sudo passwd kadmin
  sudo usermod -aG sudo kadmin

```

- log with the new sudoer user

- Clone github repository

```
    git clone https://github.ibm.com/frederic-dutheil/APICv2018ltsInstall.git
```

Create a directory named "sources" and donwload into this directory the kubernetes images from IBM Support

- Donwload kubernetes images from IBM Support [here](https://www.ibm.com/support/fixcentral/swg/identifyFixes?query.parent=ibm~WebSphere&query.product=ibm~WebSphere~IBM%20API%20Connect&query.release=2018.4.1.9&query.platform=Linux) in the directory you define in the **envfile** : `sources`

```
A list o file for 2018.4.1.10 version.

- analytics-images-kubernetes_lts_v2018.4.1.9-ifix1.0.tgz
- apicup-linux_lts_v2018.4.1.10.tgz
- dpm20184110.lts.tar.gz
- idg_dk20184110.lts.nonprod.tar.gz
- management-images-kubernetes_lts_v2018.4.1.10.tgz
- portal-images-kubernetes_lts_v2018.4.1.10.tgz

7 files approximaly 4,2 GB

SFTP download recommended
```

- Copy envfile.template to envfile

  `cp envfile.template envfile`

- Update **envfile** with your own value
- Launch `prepareos.sh` to install all operating system requirement for next step.

- update PATH

`. .profile`

# Commands

<!-- commands -->

## Prepare and Install Kubernetes

- Launch `scripts/install-docker-kube.sh` to install docker and kubernetes (1.18 or 1.19) requirement for next step.

- Launch `scripts/init-k8s.sh` to configure kubernetes and add calico.

* `make master` : checkprereq installk8s initk8s installHelm getk8sstatus

## Prepare for API Connect

- `make prepapic` : ingress storage registry smtp getk8sstatus

## Deploy or Upgrade APIC

- `make deploy` : checkReady installapicup upload buildYaml deployAPIC getk8sstatus

## Configure APIC (Add Gateway, Analytics, Portal services and deploy a API sample)

- `make configureAPIC` : addTopology loadAssets createApp

## Full install and configuration

- `make full` : master prepapic deploy configureAPIC

# A Another option

## Install on a multiple Node

- Review value in **envfile**
- Review value in **Makefile**

If you don't have docker & Kubernetes installed

Install kube and docker stack with the following command.

- Execute `make master` in terminal of master node

- Execute `make node` in terminal of each node

- Review the file **rookCephInstall/rookCluster.yaml** and configure **rook-ceph** with script `run.sh` in rookCephInstall folder

If you want to explore the install step by step, follow these steps:
https://www.ibm.com/support/knowledgecenter/en/SSMNED_2018/com.ibm.apic.install.doc/tapic_install_Kubernetes_overview.html

## Know limitations

- FakeSMTP splash sign is shown permanently, but can be ignored
- The environment is sometimes not coming up after the VM got suspended. If that is the case, restart the VM

## Tips

### Bind Kubernetes inter-communication to an interface

To bind Kubernetes inter-communication to an interface add --node-ip=<ip_address_on_interface> in /var/lib/kubelet/kubeadm-flags.env

Example:
KUBELET_KUBEADM_ARGS=--cgroup-driver=cgroupfs --network-plugin=cni --node-ip=10.127.101.30

And restart kubelet
sudo systemctl restart kubelet

### Add user to manage Kubernetes cluster:

sudo useradd -s /bin/bash -m kadmin
sudo passwd kadmin
sudo usermod -aG sudo kadmin

### Access API Gateway webui from an external IP of the kubernetes cluster

Create a service as this one :

gateway-webui-nodeport.yaml

```
apiVersion: v1
kind: Service
metadata:
  name: webui-node
spec:
  selector:
    app: dynamic-gateway-service
  type: NodePort
  ports:
  - port: 9090
    targetPort: 9090
    nodePort: 31000

```

```
kubectl create -f gateway-webui-nodeport -n apic
```

API Gateway web console is available with IP :  
`https://<external_ip>:31000/dp/index.html`

Example
https://10.127.101.30:31000/dp/index.html

### For Cleanup Environnement

- Purge helm deployment

```
  helm delete --purge `helm ls |grep apic |  awk '{ print $1 }'`
  sleep 60
```

- Delete pv, pvc

```
  kubectl delete pv
  kubectl get pv | grep apic |  awk '{ print $1 }'`

  kubectl delete pvc --all -n apic
```

- Stop Docker

  `sudo systemctl stop docker`

- Remove kubernetes

  `sudo apt-get purge kubelet kubectl kubeadm kubernetes-cni`

- Check docker package installed

  `sudo apt list --installed | grep docker`

- Remove docker

```
sudo apt-get purge docker-ce

sudo rm -rf /opt/cni/bin/
sudo rm -rf /var/kubernetes/*
sudo rm -rf /var/lib/calico
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/kubelet
sudo rm -rf /var/lib/cni
sudo rm -rf /var/lib/etcd
sudo rm -rf /etc/cni
sudo rm -rf /etc/docker
sudo rm -rf /etc/kubernetes
sudo rm -rf /var/etcd
sudo rm -rf /var/log/pods
```

### List content of the registry

`curl -k -s -X GET http://localhost:80/v2/_catalog | jq '.repositories[]' | sort | xargs -I _ curl -s -k -X GET http://localhost:80/v2/_/tags/list`

### Upgrade APIC Kubernetes environnement

- Review value in **envfile**
  Change version of apic and apicup

```
  export apicversion=v2018.4.1.2
  export apicupversion=apicup-linux_lts_v2018.4.1.2
```

`make installapicup`

- Check version of apicup

  `apicup version`

- Add new images in the docker repository

  `make upload`

- Enter in the initial apicup install directory (where apiconnect-up.yml is located)

  `cd myinstall`

- Upgrade Manager

  `apicup subsys install mgmt --no-verify`

- Upgrade Analytics

  `apicup subsys install analytics --no-verify`

- Upgrade Portal

  `apicup subsys install portal --no-verify`

- Upgrade Gateway

  `apicup subsys install gw`

- Check deployment

  `watch -n 10 kubectl get po -n apic`
