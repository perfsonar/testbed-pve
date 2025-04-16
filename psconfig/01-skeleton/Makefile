#
# Generic Mesh Makefile
#

OUTPUT=mesh.json


default: $(OUTPUT)

$(OUTPUT): $(MESH)
	jq \
		--slurpfile skeleton skeleton.json \
		'. *= $$skeleton[0]' \
		'$(MESH)' \
		> "$@"
TO_CLEAN += $(OUTPUT)


clean:
	rm -rf $(TO_CLEAN) *~
