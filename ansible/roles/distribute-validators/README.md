# Description

This role copies secrets and validators required for testnets to which Nimbus beacon nodes contribute.

# Warning

__This role does not take into account the currently existing layout of validators and secrets!__

Take into account what is already in place and which nodes are running and in what order you run this role to avoid a case in which validators on two or more nodes overlap.

# Details

You can read about validators and secrets here:
https://status-im.github.io/nimbus-eth2/faq.html#what-exactly-is-a-validator
https://status-im.github.io/nimbus-eth2/keys.html#storage
