# TokenScript repo

## Update instruction for sysop

If the TokenScript files in the repo is updated, the sysop should recreate the `.htaccess` file by:

    $ make .htaccess

This would generate a new .htaccess file based on the contract addresses mentioned in the TokenScript files.

Then, run this to upload the files. This will only work if you already configured SSH access:

    $ make upload

## Configure SSH access

This is tricky.  You need 2 things: 

1. Adding your IP address to the whitelist. [Official document](https://ventraip.com.au/faq/article/enabling-ssh-and-sftp-access-on-a-hosting-service/)
2. Adding your key to [the cPanel](https://web23.hosting-cloud.net:2083/cpsess0722241000/frontend/paper_lantern/index.html?login=1&post_login=29808973384901).

Note that the whitelist is not in the cPanel.

In reality, both are ticky.

1. Adding your IP address to the whitelist - the whitelist only allows 3 entries, **you need to delete an old one to add a new one**.
2. Adding SSH public key: It's better to add your SSH public key by asking a colleague to do the following, **avoid using cPanel at all**, since cPanel requires you to share your private key, which should not be shared in any case.

````
$ ssh -p 2683 net@s01cd.syd6.hostingplatform.net.au
$ cat >> .ssh/authorized_keys
````

## How the .htaccess file works

The Makfile generates a list of rewrite rules for accessing TokenScript files based on their token contract addresses. See more in [how_it_works.md](how_it_works.md)

## Background: how user agents get tokenscripts

See [how user agents get tokenscripts](how_user_agents_get_tokenscripts.md).
