#include <iostream>
#include <vector>
#include "../src/loadImage.hpp"
#include "../src/cpuFuncs.hpp"
#include "../src/gpuFuncs.hpp"

int main(){

  /* We get one of the larger images */
  int Nx = 2048, Ny = 2048;
  std::vector<short> ourImage = loadImage("../data/2048/img1.txt",Nx,Ny);
  std::vector<short> resultCPU(Nx*Ny);
  std::vector<short> resultGPU_naive(Nx*Ny);
  std::vector<short> resultGPU_shared(Nx*Ny);
  std::vector<short> resultGPU_const(Nx*Ny);


  /* We apply the edge detection algorithm */
  CPU_edgeDetection(ourImage, resultCPU, Nx, Ny);
  GPU_edgeDetection(ourImage, resultGPU_naive, Nx, Ny, NAIVE);
  GPU_edgeDetection(ourImage, resultGPU_shared, Nx, Ny, SHARED);
  GPU_edgeDetection(ourImage, resultGPU_const, Nx, Ny, CONSTANT);

  /* We write it in a file to later observe it is correct */
  FILE *fp_cpu, *fp_gpu_naive, *fp_gpu_shared, *fp_gpu_const;
  fp_cpu = fopen("cpu_edge_detect.txt","wb");
  fp_gpu_naive = fopen("gpu_naive_edge_detect.txt","wb");
  fp_gpu_shared = fopen("gpu_shared_edge_detect.txt","wb");
  fp_gpu_const = fopen("gpu_const_edge_detect.txt","wb");
  for(int i = 0; i < Ny; ++i){
    for(int j = 0; j < Nx-1; ++j){
      fprintf(fp_cpu, "%d,", resultCPU[j + Nx*i]);
      fprintf(fp_gpu_naive, "%d,", resultGPU_naive[j + Nx*i]);
      fprintf(fp_gpu_shared, "%d,", resultGPU_shared[j + Nx*i]);
      fprintf(fp_gpu_const, "%d,", resultGPU_const[j + Nx*i]);
    }
    fprintf(fp_cpu,"%d\n", resultCPU[(Nx-1) + Nx*i]);
    fprintf(fp_gpu_naive,"%d\n", resultGPU_naive[(Nx-1) + Nx*i]);
    fprintf(fp_gpu_shared,"%d\n", resultGPU_shared[(Nx-1) + Nx*i]);
    fprintf(fp_gpu_const,"%d\n", resultGPU_const[(Nx-1) + Nx*i]);
  }
  fclose(fp_cpu);
  fclose(fp_gpu_naive);
  fclose(fp_gpu_shared);
  fclose(fp_gpu_const);

  return 0;
}