# NCU2023-High-Performance-Parallel-Computing
This is the code lib for my final exam paper's experiments.
- Advisor: Prof. Lisu Yu

## Environment Required
- CUDA >= 11.0
- g++ == clang version 14.0.0 (clang-1400.0.29.102)
- make == latest
- OpenMP == mpich-3.3.2

## Complie
```shell
make
```

## Run
```shell
bash run.sh cd_serial
bash run.sh cd_parallel {thread_number}
bash run.sh cd_cuda
```

