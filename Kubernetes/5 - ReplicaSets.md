
What is a Replicaset?

A ReplicaSet's purpose is to maintain a stable set of replica Pods running at any given time. As such, it is often used to guarantee the availability of a specified number of identical Pods.

Thank you for coming to my TED talk!

Just kidding, Replicasets are very important Kubernetes objects. I've very briefly explained what they do. But it is also important to understand why.

First of all, how is a ReplicaSet defined, which components ar eimportant?

```
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: frontend
  labels:
    app: guestbook
    tier: frontend
spec:
  # modify replicas according to your case
  replicas: 3
  selector:
    matchLabels:
      tier: frontend
  template:
    metadata:
      labels:
        tier: frontend
    spec:
      containers:
      - name: php-redis
        image: gcr.io/google_samples/gb-frontend:v3
```

Important fields:

As with all other Kubernetes API objects, a ReplicaSet needs the apiVersion, kind, and metadata fields. For ReplicaSets, the kind is always a ReplicaSet.

Selector - specifies how to identify Pods it can acquire
Replicas - Indicating how many Pods it should be maintaining
Pod template - Specifies the data of new Pods it should create to meet the number of replicas criteria.

A ReplicaSet is linked to its Pods via the Pods' metadata.ownerReferences field, which specifies what resource the current object is owned by.
A ReplicaSet identifies new Pods to acquire by using its selector. If there is a Pod that has no OwnerReference or the OwnerReference is not a Controller and it matches a ReplicaSet's selector, it will be immediately acquired by said ReplicaSet.

When to use a ReplicaSet
A ReplicaSet ensures that a specified number of pod replicas are running at any given time. However, a Deployment is a higher-level concept that manages ReplicaSets and provides declarative updates to Pods along with a lot of other useful features.

It is recommended to use Deployments rather than ReplicaSets directly. 

You may never need to manipulate ReplicaSet objects. Instead, use a Deployment, and define your application in the spec section. However, it is useful to understand how they work because they are used by Deployments (which you will directly use).

You can cun the previously shared yaml file by running ```kubectl apply -f ...```. Then you can view the ReplicaSets deployed by running  ```kubectl get rs ```.

ReplicaSets like we explained also create Pods. You can view the created Pods using the command ``` kubectl get pods ```.

You can also verify the OwnerReference of the pods by running the command ```kubectl get pods pod-name -o yaml```. Replace pod-name with the name of any of your pods.
