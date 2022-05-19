# TokenScript repo

## Update instruction for sysop

If the TokenScript files in the repo is updated, the sysop should recreate the `.htaccess` file by:

    $ make .htaccess

This would generate a new .htaccess file based on the contract addresses mentioned in the TokenScript files.

Then, run this to upload the files. This will only work if you already configured SSH access:

    $ make upload

## How it works

The Makfile generates a list of rewrite rules for accessing TokenScript files based on their token contract addresses. See more in [how_it_works.md](how_it_works.md)

## When will it be used

A user obtains a TokenScript in two ways.

1. If the user accesses a token use-case through a website, the TokenScript for that use-case is offered through that web page[^1].

2. If the user needs a TokenScriptn without going through a dapp website, (e.g. he receives a token from an exchange withdraw or restoring a wallet backup), the user-agent (wallet) tries to find the TokenScript for that token by accessing the `scriptURI()` repo server. Using this repo as a backup source if that function doesn't exist on the token contract.

## Submit a TokenScript to this repo

When you deploy your Tokenscript, please also send a copy to this repo in the form of a new Pull Request. By doing so:

1. If a user gets a token without going through any of the dapp websites with your TokenScript deployed, they can still get a copy from here.

2. When we upgrade the schema, we know who to talk to for updating existing TokenScript.

When you submit the TokenScript, create a new directory following the convention [as specified](hier.md).

## When a user-agent (client) obtains a TokenScript from this repo

- A user receives a token directly.
- A user scans a QR code or opens a link that represents a token-holding smart-contract.
- A user gets a "MagicLink" which allows him to redeem a token.
- A user recovers a key backup, and the user-agent discovers that he/she owns a few Token.


Check [user-agent behaviour](user-agent.md) for how a user-agent is supposed to communicate with a repo server.

## Will namespace and schema always be updated at the same time?

Likely so in 2019 and perhaps 2020 as well. In the first two years, TokenScript schema and namespace are versioned in the same way. A user-agent only works with TokenScripts whose schema and namespace are _both_ supported by the user-agent.

Beyond 2020, a user-agent would work with any TokenScript whose namespace it supports, even if its schema is not supported. By such an arrangement, TokenScript schema can evolve at a faster pace than its namespace, by adding new elements and not removing old elements; but it leaves room for mistakes, resulting existing Tokenscript becomes invalidated. We think it's a fair trade-off.

