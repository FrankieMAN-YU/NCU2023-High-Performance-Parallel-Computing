#include <iostream>
#include <cmath>
#include <cuda_runtime.h>
#include <sys/time.h>
#include <time.h>

#define THREADS_PER_BLOCK 2048
const int NodeNumber = 100000000;
using namespace std;

// CUDA Kernel函数，计算三维点云chamfer distance
__global__ void chamferDistanceCUDA(const float* points1, const float* points2, int numPoints1, int numPoints2, float* distances) {
    int tid = blockIdx.x * blockDim.x + threadIdx.x;
    if (tid < numPoints1) {
        float minDist = INFINITY;
        float x1 = points1[tid * 3];
        float y1 = points1[tid * 3 + 1];
        float z1 = points1[tid * 3 + 2];
        for (int i = 0; i < numPoints2; ++i) {
            float x2 = points2[i * 3];
            float y2 = points2[i * 3 + 1];
            float z2 = points2[i * 3 + 2];
            float dx = x1 - x2;
            float dy = y1 - y2;
            float dz = z1 - z2;
            float dist = dx * dx + dy * dy + dz * dz;
            minDist = fminf(minDist, dist);
        }
        distances[tid] = minDist;
    }
}

// 计算三维点云chamfer distance的函数
void computeChamferDistance(const float* points1, const float* points2, int numPoints1, int numPoints2, float* distances) {
    // 将点云数据传输到设备内存
    float* d_points1;
    float* d_points2;
    float* d_distances;
    cudaMalloc((void**)&d_points1, numPoints1 * 3 * sizeof(float));
    cudaMalloc((void**)&d_points2, numPoints2 * 3 * sizeof(float));
    cudaMalloc((void**)&d_distances, numPoints1 * sizeof(float));
    cudaMemcpy(d_points1, points1, numPoints1 * 3 * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_points2, points2, numPoints2 * 3 * sizeof(float), cudaMemcpyHostToDevice);

    // 设置CUDA Grid和Block的大小
    dim3 blockDim(THREADS_PER_BLOCK);
    dim3 gridDim((numPoints1 + blockDim.x - 1) / blockDim.x);

    // 调用CUDA Kernel函数计算三维点云chamfer distance
    chamferDistanceCUDA<<<gridDim, blockDim>>>(d_points1, d_points2, numPoints1, numPoints2, d_distances);

    // 将结果从设备内存传输回主机内存
    cudaMemcpy(distances, d_distances, numPoints1 * sizeof(float), cudaMemcpyDeviceToHost);

    // 释放设备内存
    cudaFree(d_points1);
    cudaFree(d_points2);
    cudaFree(d_distances);
}

int main() {
    // 定义点云数据和参数
    const int numPoints1 = NodeNumber;
    const int numPoints2 = NodeNumber;
    float* points1 = new float[numPoints1 * 3];
    float* points2 = new float[numPoints2 * 3];
    float* distances = new float[numPoints1];

    // 生成随机的点云数据（示例）
    for (int i = 0; i < numPoints1; ++i) {
        points1[i * 3] = static_cast<float>(rand()) / RAND_MAX;
        points1[i * 3 + 1] = static_cast<float>(rand()) / RAND_MAX;
        points1[i * 3 + 2] = static_cast<float>(rand()) / RAND_MAX;
    }
    for (int i = 0; i < numPoints2; ++i) {
        points2[i * 3] = static_cast<float>(rand()) / RAND_MAX;
        points2[i * 3 + 1] = static_cast<float>(rand()) / RAND_MAX;
        points2[i * 3 + 2] = static_cast<float>(rand()) / RAND_MAX;
    }

    // 调用函数计算点云chamfer distance
    struct timeval start, stop;
    gettimeofday(&start, NULL);
    computeChamferDistance(points1, points2, numPoints1, numPoints2, distances);
    gettimeofday(&stop, NULL);
    
    // 计算运算时间
    double elapse = (stop.tv_sec - start.tv_sec) * 1000 + (stop.tv_usec - start.tv_usec) / 1000;
    cout << "RTX 3060 CUDA runtime = " << elapse << "ms, number nodes = " << NodeNumber << ", thread per block = " << THREADS_PER_BLOCK << endl;

    // 打印计算结果
    //for (int i = 0; i < numPoints1; ++i) {
    //    std::cout << "Point " << i << ": " << distances[i] << std::endl;
    //}

    // 释放内存
    delete[] points1;
    delete[] points2;
    delete[] distances;

    return 0;
}
