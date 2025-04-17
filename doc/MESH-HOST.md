# Mesh Host Build Notes

## Container

General:
 * Use an out-of-the-way ID like `900`.
 * Hostname: `mesh.ps.ns.internet2.edu`
 * Add an appropriate SSH key

Template:
 * Build from Alpine.

Disk:
 * 4 GiB Disk in local-lvm

CPU:
 * 2 Cores

Memory:
 * Memory: 128
 * Swap: 0

Network:
 * Bridge: `bridge_b`
 * IPv4: `163.253.37.189/27       GW 163.253.37.161`
 * IPv6: `2001:468:2620:31::29/64 GW 2001:468:2620:31::1`

DNS:
 * Domain: `ps.ns.internet2.edu`
 * Servers: `1.1.1.1,8.8.8.8`

Options:
 * Start at Boot: Yes


## Build

**TODO:** Re-add port 22 once the network is properly ACL'd.

```
apk update \
    && apk add openssh-server fail2ban \
    && rc-update add fail2ban \
    && rc-service fail2ban start \
    && printf 'Port 48108\n' > /etc/ssh/sshd_config.d/10-ps-testbed.conf \
    && rc-update add sshd \
    && rc-service sshd start
```