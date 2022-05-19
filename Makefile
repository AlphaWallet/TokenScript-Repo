XPATH_ADDRESS =//ts:contract[@name=../ts:origins/ts:ethereum/@contract]/ts:address/text()
# note /ts:token/ts:origins/ts:ethereum/@contract is the name of the contract
XPATH_XMLNS :=namespace-uri(/*)
FLAGS=[NC,env=tsml:1]

TSMLFILES = $(shell find . -iname '*.tsml' | sed 's/\.tsml$$//')

help:
	# type: make .htaccess

.htaccess: prepare $(TSMLFILES)
	# No error found. Putting the file in place
	mv htaccess.tmp .htaccess

prepare:
	# Finding tsml files
	@test "" != "$(TSMLFILES)"
	@echo AddType application/tokenscript+xml .tstml > htaccess.tmp
	@echo Header set Content-type application/tokenscript+xml env=tsml >> htaccess.tmp
	@echo Header set Access-Control-Allow-Origin: "*" env=tsml >> htaccess.tmp
	@echo Options +FollowSymLinks             >> htaccess.tmp
	@echo RewriteEngine on                    >> htaccess.tmp

% : %.tsml
	# $^: Verifying namespace
	$(eval XMLNS = $(shell xmllint --xpath "$(XPATH_XMLNS)" $^))
	@test "" != $(findstring http://tokenscript.org,$(XMLNS))/
	# $^: $(XMLNS)
	@printf "setns ts=http://tokenscript.org/2019/10/tokenscript \ncat $(XPATH_ADDRESS)" | \
	xmllint --shell $^ | grep 0x | sed 's|^\(.*\)$$|RewriteRule ^$(patsubst http://tokenscript.org/%/tokenscript,%,$(XMLNS))/\1$$ $^ $(FLAGS)|' | tee -a htaccess.tmp

	@printf "setns ts=http://tokenscript.org/2020/03/tokenscript \ncat $(XPATH_ADDRESS)" | \
	xmllint --shell $^ | grep 0x | sed 's|^\(.*\)$$|RewriteRule ^$(patsubst http://tokenscript.org/%/tokenscript,%,$(XMLNS))/\1$$ $^ $(FLAGS)|' | tee -a htaccess.tmp

	@printf "setns ts=http://tokenscript.org/2020/06/tokenscript \ncat $(XPATH_ADDRESS)" | \
    	xmllint --shell $^ | grep 0x | sed 's|^\(.*\)$$|RewriteRule ^$(patsubst http://tokenscript.org/%/tokenscript,%,$(XMLNS))/\1$$ $^ $(FLAGS)|' | tee -a htaccess.tmp


upload:
	scp -P 2683 -r ./ net@s01cd.syd6.hostingplatform.net.au:repo.tokenscript.org/
