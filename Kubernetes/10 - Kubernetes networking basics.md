In a Kubernetes cluster, every Pod gets its own unique cluster-wide IP address.

This means you dont have to setup custom networks for Pods to communicate with each other or worry about mapping container ports. This measn you can treat every pod like a VM or physical hosts from the perspectives of port allocation, naming, service discovery, load balancing, application configuration, and migration.

By default, this means:

1) pods can communicate with all other pods on any other node without NAT
2) agents on a node (e.g. system daemons, kubelet) can communicate with all pods on that node

Kubernetes IP addresses exist at the Pod scope - containers within a Pod share their network namespaces - including their IP address and MAC address. This means that containers within a Pod can all reach each other's ports on localhost. This also means that containers within a Pod must coordinate port usage, but this is no different from processes in a VM. This is called the "IP-per-pod" model.

Kubernetes networking addresses four concerns:

1) Containers within a Pod use networking to communicate via loopback. Think of this as using localhost on a machine.
2) Cluster networking provides communication between different Pods.
3) The Service API lets you expose an application running in Pods to be reachable from outside your cluster. (We will talk about services in a bit if you are not already familiar)
    Ingress provides extra functionality specifically for exposing HTTP applications, websites and APIs outside your cluster
4) You can also use Services to publish services only for consumption inside your cluster. 

Here are some Kubernetes networking terminologies and components you should be familiar with. We'll cove some of them in subsequent posts.
1) Service
This is used to expose an application running in your cluster behind a single outward-facing endpoint, even when the workload is split across multiple backends.

2) Ingress
This is used to make your HTTP (or HTTPS) network service available using a protocol-aware configuration mechanism, that understands web concepts like URIs, hostnames, paths, and more. The Ingress concept lets you map traffic to different backends based on rules you define 

3) Ingress Controller
For an Ingress to work in your cluster, there must be an ingress controller running. You need to select at least one ingress controller and make sure it is set up in your cluster. 

4) EndpointSlices
The EndpointSlice API is the mechanism that Kubernetes uses to let your Service scale to handle large numbers of backends, and allows the cluster to update its list of healthy backends efficiently.

5) DNS for Services and Pods
Your workload can discover Services within your cluster using DNS

There are a lot more, but these are what I will focus on in subsequent posts

