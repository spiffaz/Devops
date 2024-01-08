Pods are absractions of containers and run on worker nodes. They are instances of applications.
Each worker node has a Kubelet and Kube proxy.

Recap
  Kubelet controls container runtime
  Kube proxy manages connectivity inside Kubernetes (nodes, hosts, etc)

What is a pod? 
Official kubernetes definition - A Pod (as in a pod of whales or pea pod) is a group of one or more containers, with shared storage and network resources, and a specification for how to run the containers.

You want to run a new pod, the Kube scheduler will determine which node is best suited to run the pod based on resource availability, then spin up the pod.

It is possible to have multiple containers in a pod. Most people go with 1. Inside a pod you can decide to have the application, a logging container and a monitoring container.

Each pod will naturally have an ip address on the network. The ip address is assigned by the Kube proxy.

Pods are not long lasting, they can be replaced and can be rescheduled on any node. They should not or do not depend on any hard-coded requirements or specific nodes.

Pods are assigned new ip addresses whenever theyre scheduled.

In summary:
Pods have ip addresses
Pods have storage
They have configuration defining what they do

Pods have states. States are in summary the status.

Pods can be pending. Pod has been created, but processes or containers within it are not running yet.
Pods can be running. All of the containers in the pod have been created. At least one container is still running, or is in the process of starting or restarting.
Pods can be in an unknown state. For some reason the state of the Pod could not be obtained.
Pods can be in a failed state. Terminated with a non 0 exit code or was terminated by the system.
Pods can be succeeded. Ran as configured, and exited successfully


The best way to communicate with pods is via a service. Services receive traffic and forward it to respective pods. You can think of them as a load balancer that just receives traffic on n IP and distributes to the downstream resources.

Thats the end of the summary, you should have a basic understanding of what pods are from this. if you want to go deeper, please continue below.

Below is an example of a pod specification in Kubernetes. 

```
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx:1.14.2
    ports:
    - containerPort: 80
```

If you have Kubernetes =, you can run the command below to run this

``kubectl apply -f https://k8s.io/examples/pods/simple-pod.yaml``


Usually, you dont create pods directly. They are usually created from workload resources like Deployments, Jobs and statefulsets (we'll get to those later).

As mentioned earlier in the summary, Pods in a Kubernetes cluster are used in two main ways:
1) Pods that run a single container.
2) Pods that run multiple containers that need to work together. A Pod can encapsulate an application composed of multiple co-located containers that are tightly coupled and need to share resources. These co-located containers form a single cohesive unit of service—for example, one container serving data stored in a shared volume to the public, while a separate sidecar container refreshes or updates those files.

Pods are designed as relatively ephemeral, disposable entities. When a Pod gets created (directly by you, or indirectly by a controller), the new Pod is scheduled to run on a Node in your cluster. The Pod remains on that node until the Pod finishes execution, the Pod object is deleted, the Pod is evicted for lack of resources, or the node fails.

Note: Restarting a container in a Pod should not be confused with restarting a Pod. A Pod is not a process, but an environment for running container(s). A Pod persists until it is deleted.

You can use workload resources to create and manage multiple Pods for you. A controller for the resource handles replication and rollout and automatic healing in case of Pod failure. For example, if a Node fails, a controller notices that Pods on that Node have stopped working and creates a replacement Pod. The scheduler places the replacement Pod onto a healthy Node.

Here are some examples of workload resources that manage one or more Pods:

Deployment
StatefulSet
DaemonSet

Container restart policy
The spec of a Pod has a restartPolicy field with possible values Always, OnFailure, and Never. The default value is Always.

Healthchecks or probes can be used t check the health of a pod. This can be done by executing code within the container, or making a network request.

This can be done in 1 of 4 ways.
1) Executing a specified command inside the container. Its successful if the command exits with a 0 status code.
2) A remote procedure call using gRPC. The target should implement gRPC health checks. The diagnostic is considered successful if the status of the response is SERVING.
3) HTTP GET request against the Pod's IP address on a specified port and path. The diagnostic is considered successful if the response has a status code greater than or equal to 200 and less than 400.
4) TCP check against the Pod's IP address on a specified port. The diagnostic is considered successful if the port is open. 

Each probe has one of three results:

Success
The container passed the diagnostic.
Failure
The container failed the diagnostic.
Unknown
The diagnostic failed (no action should be taken, and the kubelet will make further checks).

___

3 types of probes can be set
livenessProbe - Indicates whether the container is running. If the liveness probe fails, the container is killed (by the kubelet), and the restart policy of the container is triggered. If a container does not provide a liveness probe, the default state is Success.
readinessProbe - Indicates whether the container is ready to respond to requests. If the readiness probe fails, the endpoints controller removes the Pod's IP address from the endpoints of all Services that match the Pod. The default state of readiness before the initial delay is Failure. If a container does not provide a readiness probe, the default state is Success.
startupProbe - Indicates whether the application within the container is started. All other probes are disabled if a startup probe is provided until it succeeds. If the startup probe fails, the kubelet kills the container, and the container is subjected to its restart policy. If a container does not provide a startup probe, the default state is Success.

When should you use a liveness probe?
If the process in your container can crash on its own whenever it encounters an issue or becomes unhealthy, you do not necessarily need a liveness probe; the kubelet will automatically perform the correct action by the Pod's restartPolicy.

When should you use a readiness probe?
If you'd like to start sending traffic to a Pod only when a probe succeeds, specify a readiness probe. In this case, the readiness probe might be the same as the liveness probe, but the existence of the readiness probe in the spec means that the Pod will start without receiving any traffic and only start receiving traffic after the probe starts succeeding.

If you want your container to be able to take itself down for maintenance, you can specify a readiness probe that checks an endpoint specific to readiness that is different from the liveness probe.

If your app has a strict dependency on back-end services, you can implement both a liveness and a readiness probe. The liveness probe passes when the app itself is healthy, but the readiness probe additionally checks that each required back-end service is available. This helps you avoid directing traffic to Pods that can only respond with error messages.

If your container needs to work on loading large data, configuration files, or migrations during startup, you can use a startup probe. However, if you want to detect the difference between an app that has failed and an app that is still processing its startup data, you might prefer a readiness probe.

When should you use a startup probe?
Startup probes are useful for Pods that have containers that take a long time to come into service. Rather than set a long liveness interval, you can configure a separate configuration for probing the container as it starts up, allowing a time longer than the liveness interval would allow.

To do -
Init containers
Sidecar containers
