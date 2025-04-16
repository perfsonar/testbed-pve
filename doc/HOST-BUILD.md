# Host Build Notes

## Build Settings

### Create Container

General:
 * Add suitable SSH key

Template:
 * Whatever is appropriate

Disks:
 * Disk Size: 32
 * Put storage on local-lvm

CPU:
 * Cores: 4

Memory:
 * Memory: 8192
 * Swap: 8192

Network:
 * Bridge: bridge_a
 * IPv4 163.253.37.200/27       GW 163.253.37.193
 * IPv6 2001:468:2620:30::8/64  GW 2001:468:2620:30::1

DNS:
 * Domain: ps.ns.internet2.edu
 * DNS Servers:  1.1.1.1, 8.8.8.8

### Other Settings

 * Options -> Start At boot -> Yes


## Post-Build Bootstrapping

### EL

```
dnf -y install openssh-server \
    && printf 'Port 22\nPort 48108\n' > /etc/ssh/sshd_config.d/10-ps-testbed.conf \
    && systemctl enable --now sshd
```

### Debian/Ubuntu

```
apt-get -y update \
    && apt-get -y install openssh-server firewalld curl \
    && apt-get -y install openssh-server --reinstall \
    && printf 'Port 22\nPort 48108\n' > /etc/ssh/sshd_config.d/10-ps-testbed.conf \
    && systemctl enable --now ssh \
    && systemctl reload ssh \
    && systemctl enable --now firewalld \
    && firewall-cmd --add-port=48108/tcp --permanent \
    && firewall-cmd --reload
```

Make a snapshot called `fresh` for non-rebuild hosts

Make a snapshot called `testbed-rebuild` for rebuild hosts.
