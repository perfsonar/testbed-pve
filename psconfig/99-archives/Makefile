#
# Makefile for SC Network Mesh
#

export PATH := $(shell pwd)/../bin:$(PATH)


SKELETON := skeleton.json
OUTPUT := mesh.json


default: $(OUTPUT)


$(OUTPUT): $(SKELETON)
	rm -f $@
	runjq archives.jq \
		--slurpfile skeleton "$(SKELETON)" \
		< "$(MESH)" > $@
TO_CLEAN += $(OUTPUT)


clean:
	rm -rf $(TO_CLEAN) *~
