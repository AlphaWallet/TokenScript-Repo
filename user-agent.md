# User-agent (wallet) behaviour

## How a user-agent (client) gets a TokenScript from this repo

This repo's content is provided through repo.tokenscript.org.

A wallet knows what namespaces it supports. It would request a TokenScript in the latest namespace at first, then fall back to the previously known TokenScript namespace.

For example, if a user received a token whose ERC20 contract address is `0xA66A3F08068174e8F005112A8b2c7A507a822335`, his wallet which understands 2019/05 and 2019/04 namespace would first try to access this URI:

https://repo.tokenscript.org/2019/05/0xA66A3F08068174e8F005112A8b2c7A507a822335

If the server returns `404 Not Found`, or the client isn't satisfied with the TokenScript served (doesn't validate or signature verification failed) the client would then try to access its second preference:

https://repo.tokenscript.org/2019/04/0xA66A3F08068174e8F005112A8b2c7A507a822335

This design is concise and does not use HTTP content negotiation. However, for each Token which doesn't have a matching TokenScript the user-agent need to try two or more times. A possible improvement is to return `300 Multiple Choices` if a TokenScript in the desired namespace is not available but alternatives are available. We think at this stage such a design is deemed overkill.

## HTTP Headers ##

These headers should be included with every request:

    "Accept": "text/xml; charset=UTF-8"
    "X-Client-Name": "AlphaWallet"
    "X-Client-Version": "1.0.3"
    "X-Platform-Name": "iOS"
    "X-Platform-Version": "11.1.2"

`X-Platform-Name` should be set to `iOS` or `Android`.

The `If-Modified-Since` header should be included if the XML requested for is already cached on the device:

    "If-Modified-Since": "Wed, 21 Oct 2015 07:28:00 GMT"

Do not specify a timestamp representing a point in the future.

## Caching TokenScript

It's reasonable for user-agents to cache the signed and valid TokenScript locally.

If a TokenScript mentions multiple deployed contracts as the origin of the token, the TokenScript file would be available from multiple URLs of the repo server. Should a user-agent cache per TokenScript file, or token contract?

We recommend the user-agent to keep a local copy for each of these contracts in which the user has token. A user-agent doing so will end up with some duplicated TokenScript cached, but it allows some token contract to use a different version of TokenScript than others.

If you cache the TokenScript, the method to check for an update is the same as any other web content:

Include the `IF-Modified-Since` header HTTP header with the local XML's last modified date in the GET request. If the XML on the server has not been modified, the server returns an empty body with `304` code.

An example for the client to inquire repo.tokenscript.org for the latest update:

    $ curl -I -H "Accept: application/tokenscript+xml; charset=UTF-8" -H "IF-Modified-Since: Tue, 30 Apr 2019 13:23:00 GMT" https://repo.tokenscript.org/2019/05/0x63cCEF733a093E5Bd773b41C96D3eCE361464942
    HTTP/2 304 
    date: Tue, 30 Apr 2019 13:32:03 GMT

If an update is needed, the new file is available in the body.

