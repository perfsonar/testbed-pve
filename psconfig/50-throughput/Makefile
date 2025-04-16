#
# Makefile for SC Network Mesh
#

export PATH := $(shell pwd)/../bin:$(PATH)


OUTPUT := mesh.json


default: $(OUTPUT)


$(OUTPUT):
	runjq throughput.jq \
		< "$(MESH)" > $@
TO_CLEAN += $(OUTPUT)


clean:
	rm -rf $(TO_CLEAN) *~
