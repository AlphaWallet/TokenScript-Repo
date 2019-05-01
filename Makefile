XPATH_XMLNS :=namespace-uri(/*)
XPATH_C :=/ts:token/ts:origins/ts:ethereum/@contract
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
	# $^: Processing with namespace
	$(eval XMLNS = $(shell xmllint --xpath "$(XPATH_XMLNS)" $^))
	@test "" != $(findstring http://tokenscript.org,$(XMLNS))/
	# $^: $(XMLNS)
	$(eval CONTRACT = $(shell printf "setns ts=$(XMLNS)\nxpath /ts:token/ts:origins/ts:ethereum/@contract" | xmllint --shell $^ | grep content | sed 's/.*content=//'))
	@test "" != $(CONTRACT)
	# $^: contract name: $(CONTRACT)
	$(eval ADDR = $(shell printf "setns ts=$(XMLNS)\nxpath //ts:contract[@name='$(CONTRACT)']/ts:address/text()" | xmllint --shell $^ | grep content | sed 's/.*content=//'))
	@printf "setns ts=http://tokenscript.org/2019/05/tokenscript \ncat //ts:contract[@name='$(CONTRACT)']/ts:address/text()" | \
	xmllint --shell $^ | grep 0x | sed 's|^\(.*\)$$|RewriteRule ^$(patsubst http://tokenscript.org/%/tokenscript,%,$(XMLNS))/\1$$ $^|' | tee -a htaccess.tmp
