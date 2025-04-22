#
# Build the Throughput Mesh
#

# ------------------------------------------------------------------------------

# Utilities

# Get unique elements in an array
# Source: https://unix.stackexchange.com/a/738702
def uniq:
    map( { key: ., value:1 } )
  | from_entries
  | keys
;


# ------------------------------------------------------------------------------

# Categories (basically names by bandwidth)

def throughput_categories:
    [
        .addresses[]
      | select(._meta.bandwidth != null)
      | ._meta.bandwidth
      | tostring
    ]
  | [ uniq[] ]
  | map( {
           key: "\(( . | tonumber ) / 1000000000) Gbps",
           value: (. | tonumber)
         } )
  | from_entries
;


# ------------------------------------------------------------------------------

# Groups

def throughput_group(bandwidth):
  {
    "type": "disjoint",
    "a-addresses": [
        to_entries[]
	| select(.value._meta.external | not)
        | select(.value._meta.bandwidth >= bandwidth)
        | { "name": .key }
    ],
    "b-addresses": [
        to_entries[]
        | select(.value._meta.bandwidth >= bandwidth)
        | { "name": .key }
    ]
  }
;

def throughput_groups(categories):
    .addresses as $addresses
  | [
      categories
      | to_entries[]
      | .value as $bandwidth
      | {
          "key": "throughput-\($bandwidth)",
          "value": ($addresses | throughput_group($bandwidth))
        }
    ]
  | from_entries
;


# ------------------------------------------------------------------------------

# Tests

def test_name(ip_version; bandwidth; rev):
  "throughput-v\(ip_version)-\(bandwidth)-\(if rev then "reverse" else "forward" end)"
;


def throughput_test(ip_version; bandwidth; rev):
  {
    "key": test_name(ip_version; bandwidth; rev),
    "value": {
      "type": "throughput",
      "spec": {
        "source-node": "{% pscheduler_address[0] %}",
        "source": "{% address[0] %}",
        "dest": "{% address[1] %}",
        "dest-node": "{% pscheduler_address[1] %}",
        "ip-version": ip_version,
        "bandwidth": bandwidth,
        "reverse": rev,
	"duration": "PT15S"
      }
    }
  }
  | if bandwidth != null and bandwidth > 25000000000
    # TODO: Is 5 okay for this?
    then .value.spec.parallel = 5
    else .
    end
;


def throughput_tests:
  [   to_entries[]
    | .value as $bandwidth
    | throughput_test(4; $bandwidth; false),
      throughput_test(4; $bandwidth; true),
      throughput_test(6; $bandwidth; false),
      throughput_test(6; $bandwidth; true)
    ]
  | from_entries
;
  

# ------------------------------------------------------------------------------

# Schedules

def schedules:
  {
    "throughput": {
      "repeat": "PT4H",
      "slip": "PT4H"
    }
  }
;

  

# ------------------------------------------------------------------------------


# Tasks

def throughput_descr(ip_version; bandwidth; rev):
  "\(((bandwidth | tonumber) / 1000000000) | floor) Gbps \(if rev then "Reverse" else "Forward" end) IPv\(ip_version)"
;

def throughput_task(ip_version; bandwidth; rev):
    test_name(ip_version; bandwidth; rev) as $this_test
  | throughput_descr(ip_version; bandwidth; rev) as $descr
  | {
      "key": $this_test,
      "value": {
        "group": "throughput-\(bandwidth)",
        "test": $this_test,
	# TODO: Is this okay for throughput?
	"tools": [ "iperf3" ],
        "schedule": "throughput",
        "archives": [],
	"reference": {
	    "display-task-name": "Throughput - \($descr)",
            "display-task-group": [ "Throughput - \($descr)" ]
	},
        "_meta": {
          "display-name": "Throughput - \($descr)"
        }
      }
    }
;

def throughput_tasks(archives):
  [   to_entries[]
    | select(.key | startswith("throughput-"))
    | .value.spec.bandwidth as $bandwidth
    | throughput_task(4; $bandwidth; false),
      throughput_task(4; $bandwidth; true),
      throughput_task(6; $bandwidth; false),
      throughput_task(6; $bandwidth; true)
    ]
  | from_entries
;



# ------------------------------------------------------------------------------

# Main Program

  throughput_categories as $categories
| .groups *= throughput_groups($categories)
| .tests *= ($categories | throughput_tests)
| .schedules *= schedules
| (.archives | keys) as $archives
| .tasks *= (.tests | throughput_tasks($archives))


