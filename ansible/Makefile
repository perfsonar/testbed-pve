#
# Makefile for Ansible
#
# Define SSH_KEY to specify a key to use.
#

# ANSIBLE_VERBOSE := -vvv


ETC := ../etc

default: provision


# TODO: This should go into some top-level script
prep:
	sudo ansible-galaxy --verbose collection install \
		community.general \
		community.docker

MESH := ./assets/mesh/mesh.json
$(MESH): ../psconfig/mesh.json
	rm -f "$@"
	cp "$<" "$@"
TO_CLEAN += $(MESH)


INVENTORY := inventory

export ANSIBLE_HOST_KEY_CHECKING := false

ANSIBLE_LOG := ansible.log

ifdef SSH_KEY
ANSIBLE_PRIVATE_KEY := --private-key "$(SSH_KEY)"
endif

ifdef BUILD
ANSIBLE_PING_BUILD := $(BUILD)
ANSIBLE_PLAYBOOK_BUILD := -l $(BUILD)
else
ANSIBLE_PING_BUILD := all
ANSIBLE_PLAYBOOK_BUILD :=
endif

export ANSIBLE_SSH_ARGS="-F $(ETC)/ssh.config"

ping: $(INVENTORY) $(SSH_KEY)
	ansible $(ANSIBLE_VERBOSE) \
		$(ANSIBLE_PRIVATE_KEY) \
		--inventory "$(INVENTORY)" \
		-m ping \
		$(ANSIBLE_PING_BUILD)

provision-only: $(INVENTORY) $(SSH_KEY) $(MESH)
	ansible-playbook $(ANSIBLE_VERBOSE) \
		$(ANSIBLE_PRIVATE_KEY) \
		--inventory "$(INVENTORY)" \
		$(ANSIBLE_PLAYBOOK_BUILD) \
                main.yml \
                2>&1 \
                | tee $(ANSIBLE_LOG)
TO_CLEAN += $(ANSIBLE_LOG)

provision: ping provision-only


clean:
	rm -rf $(TO_CLEAN)
