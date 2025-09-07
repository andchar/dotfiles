### Connect laptop to wifi

ip link set wlp3s0 up

wpa_passphrase <MYSSID> <passphrase> >> /etc/wpa_supplicant/wpa_supplicant.conf

sudo ln -s /etc/sv/wpa_supplicant /var/service
sudo ln -s /etc/sv/dhcpcd /var/service

# wpa_cli -i wlp3s0 scan
# wpa_cli -i wlp3s0 scan_results

### Configure ssh

## enable sshd

ln -s /etc/sv/sshd /var/service

## copy ssh key to it (from another machine)

ssh-copy-id root@192.168.1.150

### Install python3

sudo xbps-install -Syu python3
sudo xbps-install -Syu ansible
ansible-vault create vault.yml

```vault.yaml
user_name: your_user
user_password: your_password
```

ansible-playbook -i inventory setup.yml --ask-vault-pass
