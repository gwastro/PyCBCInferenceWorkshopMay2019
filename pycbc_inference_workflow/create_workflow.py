#! /usr/bin/env python

import os
from pycbc import workflow as wf

# options
class Options:
    pass
opts = Options
opts.workflow_name = "wfex"
opts.config_files = ["ex_wfex.ini"]
opts.config_delete = None
opts.config_overrides = None
opts.output_file = "wfex.dax"
opts.output_map = "output.map"
opts.transformation_catalog = "wfex.tc.txt"

# set output directory
out_dir = "wfex_results"

# create output directory
wf.makedir(out_dir)

# create workflow
container = wf.Workflow(opts, opts.workflow_name)

# create executable
exe_echo = wf.Executable(container.cp, "echo",
                         ifos=container.ifos, out_dir=out_dir)

# create node
node_echo = exe_echo.create_node()

# add options
node_echo.add_opt("--option-1", container.analysis_time[0])
node_echo.add_opt("--option-2", container.analysis_time[1])

# add node to workflow
container += node_echo

# save
container.save(filename=opts.output_file,
               output_map_path=opts.output_map,
               transformation_catalog_path=opts.transformation_catalog)
