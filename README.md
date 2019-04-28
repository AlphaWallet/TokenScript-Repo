# TokenScript repo

## When will it be used

A user obtains a TokenScript in two ways.

1. If the user purchases or obtained a token through a dapp website, the TokenScript for that new token is shipped from that dapp website.

2. If the user needs a TokenScriptn without going through a dapp website,  (e.g. he receives a token from a friend), the user-agent (wallet) tries to find the TokenScript for that token by accessing a repo server, sourcing data from this repo.

This repo can be decentralised with the rise of reliable decentralised storage.

## How to submit a TokenScript

When you deploy your Tokenscript, please also send a copy to this repo in the form of a new Pull Request. This way:

1. If a user gets a token without going through any of the dapp websites with your TokenScript deployed, they can still get a copy from here.

2. When we upgrade the schema, we know who to talk to for updating existing TokenScript.

When you submit the TokenScript, create a new directory

It's optional to provide your smart contract source code next to the TokenScript, so if anything goes wrong we can have a look where the problem is. Don't submit a smart contract without TokenScript though.

## When a user-agent (client) obtains a TokenScript

- A user receives a token directly.
- A user scans a QR code or opens a link that represents a token-holding smart-contract.
- A user gets a "MagicLink" which allows him to redeem a token.
- A user recovers a key backup, and the user-agent discovers that he/she owns a few Token.

## How a user-agent (client) obtains a TokenScript

A wallet knows what namespaces it supports. It would request a TokenScript in the latest namespace at first, then fall back to the previously known TokenScript namespace.

For example, if a user received a token whose ERC20 contract address is `0xA66A3F08068174e8F005112A8b2c7A507a822335`, his wallet which understands 2019/05 and 2019/04 namespace would first try to access this URI:

https://repo.aw.app/2019/05/0xA66A3F08068174e8F005112A8b2c7A507a822335

If the server returns `404 Not Found`, or the client isn't satisfied with the TokenScript served (doesn't validate or signature verification failed) the client would then try to access its second preference:

https://repo.aw.app/2019/04/0xA66A3F08068174e8F005112A8b2c7A507a822335

This design is concise. However, for each Token which doesn't have a matching TokenScript the user-agent need to try two or more times. A possible improvement is to return `300 Multiple Choices` if a TokenScript in the desired namespace is not available but alternatives are available. We think at this stage such a design is deemed overkill.

## Will namespace and schema always be updated at the same time?

Likely so in 2019 and perhaps 2020 as well. In the first two years, TokenScript schema and namespace are versioned in the same way. A user-agent only works with TokenScripts whose schema and namespace are _both_ supported by the user-agent.

Beyond 2020, a user-agent would work with any TokenScript whose namespace it supports, even if its schema is not supported. By such an arrangement, TokenScript schema can evolve at a faster pace than its namespace, by adding new elements and not removing old elements; but it leaves room for mistakes, resulting existing Tokenscript becomes invalidated. We think it's a fair trade-off.

## Caching TokenScript

It's reasonable for user-agents to cache the signed and valid TokenScript locally.

If a TokenScript mentions multiple deployed contracts as the origin of the token, the TokenScript file would be available from multiple URLs of the repo server. Should a user-agent cache per TokenScript file, or token contract?

We recommend the user-agent to keep a local copy for each of these contracts in which the user has token. A user-agent doing so will end up with some duplicated TokenScript cached, but it allows some token contract to use a different version of TokenScript than others.

If you cache the TokenScript, the method to check for an update is the same as any other web content:

Include the `IF-Modified-Since` header HTTP header with the local XML's last modified date in the GET request. If the XML on the server has not been modified, the server returns an empty body with `304` code.

An example for the client to inquire repo.tokenscript.org for the latest update:

    curl -H "Accept: application/tokenscript+xml; charset=UTF-8" -H "IF-Modified-Since: Mon, 02 Jul 2019 13:23:00 GMT" https://repo.tokenscript.org/2019/05/0xd8e5f58de3933e1e35f9c65eb72cb188674624f3

If an update is needed, the new file is available in the body.

# Repo specification #

The TokenScripts are in a directory like this:

    www.sktravel.cn/2019/05/fifa-wc.tsml

- `www.sktravel.cn` is the `CommonName` of signing key's certificate.
- `2019/05` is the namespace of the TokenScript file.

Notice that although TokenScripts are _served_ by this repo server by contract address, the files are not _named_ by contract address. Typically, the name is the contract name as returned by the contract. Refer to the deployment document on how it works.

It's possible for one key to sign different TokenScripts, in this case, sktravel.cn signs both FIFA WorldCup token's TokenScript and Olympic game token's TokenScript.

      www.sktravel.cn/2019/05/fifa-wc.tsml
      www.sktravel.cn/2019/05/olympic.tsml

It's possible to have multiple Tokenscript in different XML namespaces:

      www.sktravel.cn/2019/05/fifa-wc.tsml
      www.sktravel.cn/2019/04/fifa-wc.tsml

If a signer no longer updates a TokenScript in an old namespace, say 2019/04, it can send a pull request to mark† it as 'Gone', knowing that user-agents that don't understand the newer namespace (and not have cached the file) renders the Token without TokenScript. The repo server returns `410 Gone` for a client requesting that file.

† We have not yet designed how to mark a file as Gone. Also, we judge whether the pull request is made by the previous signer by merely comparing the github handle. A process with the use of `HTTP DELETE` with a signed request would solve that issue, but we consider it overkill in the current adoption phase.
