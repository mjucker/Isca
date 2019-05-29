#!/usr/bin/env bash
# Run a single iteration

rundir={{ rundir }}  # change this if you're rerunning from the output directory

source {{ env_source }}

ulimit -s unlimited

debug={{ run_idb }}                                     # logical to identify if running in debug mode or not

cd $rundir

export MALLOC_CHECK_=0

cp {{ execdir }}/{{ executable }} {{ executable }}

if [ $debug == True ]; then
   echo "Opening idb for debugging"
   exec idb -gdb  {{ executable}}
else
  exec nice -{{nice_score}} mpirun {{mpirun_opts}} -np {{ num_cores }} {{ execdir }}/{{ executable }} >> {{ outfile }}
fi

err_code=$?
if [[ $err_code -ne 0 ]]; then
	exit $err_code
fi



