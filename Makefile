# $Id: Makefile,v 1.14 2008/04/04 02:01:01 mascarenhas Exp $

include config

DESTDIR := /
LDIR := $(DESTDIR)/$(LUA_DIR)/wsapi
CDIR := $(DESTDIR)/$(LUA_LIBDIR)
BDIR := $(DESTDIR)/$(BIN_DIR)
PREF := $(DESTDIR)/$(PREFIX)

all: cgi fastcgi

cgi:

config:
	touch config

fastcgi: src/fastcgi/lfcgi.so

fcgi: fastcgi

src/fastcgi/lfcgi.so: src/fastcgi/lfcgi.h
	$(CC) $(CFLAGS) $(LDFLAGS) $(LIB_OPTION) -o src/fastcgi/lfcgi.so src/fastcgi/lfcgi.c -lfcgi $(INC)

install:
	@mkdir -p $(LDIR) $(BDIR)
	@cp src/wsapi/*.lua $(LDIR)
	@cp src/launcher/wsapi.cgi $(BDIR)
	@cp src/launcher/wsapi.fcgi $(BDIR)
	@echo "Installing of Lua WSAPI part is done!"

install-fcgi:
	@mkdir -p $(CDIR)
	@cp src/fastcgi/lfcgi.so $(CDIR)
	@echo "Installing of bundled Lua-fcgi lib is done!"

install-samples:
	@mkdir -p $(PREF)/samples
	@cp -r samples/* $(PREF)/samples

install-doc:
	@mkdir -p $(PREF)/doc
	@cp -r doc/* $(PREF)/doc

install-rocks: install install-doc install-samples

clean:
	@rm -f config src/fastcgi/lfcgi.so
	@echo "Cleaning is done!"

snapshot:
	git archive --format=tar --prefix=wsapi-$(VERSION)/ HEAD | gzip > wsapi-$(VERSION).tar.gz

rockspecs:
	for pkg in wsapi wsapi-fcgi wsapi-xavante ; do cp rockspec/$$pkg-$(VERSION_OLD)-1.rockspec rockspec/$$pkg-$(VERSION_NEW)-1.rockspec ; done
	for pkg in wsapi wsapi-fcgi wsapi-xavante; do sed -e "s/$(VERSION_OLD)/$(VERSION_NEW)/g" -i "" rockspec/$$pkg-$(VERSION_NEW)-1.rockspec ; done
	for pkg in wsapi wsapi-fcgi wsapi-xavante; do git add rockspec/$$pkg-$(VERSION_NEW)-1.rockspec ; done
