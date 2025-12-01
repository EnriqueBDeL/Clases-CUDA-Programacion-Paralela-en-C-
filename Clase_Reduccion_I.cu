/*

Reducción en CUDA:

Una reducción (parallel reduction) es una operación donde tomas un arreglo de muchos elementos y lo reduces a un solo valor mediante una operación asociativa, por ejemplo: suma, máximo, mínimo, etc.

En GPU, la reducción es un patrón muy común y muy importante porque permite aprovechar el paralelismo masivo. CUDA divide el trabajo en muchos hilos y cada hilo procesa parte del arreglo.

Sin embargo, hacer esto de manera eficiente es complicado: hay que evitar divergencia, bank conflicts, pérdida de coalescing, y minimizar el trabajo innecesario.

*/


//Codigo reducción básica:

/*

Suma todos los elementos de un arreglo en la GPU mediante reducción paralela.
Devuelve el total final en una única variable.

*/


#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>

//===========================================
// Kernel de reducción 
//===========================================

__global__ void reduceBasic(int *input, int *output, int n) {

    extern __shared__ int sdata[]; //Declara un arreglo sin tamaño definido en memoria compartida. 
  				   //El tamaño se decide en el <<...>> al ejecutar el kernel.
                                   //Solo puede declararse una vez por archico o función kernel.

    int tid = threadIdx.x;



    // Copiar de global → shared
    if (tid < n){ 
        sdata[tid] = input[tid];
    }else{ 
        sdata[tid] = 0;
    }


    __syncthreads();//" __syncthreads" sirve para que cuando un hilo lo ejecute, este se detiene y espera a que todos los demás hilos del mismo bloque lleguen también a esa instrucción.
  		   //Solo cuando todos han alcanzado ese punto, todos continúan la ejecución.

    // Reducción clásica dividiendo a la mitad (s /= 2) cada vez
    for (int s = blockDim.x / 2; s > 0; s /= 2) {

        if (tid < s){ 
            sdata[tid] += sdata[tid + s];
        }

        __syncthreads();
    }

    // El hilo 0 devuelve el resultado
    if (tid == 0){
        *output = sdata[0];
    }
}


//===========================================
// Programa principal
//===========================================


int main() {

    //CPU

    int n = 1024; 
    int *h_input = (int*)malloc(n * sizeof(int));

    for(int i = 0; i < n; i++){ 
        h_input[i] = 1;
    }

    int *d_input, *d_output;


    cudaMalloc(&d_input, n * sizeof(int));
    cudaMalloc(&d_output, sizeof(int));

    cudaMemcpy(d_input, h_input, n * sizeof(int), cudaMemcpyHostToDevice);

//===========================================================================
    //GPU

    //<<<1 bloque , 1024 hilos , memoria shared dinámica>>>
    reduceBasic<<<1, 1024, 1024 * sizeof(int)>>>(d_input, d_output, n);

    int result;
    
    cudaMemcpy(&result, d_output, sizeof(int), cudaMemcpyDeviceToHost);

//===========================================================================
    //CPU

    printf("Resultado = %d%n", result);

    cudaFree(d_input);
    cudaFree(d_output);
    
    free(h_input);

    return 0;
}