# Set context
kubectl config set "contexts."`kubectl config current-context`".namespace" apic


# Delete Cassandra pod in error 
echo "-> `date +"%d/%m/%y-%T"`"
POD=`kubectl get po -n apic |grep cc-cassandra-stats | grep Error | awk '{print $1}'`
echo "Restart pod $POD"
kubectl delete po $POD -n apic

POD=`kubectl get po -n apic |grep backup | awk '{print $1}'`
echo "Restart pod $POD"
kubectl delete po $POD -n apic

# Cleanup apic env
export KUBECONFIG=$HOME/.kube/config
apicops services:identify-state
apicops locks:delete-expired
apicops task-queue:fix-stuck-tasks

# Performance improvement
apicops subscriber-queues:clear
apicops snapshots:clean-up