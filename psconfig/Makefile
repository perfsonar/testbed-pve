#
# Makefile for perfSONAR Testbed Mesh
#

export PATH := $(shell pwd)/bin:$(PATH)

MESH := mesh.json

default: build

PS_DATA := ps-data.json
$(PS_DATA): ../bootstrap/etc/hosts.json
	ln -s "$<" "$@"
TO_CLEAN += $(PS_DATA)


$(MESH):: $(PS_DATA)
	build-mesh . > $@
TO_CLEAN += $(MESH)

jq::
	which jq > /dev/null \
		|| sudo apt-get -y install jq

# TODO: Do we still want this?
psconfig:
	sudo ./bin/prep-system

# TODO: Do we still want this?
validate-mesh: psconfig $(MESH)
	psconfig validate --skip-pscheduler --deep "$(MESH)"

# TODO: Do we still want this?
address-audit: $(MESH)
	address-audit --warn-only < $(MESH)

# TODO: Do we still want this?
# TODO: Depend on validate-mesh first once that works.
audit: validate-mesh address-audit

build: jq $(MESH)


SUBDIRS := $(shell ls | egrep -e '^[0-9]+-')

clean:
	@for DIR in $(SUBDIRS) ; \
	do \
		make -C $$DIR $@ ; \
	done
	rm -rf $(TO_CLEAN) *~
	find . -name "*~" | xargs rm -rf
