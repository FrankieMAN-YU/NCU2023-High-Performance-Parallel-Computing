#include <iostream>
#include <cmath>
#include <sys/time.h>
#include <time.h>

const int NodeNumber = 18000;
using namespace std;

// 计算三维点云chamfer distance的函数
void computeChamferDistance(const float* points1, const float* points2, int numPoints1, int numPoints2, float* distances) {
    for (int i = 0; i < numPoints1; ++i) {
        float minDist = INFINITY;
        float x1 = points1[i * 3];
        float y1 = points1[i * 3 + 1];
        float z1 = points1[i * 3 + 2];
        for (int j = 0; j < numPoints2; ++j) {
            float x2 = points2[j * 3];
            float y2 = points2[j * 3 + 1];
            float z2 = points2[j * 3 + 2];
            float dx = x1 - x2;
            float dy = y1 - y2;
            float dz = z1 - z2;
            float dist = dx * dx + dy * dy + dz * dz;
            minDist = std::min(minDist, dist);
        }
        distances[i] = minDist;
    }
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

    
    struct timeval start, stop;
    gettimeofday(&start, NULL);
    // 调用函数计算点云chamfer distance
    computeChamferDistance(points1, points2, numPoints1, numPoints2, distances);
    // 计时结束
    gettimeofday(&stop, NULL);
    double elapse = (stop.tv_sec - start.tv_sec) * 1000 + (stop.tv_usec - start.tv_usec) / 1000;
    cout << "Serial runtime = " << elapse << "ms, number nodes = " << NodeNumber << endl;   

    // 释放内存
    delete[] points1;
    delete[] points2;
    delete[] distances;

    return 0;
}
