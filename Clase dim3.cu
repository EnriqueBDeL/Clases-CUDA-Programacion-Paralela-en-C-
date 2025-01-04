#include <stdio.h>
#include <cuda.h>

__global__ void sumaVectores(int *A, int *B, int *C, int N) {
  
  	int idx = blockIdx.x * blockDim.x + threadIdx.x;
   
 	if (idx < N) {

       		C[idx] = A[idx] + B[idx];

    	}
}



int main(int argc, char **argv) {


    int N = 16;
    int size = N * sizeof(int);

    int *h_A = (int *)malloc(size);
    int *h_B = (int *)malloc(size);
    int *h_C = (int *)malloc(size);



    for (int i = 0; i < N; i++) {
        h_A[i] = i;
        h_B[i] = i * 2;
    }



    int *d_A, *d_B, *d_C;
    cudaMalloc(&d_A, size);
    cudaMalloc(&d_B, size);
    cudaMalloc(&d_C, size);


    cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice);


    dim3 blockDim(4); // Establece que cada bloque contiene 4 hilos. 

    dim3 gridDim((N + 3) / 4); // Calcula cuántos bloques son necesarios para cubrir todos los elementos de "N"



    sumaVectores<<<gridDim, blockDim>>>(d_A, d_B, d_C, N);

    cudaMemcpy(h_C, d_C, size, cudaMemcpyDeviceToHost);



    printf("Vector A: ");
    for (int i = 0; i < N; i++) {
        printf("%d ", h_A[i]);
    }
    printf("\n");



    printf("Vector B: ");
    for (int i = 0; i < N; i++) {
        printf("%d ", h_B[i]);
    }
    printf("\n");



    printf("Resultado (A + B): ");
    for (int i = 0; i < N; i++) {
        printf("%d ", h_C[i]);
    }
    printf("\n");



    free(h_A);
    free(h_B);
    free(h_C);
    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);

    return 0;
}
