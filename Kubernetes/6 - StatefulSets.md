What is the difference between a Deployment and a StatefulSet?

If you've attended a DevOps interview for a Kubernetes focused role, I'm sure you have been asked this.

In the simplest terms StatefulSets are Kubernetes objects used to deploy Stateful applications.

But that brings up 2 more questions, what is state? and what is a stateful application?

The state of an application (or anything else, really) is its condition or quality of being at a given moment in time—its state of being.

A stateful app is a program that saves client data from the activities of one session for use in the next session. The data that is saved is called the application’s state.

Lets get a little more technical.

A StatefulSet manages the deployment and scaling of a set of Pods, and provides guarantees about the ordering and uniqueness of these Pods.

Like a Deployment, a StatefulSet manages Pods that are based on an identical container spec. Unlike a Deployment, a StatefulSet maintains a sticky identity for each of its Pods. These pods are created from the same spec, but are not interchangeable: each has a persistent identifier that it maintains across any rescheduling.

If you want to use storage volumes to provide persistence for your workload, you can use a StatefulSet as part of the solution. Although individual Pods in a StatefulSet are susceptible to failure, the persistent Pod identifiers make it easier to match existing volumes to the new Pods that replace any that have failed.
(We'll talk about volumes later)

Why use StatefulSets?

StatefulSets are great for applications that meet 1 or more of these criteria:

Stable, unique network identifiers.
Stable, persistent storage.
Ordered, graceful deployment and scaling.
Ordered, automated rolling updates.

If an application doesn't require any stable identifiers or ordered deployment, deletion, or scaling, you should deploy your application using a workload object that provides a set of stateless replicas like Deployments.

However StatefulSets also have some limitations:
1) Deleting and/or scaling a StatefulSet down will not delete the volumes associated with the StatefulSet. Its a feature but also a bug. The reason for this is to ensure your data is safe. You will have to delete the associated volumes manually. However, the volumes will be reused whenever the StatefulSet is scaled back up.
2) The storage for Pods must either be provisioned by a PersistentVolume Provisioner based on the requested storage class, or pre-provisioned by an admin.
3) StatefulSets do not provide any guarantees on the termination of pods when a StatefulSet is deleted. To achieve ordered and graceful termination of the pods in the StatefulSet, it is possible to scale the StatefulSet down to 0 prior to deletion.
4) StatefulSets currently require a Headless Service to be responsible for the network identity of the Pods. You are responsible for creating this Service.

See a sample StatefulSet specification below:

```
apiVersion: v1
kind: Service
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  ports:
  - port: 80
    name: web
  clusterIP: None
  selector:
    app: nginx
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: web
spec:
  selector:
    matchLabels:
      app: nginx # has to match .spec.template.metadata.labels
  serviceName: "nginx"
  replicas: 3 # by default is 1
  minReadySeconds: 10 # by default is 0
  template:
    metadata:
      labels:
        app: nginx # has to match .spec.selector.matchLabels
    spec:
      terminationGracePeriodSeconds: 10
      containers:
      - name: nginx
        image: registry.k8s.io/nginx-slim:0.8
        ports:
        - containerPort: 80
          name: web
        volumeMounts:
        - name: www
          mountPath: /usr/share/nginx/html
  volumeClaimTemplates:
  - metadata:
      name: www
    spec:
      accessModes: [ "ReadWriteOnce" ]
      storageClassName: "my-storage-class"
      resources:
        requests:
          storage: 1Gi
```

In the example above:

A Headless Service, named nginx, is used to control the network domain.
The StatefulSet, named web, has a Spec that indicates that 3 replicas of the nginx container will be launched in unique Pods.
The volumeClaimTemplates will provide stable storage using PersistentVolumes provisioned by a PersistentVolume Provisioner.

Pod Selector
You must set the .spec.selector field of a StatefulSet to match the labels of its .spec.template.metadata.labels. Failing to specify a matching Pod Selector will result in a validation error during StatefulSet creation.

.spec.minReadySeconds is an optional field that specifies the minimum number of seconds for which a newly created Pod should be running and ready without any of its containers crashing, for it to be considered available.

Pod Identity

StatefulSet Pods have a unique identity that consists of an ordinal, a stable network identity, and stable storage. The identity sticks to the Pod, regardless of which node it's (re)scheduled on.
By default, pods will be assigned ordinals from 0 up through N-1

Each Pod in a StatefulSet derives its hostname from the name of the StatefulSet and the ordinal of the Pod. The pattern for the constructed hostname is $(statefulset name)-$(ordinal). The example above will create three Pods named web-0,web-1,web-2.

For each VolumeClaimTemplate entry defined in a StatefulSet, each Pod receives one PersistentVolumeClaim. In the nginx example above, each Pod receives a single PersistentVolume with a StorageClass of my-storage-class and 1 GiB of provisioned storage. If no StorageClass is specified, then the default StorageClass will be used. When a Pod is (re)scheduled onto a node, its volumeMounts mount the PersistentVolumes associated with its PersistentVolume Claims.


Deployment and Scaling Guarantees 
For a StatefulSet with N replicas, when Pods are being deployed, they are created sequentially, in order from {0..N-1}.
When Pods are being deleted, they are terminated in reverse order, from {N-1..0}.
Before a scaling operation is applied to a Pod, all of its predecessors must be Running and Ready.
Before a Pod is terminated, all of its successors must be completely shutdown.

If you are new to Kubernetes and you're looking for Tutorials to master or practice some of the concepts from the tutorials, here are some tutorial guides:
https://kubernetes.io/docs/tutorials/stateful-application/basic-stateful-set/
https://kubernetes.io/docs/tasks/run-application/scale-stateful-set/
https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/

If you do not have a Kubernetes cluster but have a computer you can practice on, you can: 
1) Install Docker desktop and enable Kubernetes
2) Install Minikube

If you do not have a computer you can install applications on:
1) You can sign up for a developer Sandbox on Openshift.
2) Use Kubernetes on Google cloud. (You get $300 free credits on the entire platform)
3) Use the free tier of any other cloud provider
