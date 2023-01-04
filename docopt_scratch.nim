let doc = """
scratch_scratch

Usage: 
  scratch_scratch (ODD EVEN)...

Example:
  docopt_scratch 1 2 3 4
  
  {"EVEN": ["2", "4"], "ODD": ["1", "3"]}
  1 2
  3 4

Options:
  -h, --help
"""

import docopt

let args = docopt(doc)
echo args

for i in 0 ..< args["ODD"].len:
  echo args["ODD"][i] & " " & args["EVEN"][i]