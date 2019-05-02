XPATH_ADDRESS =//ts:contract[@name=../ts:origins/ts:ethereum/@contract]/ts:address/text()
# note /ts:token/ts:origins/ts:ethereum/@contract is the name of the contract
XPATH_XMLNS :=namespace-uri(/*)

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
	@echo Options +FollowSymLinks             >> htaccess.tmp
	@echo RewriteEngine on                    >> htaccess.tmp

% : %.tsml
	# $^: Verifying namespace
	$(eval XMLNS = $(shell xmllint --xpath "$(XPATH_XMLNS)" $^))
	@test "" != $(findstring http://tokenscript.org,$(XMLNS))/
	# $^: $(XMLNS)
	@printf "setns ts=http://tokenscript.org/2019/05/tokenscript \ncat $(XPATH_ADDRESS)" | \
	xmllint --shell $^ | grep 0x | sed 's|^\(.*\)$$|RewriteRule ^$(patsubst http://tokenscript.org/%/tokenscript,%,$(XMLNS))/\1$$ $^|' | tee -a htaccess.tmp
