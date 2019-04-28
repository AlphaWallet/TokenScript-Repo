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
