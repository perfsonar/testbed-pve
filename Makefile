#
# Makefile for perfSONAR Testbed
#

SUBDIRS := \
	psconfig \
	bootstrap

default:
	@set -e ; for DIR in $(SUBDIRS) ; \
	do \
		$(MAKE) -C "$$DIR" ; \
	done


clean:
	rm -rf $(TO_CLEAN) *~
	@set -e ; for DIR in $(SUBDIRS) ; \
	do \
		$(MAKE) -C "$$DIR" $@ ; \
	done
	find . -name "*~" | xargs rm -f
