A DaemonSet ensures that all (or some) Nodes run a copy of a Pod. 

Whenever a new node is added to the cluster, a Daemon set adds an instance of a specified pod to the node. If the nodes are removed, the DaemonSet removes the Pods also.

Some typical uses of a DaemonSet are:

running a node monitoring daemon on every node
running a cluster storage daemon on every node
running a logs collection daemon on every node

Required Fields
As with all other Kubernetes config, a DaemonSet needs apiVersion, kind, and metadata fields. 

A DaemonSet also needs a .spec section.

Pod Template
The .spec.template is one of the required fields in .spec.

The .spec.template is a pod template. It has exactly the same schema as a Pod, except it is nested and does not have an apiVersion or kind.

In addition to required fields for a Pod, a Pod template in a DaemonSet has to specify appropriate labels.

A Pod Template in a DaemonSet must have a RestartPolicy equal to Always, or be unspecified, which defaults to Always.

Pod Selector
The .spec.selector field is a pod selector. It works the same as the .spec.selector of a Job.

You must specify a pod selector that matches the labels of the .spec.template. Also, once a DaemonSet is created, its .spec.selector can not be modified. Modifying the pod selector can lead to the unintentional orphaning of Pods.

Running Pods on select Nodes
If you specify a .spec.template.spec.nodeSelector, then the DaemonSet controller will create Pods on nodes which match that node selector. Likewise if you specify a .spec.template.spec.affinity, then DaemonSet controller will create Pods on nodes which match that node affinity. If you do not specify either, then the DaemonSet controller will create Pods on all nodes.

Here's a sample DaemonSet configuration that gathers log data from various sources within a system and seamlessly transfer it to Elasticsearch for storage and analysis.

```
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: fluentd-elasticsearch
  namespace: kube-system
  labels:
    k8s-app: fluentd-logging
spec:
  selector:
    matchLabels:
      name: fluentd-elasticsearch
  template:
    metadata:
      labels:
        name: fluentd-elasticsearch
    spec:
      tolerations:
      # these tolerations are to have the daemonset runnable on control plane nodes
      # remove them if your control plane nodes should not run pods
      - key: node-role.kubernetes.io/control-plane
        operator: Exists
        effect: NoSchedule
      - key: node-role.kubernetes.io/master
        operator: Exists
        effect: NoSchedule
      containers:
      - name: fluentd-elasticsearch
        image: quay.io/fluentd_elasticsearch/fluentd:v2.5.2
        resources:
          limits:
            memory: 200Mi
          requests:
            cpu: 100m
            memory: 200Mi
        volumeMounts:
        - name: varlog
          mountPath: /var/log
      # it may be desirable to set a high priority class to ensure that a DaemonSet Pod
      # preempts running Pods
      # priorityClassName: important
      terminationGracePeriodSeconds: 30
      volumes:
      - name: varlog
        hostPath:
          path: /var/log
```

See sample tutorial here

https://kubernetes.io/docs/tasks/manage-daemon/update-daemon-set/
