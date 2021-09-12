
CURRENTPWD=$PWD

sudo apt-get update

# Install make
sudo apt-get install -y make

# install nmap-ncat to use neat to test port open
sudo apt-get install -y netcat

# install wget to import tools binary
sudo apt-get install -y wget

# install curl to test api
sudo apt-get install -y curl

FILE=$HOME/bin
if [ -d "$FILE" ]; then
    echo "$FILE already exist"
else 
    echo "Create $FILE"
    mkdir $FILE
    echo "PATH=$PATH:$FILE" >> $HOME/.profile
fi

# install helm3 
wget -O helm-v3.5.1-linux-amd64.tar.gz https://get.helm.sh/helm-v3.5.1-linux-amd64.tar.gz
tar -xzvf helm-v3.5.1-linux-amd64.tar.gz
cp linux-amd64/helm $HOME/bin/helm3
chmod +x $HOME/bin/helm3
sudo cp linux-amd64/helm /usr/local/bin/helm
kadmin@apicpar:~/APICv2018ltsInstallLinux$ sudo chmod +x /usr/local/bin/helm


# Install jq
wget -O jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
chmod +x ./jq
sudo cp jq $HOME/bin

# Install apicops
wget -O apicops https://github.com/ibm-apiconnect/apicops/releases/download/v0.2.69/apicops-linux 
chmod +x ./apicops
sudo cp apicops $HOME/bin

# Add tools
cp $CURRENTPWD/tools/cleanupapic.sh $HOME/bin 

# Create directory for apic k8s log 
FILE=/var/apic
if [ -d "$FILE" ]; then
    echo "$FILE already exist"
else 
    echo "Create $FILE"
    sudo mkdir $FILE
fi




