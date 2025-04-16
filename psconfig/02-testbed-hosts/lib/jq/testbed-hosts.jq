#
# Build the Testbed Mesh
#
# Slurped input in $data:
#  0 - Testbed Host Data
#  1 - Skeletal mesh file
#

# ------------------------------------------------------------------------------

# perfSONAR Node Addresses

def perfsonar_address:
  {
    "key": .host,
    "value": {
      "address": .host,
      "pscheduler-address": .host,
      "_meta": {
        "display-name": .label,
	"name": .host,
	"bandwidth": .bandwidth
      }
    }
  }
;


def perfsonars:
  [ to_entries[]
    | select(.value.enabled or .value.enabled == null)
    | .value.host = .key
    | .value
    | perfsonar_address
  ] | from_entries
;


def perfsonar_group:
  {
    "perfsonar": {
      "type": "disjoint",
      "a-addresses": [
                         to_entries[]
                       | .key
                       | select(endswith("-rtr") | not)
		     ]
		     | map({ name: . }),
      "b-addresses": [
                         to_entries[]
		       | .key
		       | select(endswith("-rtr") | not)
		   ]
		   | map({ name: . })
    }
  }
;

# ------------------------------------------------------------------------------


# Main Program


$data[0] as $data
| . *= $skeleton[0]
| .addresses *= ($data | perfsonars)
| .groups *= (.addresses | perfsonar_group)
