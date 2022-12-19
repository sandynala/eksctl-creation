# Cluster and NodeGroup Installtion:

## Step-1: Create IAM user and provide admin credentials
 
    created "eks-user" and attached admin access to the user

## Step-2: Install unzip,AWS CLI,Kubectl and eksctl. Check kernerl info before Installation

> To check architecture, use the below commmands:

	   uname -m  (gives info whether the linux is 32 or 64 bit ,x86_64)
	   dpkg --print-architecture (gives type of processor)

> To install unzip, use the below command:

     apt-get install unzip -y

                                                          
                                                          
### To install awscli, use the below command:

    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"  x86_84
    unzip awscliv2.zip
    sudo ./aws/install
    ./aws/install -i /usr/local/aws-cli -b /usr/local/bin
    aws --version


                                                      
  ### To install kubectl, use the below commands: (if your EKS is 1.24 , you need to install kubectl of 1.23 version) 

    curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.23.13/2022-10-31/bin/linux/amd64/kubectl            --amd64
    curl -o kubectl.sha256 https://s3.us-west-2.amazonaws.com/amazon-eks/1.23.13/2022-10-31/bin/linux/amd64/kubectl.sha256

    curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.23.13/2022-10-31/bin/linux/arm64/kubectl   --arm64
    curl -o kubectl.sha256 https://s3.us-west-2.amazonaws.com/amazon-eks/1.23.13/2022-10-31/bin/linux/arm64/kubectl.sha256 

    openssl sha1 -sha256 kubectl
    chmod +x ./kubectl
    mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
    echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
    kubectl version --short --client


> To configure credentials, use the below command:

    aws configure
    aws sts get-caller-identity


> To list all users with attached policies, use the below command:

	aws iam list-users |grep -i username > list_users ; cat list_users |awk '{print $NF}' |tr '\"' ' ' |tr '\,' ' '|while read user; do echo "\n\n--------------Getting information for user $user-----------\n\n" ; aws iam list-user-policies --user-name $user --output yaml; aws iam list-groups-for-user  --user-name $user --output yaml;aws iam  list-attached-user-policies --user-name $user --output yaml ;done ;echo;echo



### To install eksctl, use the below commands: 

    curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
    sudo mv /tmp/eksctl /usr/local/bin
     eksctl version


## Step-3:  Cluster Creation

	eksctl create cluster --name <cluster-name> --region <region-code> --zones=<zone-name> --without-nodegroup --version=1.24

	eksctl create cluster --name nv-cluster --region us-east-1 --zones=us-east-1a,us-east-1b,us-east-1c --without-nodegroup --version=1.24


> get list of clusters

	eksctl get cluster   

> To enable and use AWS IAM roles for Kubernetes service accounts on our EKS cluster, we must create & associate OIDC identity provider.


    eksctl utils associate-iam-oidc-provider \
        --region region-code \
        --cluster <cluster-name> \
        --approve

    eksctl utils associate-iam-oidc-provider \
        --region us-east-1 \
        --cluster nv-cluster \
        --approve


## Step-4:Creating Managed-Nodegroups

    eksctl create nodegroup --cluster=nv-cluster \
                          --region=us-east-1 \
                          --name=nv-ng \
                          --node-type=t2.medium \
                          --nodes=2 \
                          --nodes-min=2 \
                          --nodes-max=4 \
                          --node-volume-size=20 \
                          --ssh-access \
                          --ssh-public-key=amazonfirst-JavMvnJenTom \
                          --managed \
                          --asg-access \
                          --external-dns-access \
                          --full-ecr-access \
                          --appmesh-access \
                          --alb-ingress-access  
   if you want to launch nodes in private , use flag --node-private-networking

> Note: Need to create key-pair first 

> List NodeGroups in a cluster

    eksctl get nodegroup --cluster=<clusterName>

> List Nodes in current kubernetes cluster

    kubectl get nodes -o wide

> Cluster Upgradation:

	eksctl upgrade cluster --name=nv-cluster --version=1.23

> Nodegroup Upgradation:

	eksctl upgrade nodegroup --name=nv-ng --cluster=nv-cluster

> Nodegroup Deletion:

	eksctl delete nodegroup --cluster=<clusterName> --name=<nodegroupName>

	eksctl delete nodegroup --cluster=nv-cluster --name=nv-ng

> Cluster Deletion:

    eksctl delete cluster <name of the cluster>
    eksctl delete cluster nv-cluster
