# Description

This role configures port redirects using [iptables](https://linux.die.net/man/8/iptables).

# Configuration

You can redirect multiple ports:
```yaml
redirect_ports:
  - { src:  80, dst: 8080, comment: 'XYZ Service HTTP' }
  - { src: 443, dst: 8443, comment: 'XYZ Service HTTPS' }
```
All configured ports are opened in the `SERVICES` chain and redirected using `PREROUTING` chain in the `nat` table:
```
 > sudo iptables -L PREROUTING -t nat   
Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination         
REDIRECT   tcp  --  anywhere             anywhere             tcp dpt:http  /* XYZ Service HTTP */ redir ports 8080
REDIRECT   tcp  --  anywhere             anywhere             tcp dpt:https /* XYZ Service HTTPS */ redir ports 8443
```
