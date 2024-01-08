What is a workload on Kubernetes?

A workload is an application running on Kubernetes.

Whether your workload is a single component or several that work together, on Kubernetes you run it inside a set of pods. 

A Pod is a set of running containers in your cluster. A Pod is also the smallest deployable units of computing that you can create and manage in Kubernetes.

Pods have lifecycles which determine how they behave in case of a failure. The failure can be as a result of the application within the pod failing or as a result of the node where the pod is hosted failing. 

This will be a challenge to manage this manually. Kubernetes provides us with some workload resources we can use to manage this better.

Some of these workload resources are:

1) ReplicaSets
2) Deployments
3) StatefulSets
4) DaemonSets
5) Jobs and CronJobs

We'll cover some of these resources is subsequent posts.
