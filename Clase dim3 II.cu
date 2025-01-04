#include <stdio.h>
#include <cuda.h>

//------------------------------------------------|
// Contenido: sentencia dim3 con dos dimensiones.
//------------------------------------------------|

__global__ void restarMatrices(int *A, int *B, int *C, int filas, int columnas) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    int idy = blockIdx.y * blockDim.y + threadIdx.y;

    if (idx < columnas && idy < filas) {
        int index = idy * columnas + idx;
        C[index] = B[index] - A[index];
    }
}

int main() {
    int filas = 4;
    int columnas = 4;
    int size = filas * columnas * sizeof(int);

    int *h_A = (int *)malloc(size);
    int *h_B = (int *)malloc(size);
    int *h_C = (int *)malloc(size);

    for (int i = 0; i < filas; i++) {
        for (int j = 0; j < columnas; j++) {
            h_A[i * columnas + j] = i * columnas + j + 1;
            h_B[i * columnas + j] = (i * columnas + j + 1) * 2;
        }
    }

    int *d_A, *d_B, *d_C;
    cudaMalloc(&d_A, size);
    cudaMalloc(&d_B, size);
    cudaMalloc(&d_C, size);


    cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice);


    dim3 blockDim(2, 2);

    dim3 gridDim((columnas + blockDim.x - 1) / blockDim.x, 
                (filas + blockDim.y - 1) / blockDim.y);




    restarMatrices<<<gridDim, blockDim>>>(d_A, d_B, d_C, filas, columnas);
    cudaDeviceSynchronize();

    cudaMemcpy(h_C, d_C, size, cudaMemcpyDeviceToHost);



    printf("Matriz A:\n");
    for (int i = 0; i < filas; i++) {
        for (int j = 0; j < columnas; j++) {
            printf("%d ", h_A[i * columnas + j]);
        }
        printf("\n");
    }



    printf("\nMatriz B:\n");
    for (int i = 0; i < filas; i++) {
        for (int j = 0; j < columnas; j++) {
            printf("%d ", h_B[i * columnas + j]);
        }
        printf("\n");
    }



    printf("\nResultado (B - A):\n");
    for (int i = 0; i < filas; i++) {
        for (int j = 0; j < columnas; j++) {
            printf("%d ", h_C[i * columnas + j]);
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
