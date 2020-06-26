
FREEDOM_DEVTOOL_IMAGE_GITURL := https://github.com/sifive/freedom-devtool-image.git
FREEDOM_DEVTOOL_IMAGE_COMMIT := 4112777e614094df4aba3f501ba28bfee8e53e1e

ifneq ($(CUSTOM_COMMIT),)
FREEDOM_DEVTOOL_IMAGE_COMMIT := $(CUSTOM_COMMIT)
endif

SRCNAME_FREEDOM_DEVTOOL_IMAGE := freedom-devtool-image
SRCPATH_FREEDOM_DEVTOOL_IMAGE := $(SRCDIR)/$(SRCNAME_FREEDOM_DEVTOOL_IMAGE)

.PHONY: devtool-image devtool-image-package devtool-image-regress devtool-image-cleanup devtool-image-flushup
devtool-image: devtool-image-package

$(SRCPATH_FREEDOM_DEVTOOL_IMAGE).$(FREEDOM_DEVTOOL_IMAGE_COMMIT):
	mkdir -p $(dir $@)
	rm -rf $(SRCPATH_FREEDOM_DEVTOOL_IMAGE)
	rm -rf $(SRCPATH_FREEDOM_DEVTOOL_IMAGE).*
	git clone $(FREEDOM_DEVTOOL_IMAGE_GITURL) $(SRCPATH_FREEDOM_DEVTOOL_IMAGE)
	cd $(SRCPATH_FREEDOM_DEVTOOL_IMAGE) && git checkout --detach $(FREEDOM_DEVTOOL_IMAGE_COMMIT)
	cd $(SRCPATH_FREEDOM_DEVTOOL_IMAGE) && git submodule update --init --recursive
	date > $@

devtool-image-package: \
		$(SRCPATH_FREEDOM_DEVTOOL_IMAGE).$(FREEDOM_DEVTOOL_IMAGE_COMMIT)
	$(MAKE) -C $(SRCPATH_FREEDOM_DEVTOOL_IMAGE) package POSTFIXPATH=$(abspath .)/ EXTRA_OPTION=$(EXTRA_OPTION) EXTRA_SUFFIX=$(EXTRA_SUFFIX)

devtool-image-regress: \
		$(SRCPATH_FREEDOM_DEVTOOL_IMAGE).$(FREEDOM_DEVTOOL_IMAGE_COMMIT)
	$(MAKE) -C $(SRCPATH_FREEDOM_DEVTOOL_IMAGE) regress POSTFIXPATH=$(abspath .)/ EXTRA_OPTION=$(EXTRA_OPTION) EXTRA_SUFFIX=$(EXTRA_SUFFIX)

devtool-image-cleanup:
	$(MAKE) -C $(SRCPATH_FREEDOM_DEVTOOL_IMAGE) cleanup POSTFIXPATH=$(abspath .)/
	rm -rf $(SRCPATH_FREEDOM_DEVTOOL_IMAGE).*
	rm -rf $(SRCPATH_FREEDOM_DEVTOOL_IMAGE)

devtool-image-flushup:
	$(MAKE) -C $(SRCPATH_FREEDOM_DEVTOOL_IMAGE) flushup POSTFIXPATH=$(abspath .)/
