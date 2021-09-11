kubectl delete -f rookOperator.yaml
kubectl delete -f rookCluster.yaml
kubectl delete -f rookStorageClass.yaml

kubectl delete clusterrolebinding rook

sudo rm -rf /var/lib/rook
ssh -t icvkgn01 "sudo rm -rf /var/lib/rook"
ssh -t icvkgn02 "sudo rm -rf /var/lib/rook"
ssh -t icvkgn03 "sudo rm -rf /var/lib/rook"

