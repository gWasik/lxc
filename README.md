# lxc

## ASCII ART

https://patorjk.com/software/taag/#p=display&f=Chunky&t=Update%20VM%20and%20CT

## manual

for my lxc init

```
apt install htop net-tools
"wget" "https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/.ssh/authorized_keys" "-O" "/root/.ssh/authorized_keys"
```

## for all containers

```
bash -c "$(wget -qLO - https://raw.githubusercontent.com/gWasik/lxc/refs/heads/main/update-containers.sh)"
```
