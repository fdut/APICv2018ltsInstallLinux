# kubernetes-rook-ceph

The files in this folder help you to configure rook-Ceph for shared storage used. You can use it for HA deployement of APIC 2018.


- Review the file **rookCephInstall/rookCluster.yaml** 

The files configure 3 workers nodes with device to use for storage

**The device used need to be empty and not formated**

Specificaly this part of the yaml. You need to adapt it with your value : hostname of the pod and the device used to store the persistante volume.

```
  storage: # cluster level storage configuration and selection
    useAllNodes: false
    useAllDevices: false
    #deviceFilter: "xvde"
    config:
      storeType: bluestore
    nodes:
    - name: "icvkgn01"
      devices: # specific devices to use for storage can be specified for each node
      - name: "xvde"
    - name: "icvkgn02"
      devices: # specific devices to use for storage can be specified for each node
      - name: "xvde"
    - name: "icvkgn03"
      devices: # specific devices to use for storage can be specified for each node
      - name: "xvde"
```


- Install and configure  **rook-ceph** with script `run.sh`

If you want to remove it. Use script `clean.sh` but before change the hostname of each worker node by your own


```
REPLACE 

ssh -t icvkgn01 "sudo rm -rf /var/lib/rook"
ssh -t icvkgn02 "sudo rm -rf /var/lib/rook"
ssh -t icvkgn03 "sudo rm -rf /var/lib/rook"

WITH

ssh -t <worker_hostname> "sudo rm -rf /var/lib/rook"
ssh -t <worker_hostname> "sudo rm -rf /var/lib/rook"
ssh -t <worker_hostname> "sudo rm -rf /var/lib/rook"

```


