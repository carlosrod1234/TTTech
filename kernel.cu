/*
Designer: Carlos Rodriguez Calvo
Date: 16.03.2019
----------------------------------------------------------------------------------------------------------------------
Description:
	-Multipararell GPU library for factorial numbering calculation. 

Code based on: NVIDIA Gforce 1060

-----------------------------------------------------------------------------------------------------------------------
*/

#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <stdio.h>
#include <conio.h>
#include<time.h>

using namespace std;

__global__ void Factorial(unsigned long long *gpu_n, unsigned long long *gpu_r)
{
	int i;
	*gpu_r = 1;
	for (i = 1; i <= *gpu_n; i++)
	{
		*gpu_r = *gpu_r * i;
	}
}

int main()
{
	cudaEvent_t start, stop;
	float totalTime;
	unsigned long long Number;  //to store number on the cpu/host machine
	unsigned long long *dev_number;
	unsigned long long *res, result; //store result 
	printf("\n\t Enter the number : ");
	scanf("%d", &Number);
	//
	cudaEventCreate(&start);
	cudaEventRecord(start, 0);
	//
	cudaMalloc((void**)&dev_number, sizeof(int));
	cudaMalloc((void**)&res, sizeof(long int));
	//
	cudaMemcpy(dev_number, &Number, sizeof(int), cudaMemcpyHostToDevice);
	//
	Factorial << <1, 1 >> > (dev_number, res);
	cudaMemcpy(&result, res, sizeof(long int), cudaMemcpyDeviceToHost);
	cudaEventCreate(&stop);
	cudaEventRecord(stop, 0);
	cudaEventSynchronize(stop);
	cudaEventElapsedTime(&totalTime, start, stop);
	printf("Total time : %f ms\n", totalTime);
	printf("\n\t Factorial of number %d is %ld \n", Number, result);
	return 0;
}