# Kubernetes cluster setup

## ADDING CNI

add any network solution (in this case flannel)

On the controlplane node, run the following set of commands to deploy the network plugin: Download the original YAML file and save it as kube-flannel.yml:

curl -LO https://raw.githubusercontent.com/flannel-io/flannel/v0.20.2/Documentation/kube-flannel.yml
Open the kube-flannel.yml file using a text editor.

Locate the args section within the kube-flannel container definition. It should look like this:

  args:
  - --ip-masq
  - --kube-subnet-mgr
Add the additional argument - --iface=eth0 to the existing list of arguments.

Now apply the modified manifest kube-flannel.yml file using kubectl:

kubectl apply -f kube-flannel.yml
After applying the manifest, the STATUS of both the nodes should become Ready

kubectl get nodes
NAME           STATUS   ROLES           AGE   VERSION
controlplane   Ready    control-plane   15m   v1.27.0
node01         Ready    <none>          15m   v1.27.0
