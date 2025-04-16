#
# Add the archives and set all tasks to use them
#

  . *= $skeleton[0]

# Get a list of the names of the archives
| (.archives | keys) as $archives

# Update the 'archive' item in all tasks to what's in the list.
| .tasks = ([
      .tasks
    | to_entries[]
    | .value.archives = $archives
  ]
  | from_entries)
