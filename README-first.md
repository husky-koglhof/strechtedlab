create 3 networks
stretched-int
stretched-ext
optional: add management network

install opnsense
add stretched-int and stretched-ext network
optional: add management network
configure with extras/opnsense.config

install ubuntu-server
install windows-desktop / ubuntu-desktop
add stretched-int and stretched-ext network
optional: add management network

# ubuntu-server:
## install opentofu
### Download the installer script:
curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh
### Alternatively: wget --secure-protocol=TLSv1_2 --https-only https://get.opentofu.org/install-opentofu.sh -O install-opentofu.sh

### Give it execution permissions:
chmod +x install-opentofu.sh

### Please inspect the downloaded script

### Run the installer:
./install-opentofu.sh --install-method deb

### Remove the installer:
rm -f install-opentofu.sh

### Clone Repo
clone this repository

### Download Images
```
1. vyos.iso - VyOS ISO / must be replaced with opnsense
2. coreos.qcow2 - CoreOS base for OpenShift
3. image.qcow2 - EL9 image for Containers VM
```