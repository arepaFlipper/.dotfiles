# AWS service

## Add an ssh key

- Login to `https://us-east-1.console.aws.amazon.com/ec2/` with IAM user credentials.
- Go to `Key Pairs` to generate a `.pem` file. (`https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#KeyPairs:`)
- Move the downloaded `.pem` file to `~/.ssh/`:
  > `mv ~/Downloads/key.pem ~/.ssh/`
  > `chmod 400 ~/.ssh/key.pem`
- Create a public key with the `.pem` file:
  > `ssh-keygen -y -f ~/.ssh/key.pem`

- Copy the output and login into the server
- paste the output (public key) into `~/.ssh/authorized_keys`

- To access to openvpn:
once the instance is running:
  > go to `https://ip-address:943/admin/`
  > go to `user permissions` `https://ip-address:943/admin/user_permissions`
add a user and Local Password, and leave everything else default and save.

- From client create always a new profile to make a sure the credentials are new
