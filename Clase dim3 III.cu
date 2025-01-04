#include <stdio.h>

__global__ void sumaMatrices3D(int *A, int *B, int *C, int z, int y, int x) {
   
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    int idy = blockIdx.y * blockDim.y + threadIdx.y;
    int idz = blockIdx.z * blockDim.z + threadIdx.z;

    if (idx < x && idy < y && idz < z) {

        int index = idz * y * x + idy * x + idx;

        C[index] = A[index] + B[index];
    }
}

int main() {


    int x = 3, y = 3, z = 3;
    int size = x * y * z * sizeof(int);


    int *h_A = (int *)malloc(size);
    int *h_B = (int *)malloc(size);
    int *h_C = (int *)malloc(size);


    for (int i = 0; i < z; i++) {
        for (int j = 0; j < y; j++) {
            for (int k = 0; k < x; k++) {
                h_A[i * y * x + j * x + k] = i * y * x + j * x + k + 1;
                h_B[i * y * x + j * x + k] = (i * y * x + j * x + k + 1) * 2;
            }
        }
    }



    int *d_A, *d_B, *d_C;
    cudaMalloc(&d_A, size);
    cudaMalloc(&d_B, size);
    cudaMalloc(&d_C, size);


    cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice);



    dim3 blockDim(2, 2, 2);
    dim3 gridDim((x + blockDim.x - 1) / blockDim.x, 
                 (y + blockDim.y - 1) / blockDim.y, 
                 (z + blockDim.z - 1) / blockDim.z);



    sumaMatrices3D<<<gridDim, blockDim>>>(d_A, d_B, d_C, z, y, x);
    cudaDeviceSynchronize();



    cudaMemcpy(h_C, d_C, size, cudaMemcpyDeviceToHost);



    printf("Matriz A:\n");
    for (int i = 0; i < z; i++) {
        for (int j = 0; j < y; j++) {
            for (int k = 0; k < x; k++) {
                printf("%d ", h_A[i * y * x + j * x + k]);
            }
            printf("\n");
        }
        printf("\n");
    }




    printf("Matriz B:\n");
    for (int i = 0; i < z; i++) {
        for (int j = 0; j < y; j++) {
            for (int k = 0; k < x; k++) {
                printf("%d ", h_B[i * y * x + j * x + k]);
            }
            printf("\n");
        }
        printf("\n");
    }




    printf("Resultado (A + B):\n");
    for (int i = 0; i < z; i++) {
        for (int j = 0; j < y; j++) {
            for (int k = 0; k < x; k++) {
                printf("%d ", h_C[i * y * x + j * x + k]);
            }
            printf("\n");
        }
        printf("\n");
    }



    free(h_A);
    free(h_B);
    free(h_C);
    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);

    return 0;
}
