# Testbed pSConfig Mesh Generator

The `Makefile` in this directory produces the pSConfig mesh that runs
perfSOANR in the testbed..

## How it Works

The process begins by setting the current version of the mesh to an empty JSON
object (`{}`).

For each directory whose name starts with two digits and hyphen (e.g.,
`03-foo`), the mesh builder will:

 * Run `make`, passing the name of a file containing the current mesh
   as the `MESH` variable.

 * Collect the resulting `mesh.json` in that directory.  This file
   should contain whatever was in the file pointed to by the `MESH`
   variable plus anything it added.  **It is important to avoid name
   collisions.**

Once the last version of the mesh has been written, `make` will place
it into `mesh.json`.
