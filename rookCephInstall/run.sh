kubectl apply -f rookOperator.yaml
kubectl create clusterrolebinding rook --clusterrole cluster-admin --serviceaccount=rook-ceph-system:rook-ceph-system
kubectl apply -f rookCluster.yaml
kubectl apply -f rookStorageClass.yaml


kubectl patch storageclass rook-ceph-block -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
