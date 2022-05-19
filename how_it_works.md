# Deployment

This Repo server is designed to be deployed with Apache web server. The basic steps are:

1. Clone a copy.
2. Set the web root to the cloned copy and allow `.htaccess` with `AllowOverride`.
3. Run `make .htaccess` to generate the mapping from URLs to TokenScript files.

To update, run `git pull` followed by `make .htaccess`. Example:

    $ git pull origin master
    remote: Enumerating objects: 5, done.
    remote: Counting objects: 100% (5/5), done.
    remote: Compressing objects: 100% (3/3), done.
    remote: Total 3 (delta 2), reused 0 (delta 0), pack-reused 0
    Desempaquetando objetos: 100% (3/3), listo.
    Desde https://github.com/AlphaWallet/TokenScript-Repo
     * branch            master     -> FETCH_HEAD
       e1dddbf..a49eaaa  master     -> origin/master
    Actualizando e1dddbf..a49eaaa
    Fast-forward
     user-agent.md | 4 +++-
     1 file changed, 3 insertions(+), 1 deletion(-)
    $ make .htaccess
    # Finding tsml files
    # shong.wang/2019/05/EntryToken.tsml: Processing with namespace
    # shong.wang/2019/05/EntryToken.tsml: http://tokenscript.org/2019/05/tokenscript
    # shong.wang/2019/05/EntryToken.tsml: contract name: EntryToken
    RewriteRule ^2019/05/0x63cCEF733a093E5Bd773b41C96D3eCE361464942$ shong.wang/2019/05/EntryToken.tsml
    RewriteRule ^2019/05/0xFB82A5a2922A249f32222316b9D1F5cbD3838678$ shong.wang/2019/05/EntryToken.tsml
    RewriteRule ^2019/05/0x7c81DF31BB2f54f03A56Ab25c952bF3Fa39bDF46$ shong.wang/2019/05/EntryToken.tsml
    RewriteRule ^2019/05/0x2B58A9403396463404c2e397DBF37c5EcCAb43e5$ shong.wang/2019/05/EntryToken.tsml
    # No error found. Putting the file in place
    mv htaccess.tmp .htaccess

This should end up with a fresh `.htaccess` file which you can inspect. It look like this:

    AddType application/tokenscript+xml .tsml
    Options +FollowSymLinks
    RewriteEngine on
    RewriteRule ^2019/05/0x63cCEF733a093E5Bd773b41C96D3eCE361464942$ shong.wang/2019/05/EntryToken.tsml
    RewriteRule ^2019/05/0xFB82A5a2922A249f32222316b9D1F5cbD3838678$ shong.wang/2019/05/EntryToken.tsml
    RewriteRule ^2019/05/0x7c81DF31BB2f54f03A56Ab25c952bF3Fa39bDF46$ shong.wang/2019/05/EntryToken.tsml
    RewriteRule ^2019/05/0x2B58A9403396463404c2e397DBF37c5EcCAb43e5$ shong.wang/2019/05/EntryToken.tsml


Note that you do not need to restart the apache server for the update to work.

## Troubleshooting

The Makefile assumes that every file whose name ends with .tsml:

- uses a namespace that begins with `http://tokenscript.org` and ends with `tokenscript`;
- contains `<origins>` tag under the root element, which has the contract name;
- has a `<contract>` element with that name.

If any of the assumption fails to check out, the make process fails, and existing `.htaccess` file is left untouched. Also, a half-baken .htaccess.tmp is left behind to help with troubleshooting.

## What is not done

The Makefile doesn't validate the tsml files, nor does it checks the digital signature in it.
