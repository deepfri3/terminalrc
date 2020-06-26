SSH config:
https://www.cyberciti.biz/faq/how-to-set-up-ssh-keys-on-linux-unix/

Creating a RSA ssh key.
ssh-keygen -t rsa -f id_serverName_userName

This creates a public and private key.
1. id_serverName_userName     -> no ext is the private key
2. id_serverName_userName.pub -> pub is the public key

On the SSH server side.
# make directory
mkdir -p ~/.ssh
# add public key to authorized key file
cat pathTo/id_serverName_userName.pub >> ~/.ssh/authorized_keys
# sets permissions
chmod 0640 ~/.ssh/authorized_keys
chmod 0700 ~/.ssh

On the SSH client side:
# make directory
mkdir -p ~/.ssh

create a file named config with the following

Host profileName
  User userName
  HostName serverName
  IdentityFile ~/.ssh/id_serverName_userName

Example:
Host agentsmith
  User BakerG
  HostName AgentSmith.us009.siemens.net
  IdentityFile ~/.ssh/id_agentsmith_bakerg_sbtusfhp2736ws
  
# add config file
mv pathTo/config ~/.ssh/
# add private key
mv pathTo/id_serverName_userName ~/.ssh/
# sets permissions
chmod 0600 ~/.ssh/config
chmod 0400 ~/.ssh/id_serverName_userName
chmod 0700 ~/.ssh 

# Use ssh-copy-id to transfer public keys to other machines
http://linux.die.net/man/1/ssh-copy-id

How to disable SSH host key checking:
http://linuxcommando.blogspot.com/2008/10/how-to-disable-ssh-host-key-checking.html

From time to time, when you try to remote login to the same host from the same origin, you may be refused with the following warning message:
$ ssh peter@192.168.0.100
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
Someone could be eavesdropping on you right now (man-in-the-middle attack)!
It is also possible that the RSA host key has just been changed.
The fingerprint for the RSA key sent by the remote host is
3f:1b:f4:bd:c5:aa:c1:1f:bf:4e:2e:cf:53:fa:d8:59.
Please contact your system administrator.
Add correct host key in /home/peter/.ssh/known_hosts to get rid of this message.
Offending key in /home/peter/.ssh/known_hosts:3
RSA host key for 192.168.0.100 has changed and you have requested strict checking.
Host key verification failed.$

There are multiple possible reasons why the remote host key changed. A Man-in-the-Middle attack is only one possible reason. Other possible reasons include:
OpenSSH was re-installed on the remote host but, for whatever reason, the original host key was not restored.
The remote host was replaced legitimately by another machine.

If you are sure that this is harmless, you can use either 1 of 2 methods below to trick openSSH to let you login. But be warned that you have become vulnerable to man-in-the-middle attacks. 
The first method is to remove the remote host from the ~/.ssh/known_hosts file. Note that the warning message already tells you the line number in the known_hosts file that corresponds to the target remote host. The offending line in the above example is line 3("Offending key in /home/peter/.ssh/known_hosts:3")

You can use the following one liner to remove that one line (line 3) from the file.
$ sed -i 3d ~/.ssh/known_hosts

Note that with the above method, you will be prompted to confirm the host key fingerprint when you run ssh to login.

The second method uses two openSSH parameters:
StrictHostKeyCheckin, and UserKnownHostsFile.

This method tricks SSH by configuring it to use an empty known_hosts file, and NOT to ask you to confirm the remote host identity key.
$ ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no peter@192.168.0.100
Warning: Permanently added '192.168.0.100' (RSA) to the list of known hosts.
peter@192.168.0.100's password:

The UserKnownHostsFile parameter specifies the database file to use for storing the user host keys (default is ~/.ssh/known_hosts).

<http://www.commandlinefu.com/commands/view/188/copy-your-ssh-public-key-to-a-server-from-a-machine-that-doesnt-have-ssh-copy-id>

Terminal - Copy your ssh public key to a server from a machine that doesn't have ssh-copy-id
cat ~/.ssh/id_rsa.pub | ssh user@machine "mkdir ~/.ssh; cat >> ~/.ssh/authorized_keys"
Copy your ssh public key to a server from a machine that doesn't have ssh-copy-id

If you use Mac OS X or some other *nix variant that doesn't come with ssh-copy-id, this one-liner will allow you to add your public key to a remote machine so you can subsequently ssh to that machine without a password.
Add to favourites | Report as malicious
Alternatives

ssh-copy-id username@hostname
Copy your SSH public key on a remote machine for passwordless login - the easy way

ssh-copy-id user@host
Copy ssh keys to user@host to enable password-less ssh logins.

Same as original just no $ at start
cat ~/.ssh/id_rsa.pub | ssh <REMOTE> "(cat > tmp.pubkey ; mkdir -p .ssh ; touch .ssh/authorized_keys ; sed -i.bak -e '/$(awk '{print $NF}' ~/.ssh/id_rsa.pub)/d' .ssh/authorized_keys; cat tmp.pubkey >> .ssh/authorized_keys; rm tmp.pubkey)"
Copy your ssh public key to a server from a machine that doesn't have ssh-copy-id

This one is a bit more robust -- the remote machine may not have an .ssh directory, and it may not have an authorized_keys file, but if it does already, and you want to replace your ssh public key for some reason, this will work in that case as well, without duplicating the entry.
cat ~/.ssh/id_rsa.pub | ssh user@host 'cat >> ~/.ssh/authorized_keys'
Copy ssh keys to user@host to enable password-less ssh logins.

Alternative for machines without ssh-copy-id
cat ~/.ssh/id_rsa.pub | ssh user@host 'cat >> ~/.ssh/authorized_keys'
Copy ssh keys to user@host to enable password-less ssh logins.

