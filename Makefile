CC = g++
CUDA = nvcc
CCFLAGS = -I . -O2 -fopenmp

all: cd_parallel cd_serial cd_cuda

cd_parallel: chamfer_distance_parallel.cpp
	${CC} ${CCFLAGS} chamfer_distance_parallel.cpp -o cd_parallel

cd_serial: chamfer_distance_serial.cpp
	${CC} ${CCFLAGS} chamfer_distance_serial.cpp -o cd_serial
    
cd_cuda: chamfer_distance.cu
	${CUDA} chamfer_distance.cu -o cd_cuda

clean:
	rm -f cd_parallel cd_serial cd_cuda
