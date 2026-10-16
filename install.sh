# Install Google Chrome
sudo yum install -y liberation-fonts-all
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm

# Install ansible
sudo yum install -y nvim git ansible
sudo rpm -i google-chrome-stable_current_x86_64.rpm
git clone https://github.com/andchar/dotfiles.git

# Obsidian
sudo yum install fuse-libs

# Edge
wget https://packages.microsoft.com/yumrepos/edge/Packages/m/microsoft-edge-beta-141.0.3537.25-1.x86_64.rpm
sudo rpm -i microsoft-edge-beta-141.0.3537.25-1.x86_64.rpm

# Sonicwall NetExtender (VPN)
wget https://software.sonicwall.com/NetExtender/NetExtender-linux-amd64-10.3.0-21.rpm
sudo rpm -i NetExtender-linux-amd64-10.3.0-21.rpm

# Keeper
wget https://www.keepersecurity.com/desktop_electron/Linux/repo/rpm/keeperpasswordmanager-17.3.3-1.x86_64.rpm
sudo rpm -i keeperpasswordmanager-17.3.3-1.x86_64.rpm

sudo yum install -y gammastep.x86_64 gammastep-indicator
