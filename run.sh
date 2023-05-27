app=${1}

if [ ${app} = "cd_serial" ]; then
    ./cd_serial
fi

if [ ${app} = "cd_parallel" ]; then
    mpirun -np ${2} ./cd_parallel
fi

if [ ${app} = "cd_cuda" ]; then
    ./cd_cuda 
fi