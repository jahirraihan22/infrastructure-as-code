step 1


These steps have to be performed on both nodes.

set net.bridge.bridge-nf-call-iptables to 1:
```sh

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

```
```sh

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

```
```sh

sudo sysctl --system
```
The container runtime has already been installed on both nodes, so you may skip this step.
Install kubeadm, kubectl and kubelet on all nodes:

``` sh
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl

mkdir -p /etc/apt/keyrings

curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update

sudo apt-get install -y kubelet=1.27.0-00 kubeadm=1.27.0-00 kubectl=1.27.0-00

sudo apt-mark hold kubelet kubeadm kubectl

```
=========================================

step 2

You can use the below kubeadm init command to spin up the cluster:

```sh
IP_ADDR=$(ip addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
```

```sh
kubeadm init --apiserver-cert-extra-sans=controlplane --apiserver-advertise-address $IP_ADDR --pod-network-cidr=[10.244.0.0/16](http://10.244.0.0/16)

```
Once you run the init command, you should see an output similar to below:
```log
[init] Using Kubernetes version: v1.27.4
[preflight] Running pre-flight checks
[preflight] Pulling images required for setting up a Kubernetes cluster
[preflight] This might take a minute or two, depending on the speed of your internet connection
[preflight] You can also perform this action in beforehand using 'kubeadm config images pull'
W0811 11:49:26.098524   18609 images.go:80] could not find officially supported version of etcd for Kubernetes v1.27.4, falling back to the nearest etcd version (3.5.7-0)
W0811 11:49:34.167505   18609 checks.go:835] detected that the sandbox image "[k8s.gcr.io/pause:3.6](http://k8s.gcr.io/pause:3.6)" of the container runtime is inconsistent with that used by kubeadm. It is recommended that using "[registry.k8s.io/pause:3.9](http://registry.k8s.io/pause:3.9)" as the CRI sandbox image.
[certs] Using certificateDir folder "/etc/kubernetes/pki"
[certs] Generating "ca" certificate and key
[certs] Generating "apiserver" certificate and key
[certs] apiserver serving cert is signed for DNS names [controlplane kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 192.29.49.3]
[certs] Generating "apiserver-kubelet-client" certificate and key
[certs] Generating "front-proxy-ca" certificate and key
[certs] Generating "front-proxy-client" certificate and key
[certs] Generating "etcd/ca" certificate and key
[certs] Generating "etcd/server" certificate and key
[certs] etcd/server serving cert is signed for DNS names [controlplane localhost] and IPs [192.29.49.3 127.0.0.1 ::1]
[certs] Generating "etcd/peer" certificate and key
[certs] etcd/peer serving cert is signed for DNS names [controlplane localhost] and IPs [192.29.49.3 127.0.0.1 ::1]
[certs] Generating "etcd/healthcheck-client" certificate and key
[certs] Generating "apiserver-etcd-client" certificate and key
[certs] Generating "sa" key and public key
[kubeconfig] Using kubeconfig folder "/etc/kubernetes"
[kubeconfig] Writing "admin.conf" kubeconfig file
[kubeconfig] Writing "kubelet.conf" kubeconfig file
[kubeconfig] Writing "controller-manager.conf" kubeconfig file
[kubeconfig] Writing "scheduler.conf" kubeconfig file
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Starting the kubelet
[control-plane] Using manifest folder "/etc/kubernetes/manifests"
[control-plane] Creating static Pod manifest for "kube-apiserver"
[control-plane] Creating static Pod manifest for "kube-controller-manager"
[control-plane] Creating static Pod manifest for "kube-scheduler"
[etcd] Creating static Pod manifest for local etcd in "/etc/kubernetes/manifests"
W0811 11:49:38.982335   18609 images.go:80] could not find officially supported version of etcd for Kubernetes v1.27.4, falling back to the nearest etcd version (3.5.7-0)
[wait-control-plane] Waiting for the kubelet to boot up the control plane as static Pods from directory "/etc/kubernetes/manifests". This can take up to 4m0s
[apiclient] All control plane components are healthy after 12.502522 seconds
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config" in namespace kube-system with the configuration for the kubelets in the cluster
[upload-certs] Skipping phase. Please see --upload-certs
[mark-control-plane] Marking the node controlplane as control-plane by adding the labels: [[node-role.kubernetes.io/control-plane](http://node-role.kubernetes.io/control-plane) [node.kubernetes.io/exclude-from-external-load-balancers](http://node.kubernetes.io/exclude-from-external-load-balancers)]
[mark-control-plane] Marking the node controlplane as control-plane by adding the taints [[node-role.kubernetes.io/control-plane:NoSchedule](http://node-role.kubernetes.io/control-plane:NoSchedule)]
[bootstrap-token] Using token: s9akv5.dczuex6oyzpv4xpl
[bootstrap-token] Configuring bootstrap tokens, cluster-info ConfigMap, RBAC Roles
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to get nodes
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstrap-token] Configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstrap-token] Configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[bootstrap-token] Creating the "cluster-info" ConfigMap in the "kube-public" namespace
[kubelet-finalize] Updating "/etc/kubernetes/kubelet.conf" to point to a rotatable kubelet client certificate and key
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:


  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config


Alternatively, if you are the root user, you can run:


  export KUBECONFIG=/etc/kubernetes/admin.conf


You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join [192.29.49.3:6443](http://192.29.49.3:6443/) --token s9akv5.dczuex6oyzpv4xpl \
        --discovery-token-ca-cert-hash sha256:0498b22f1d20375adce811f2a3513f8a039950db64399884da7432cb558b3e04 

```

Once the command has been run successfully, set up the kubeconfig:

```sh
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
================================================

step 3

Run kubeadm join genrated from previous response

```sh
kubeadm join [192.29.49.3:6443](http://192.29.49.3:6443/) --token s9akv5.dczuex6oyzpv4xpl \
        --discovery-token-ca-cert-hash sha256:0498b22f1d20375adce811f2a3513f8a039950db64399884da7432cb558b3e04 
```
================================================

step 4

add any network solution (in this case flannel)

On the controlplane node, run the following set of commands to deploy the network plugin:
Download the original YAML file and save it as kube-flannel.yml:

```sh
curl -LO https://raw.githubusercontent.com/flannel-io/flannel/v0.20.2/Documentation/kube-flannel.yml
```
Open the kube-flannel.yml file using a text editor.

Locate the args section within the kube-flannel container definition. It should look like this:

```yaml
  args:
  - --ip-masq
  - --kube-subnet-mgr
```

Add the additional argument - --iface=eth0 to the existing list of arguments.

Now apply the modified manifest kube-flannel.yml file using kubectl:

```sh
kubectl apply -f kube-flannel.yml
```

After applying the manifest, the STATUS of both the nodes should become Ready

```sh
kubectl get nodes
```
```log
NAME           STATUS   ROLES           AGE   VERSION
controlplane   Ready    control-plane   15m   v1.27.0
node01         Ready    <none>          15m   v1.27.0
```
