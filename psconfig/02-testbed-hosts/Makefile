#
# Makefile for SC Network Mesh
#

export PATH := $(shell pwd)/../bin:$(PATH)


PS_DATA := ../ps-data.json
SKELETON := skeleton.json
OUTPUT := mesh.json

SC_YEAR := $(shell date +%y)

default: $(OUTPUT)


$(OUTPUT): $(PS_DATA) $(SKELETON)
	rm -f $@
	runjq testbed-hosts.jq \
		--slurpfile data "$(PS_DATA)" \
		--slurpfile skeleton "$(SKELETON)" \
		< "$(MESH)" > $@
TO_CLEAN += $(OUTPUT)


clean:
	rm -rf $(TO_CLEAN) *~
