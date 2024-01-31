Recap

  Remember that Pods are ephemeral? They have short lifespans and can be created and deleted regularly. 
    
  Also, remember that pods get new IP addresses whenever they are scheduled. This means you can never use a pod IP address in your application.

So how do we reliably access our pods? Services!

In Kubernetes, a Service is a method for exposing a network application that is running as one or more Pods in your cluster.

The Service API, part of Kubernetes, is an abstraction to help you expose groups of Pods over a network. Each Service object defines endpoints and a policy about how to make those pods accessible.

In simpler terms, services receive traffic/requests and forward them to the specified pods or backends using a specified protocol.

From my description so far, you might think that services can only route traffic to Pods. However, services can do more than that. We will talk about those later, but let's focus on Pods for a bit.

Defining a Service

A Service is a Kubernetes object. They can be created, viewed or modified using the Kubernetes API. See a sample definition below.

```
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  selector:
    app.kubernetes.io/name: MyApp
  ports:
    - protocol: TCP
      port: 80
      targetPort: 9376
```

The definition above creates a new Service named "my-service" which targets TCP port 9376 on any Pod with the app.kubernetes.io/name: MyApp label.

Port definitions

Port definitions in Pods have names, and you can reference these names in the targetPort attribute of a Service. For example, we can bind the targetPort of the Service to the Pod port in the following way:

```
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    app.kubernetes.io/name: proxy
spec:
  containers:
  - name: nginx
    image: nginx:stable
    ports:
      - containerPort: 80
        name: http-web-svc

---
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app.kubernetes.io/name: proxy
  ports:
  - name: name-of-service-port
    protocol: TCP
    port: 80
    targetPort: http-web-svc
```

Services can route traffic using any of the protocols below:
TCP
UDP
SCTP

There can also be multiple ports exposed by a single service. To do this, just create a new list item in the yaml specification.

As mentioned earlier, services usually route traffic or more technically "abstract Kubernetes pods" using selectors. However, Services can also abstract other kinds of backends, including ones that run outside the cluster.

For example:

You want to have an external database cluster in production, but in your test environment you use your own databases.
You want to point your Service to a Service in a different Namespace or on another cluster.
You are migrating a workload to Kubernetes. While evaluating the approach, you run only a portion of your backends in Kubernetes.

Because this Service has no selector, you can map the Service to the network address and port where it's running, by adding an EndpointSlice object manually. 

Endpoint slices are kubernetes objects that arrange network endpoints (devices with IP addresses) into smaller, more manageable groups for better performance and control. Basically a goruping of endpoints.

For example:

```
apiVersion: discovery.k8s.io/v1
kind: EndpointSlice
metadata:
  name: my-service-1 # by convention, use the name of the Service as a prefix for the name of the EndpointSlice
  labels:
    kubernetes.io/service-name: my-service
addressType: IPv4
ports:
  - name: '' 
    appProtocol: http
    protocol: TCP
    port: 9376
endpoints:
  - addresses:
      - "10.4.5.6"
  - addresses:
      - "10.1.2.3"
```

Types of Services
Kubernetes Service types allow you to specify what kind of Service you want. The options are:

1) ClusterIP - Exposes the Service on a cluster-internal IP. Choosing this value makes the Service only reachable from within the cluster. This is the default that is used if you don't explicitly specify a type for a Service. You can expose the Service to the public internet using an Ingress or a Gateway.

2) NodePort - Exposes the Service on each Node's IP at a static port (the NodePort). To make the node port available, Kubernetes sets up a cluster IP address, the same as if you had requested a Service of type: ClusterIP.
Using a NodePort gives you the freedom to set up your load-balancing solution, configure environments that are not fully supported by Kubernetes, or even expose one or more nodes' IP addresses directly.
Every node in the cluster configures itself to listen on that assigned port and to forward traffic to one of the ready endpoints associated with that Service. You'll be able to contact the type: NodePort Service, from outside the cluster, by connecting to any node using the appropriate protocol (for example: TCP), and the appropriate port (as assigned to that Service).

3) LoadBalancer - Exposes the Service externally using an external load balancer. Kubernetes does not directly offer a load-balancing component; you must provide one, or you can integrate your Kubernetes cluster with a cloud provider.
On cloud providers which support external load balancers, setting the type field to LoadBalancer provisions a load balancer for your Service.

4) ExternalName - Maps the Service to the contents of the externalName field (for example, to the hostname API.foo.bar.example). The mapping configures your cluster's DNS server to return a CNAME record with that external hostname value. No proxying of any kind is set up.
