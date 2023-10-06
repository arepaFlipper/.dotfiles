# Guide to setting Up SSH Key Authentication
**S**ecure **SH** (**SSH**) key authentication is a method of logging into remote servers securely
without the need for passwords. It uses public and private key pairs to authenticate users.
This guide will walk you through the process of generating SSH keys, configuring SSH, and
using SSH key authentication to connect to a remote server.

## Prerequisites
Before you begin, ensure you have the following:
- A local machine running a Unix-like operating system (e.g. Linux or macOS).
- Access to a remote server that you want to connect to using SSH.
- A valid email address for the key command (used for identifying the key).

### Step 1: Generate SSH key Pair
Run the following command to generate an SSH key pair:
```
ssh-keygen -t rsa -b 4096 -C "<your_email>" -f ~/.ssh/<key_name>
```

- `-t rsa`: Specifies the key type (RSA).
- `-b 4096`: Specifies the key size (4096 bits for better security).
- `-C "<your_email>"`: Adds a comment to the key for identification.
- `-f ~/.ssh/<key_name>`: Specifies the file path for the generated keys.

### Step 2: Copy Public Key to Remote Server
Use the following command to copy the public key to the remote server:
```
ssh-copy-id -i ~/.ssh/<key_name>.pub <user>@<server_address>
```

- `~/.ssh/<key_name>.pub`: Path to the public key.
- `<user>@<server_address>`: Replace with your server's username and address.
You will be prompted to enter the user's password on the remote server. After successful
authentication, the public key will be added to the `àuthorized_keys` file on the server,
allowing you to log in using the private key.

### Step 3: Configure SSH
Edit the SSH configuration file using the following command:
```
vim ~/.ssh/config
```
Inside the `~/.ssh/config` file, add the following configuration:
```
Host <connexion_name>
Hostname <server_address>
Port <server_port>
User <user>
IdentityFile ~/.ssh/<key_name (private)>
ServerAliveInterval 60
```
Replace the placeholders with your specific information:
- `<connexion_name>`: A nickname for your SSH connection.
- `<server_address>`: The local IP address or domain name of the remote server.
- `<server_port>`: The SSH port number (usually 22).
- `<user>`: Your username on the remote server.
- `<key_name (private)>`: Path to your private key.

The `ServerAliveInterval` setting keeps your SSH connection alive by sending a packet
every 60 seconds to prevent it from timing out.

### Step 4: Configure SSH
Ensure that your private key file is secure and not accessible by others:
```
chmod 600 ~/.ssh/<key_name (private)>
```
This command restricts access permissions to the private key, allowing only your user to 
read and write to it.

### Step 5: Connect to Remote Server
To connect to the remote server using SSH key authentication, simply run:
```
ssh <connexion_name>
```
This command will use the configuration you set up in `~/.ssh/config` and the SSH key to
log you in without requiring a password.

