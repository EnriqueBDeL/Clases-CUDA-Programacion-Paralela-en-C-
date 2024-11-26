#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>

//---------------------------------------------------------------|
//
// La funcion "__global__" se conoce como kernel. 
//
// Solo puede ser de tipo "void".
//
// Las funciones "__global__" se ejecutan en la GPU, pero se 
// llaman desde la CPU.(No desde funciones ejecutadas en la GPU) 
//
// Cada llamada a esta funcion, lanza multiples hilos en paralelo.
//
//---------------------------------------------------------------|


__global__ void sumaVectores(float *A, float *B, float *C, int n){

   int idx = blockIdx.x * blockDim.x + threadIdx.x; // Calcula el indice global unico del hilo dentro de una cuadricula unidimensional.

// blockIdx.x -> indice del bloque actual en la cuadricula. En este caso, identifica la posicion del bloque actual en el eje X.

// blockDim.x -> numero de hilos por bloque en el eje X.

// threadIdx.x -> indice del hilo dentro del bloque actual.  


  if (idx < n){

	C[idx] = A[idx] + B[idx];
	
 }  


}

int main(int argc, char **argv){

	int n = 1000;


	//Memoria CPU
	float *h_A = (float *)malloc(n * sizeof(float));
	float *h_B = (float *)malloc(n * sizeof(float));
	float *h_C = (float *)malloc(n * sizeof(float));



for(int i = 0; i < n; i++){

	h_A[i] = i * 1.0;
	h_B[i] = i * 2.0;
	
}



//--------------------------------------------------------------------------%
//Memoria GPU

float *d_A,*d_B,*d_C;

	cudaMalloc((void**)&d_A,n * sizeof(float)); // Reserva memoria en la GPU.
	cudaMalloc((void**)&d_B,n * sizeof(float));
	cudaMalloc((void**)&d_C,n * sizeof(float));


cudaMemcpy( d_A, h_A, n * sizeof(float), cudaMemcpyHostToDevice); // Copia datos entre la CPU y la GPU.
cudaMemcpy( d_B, h_B, n * sizeof(float), cudaMemcpyHostToDevice); // "cudaMemcpyHostToDevice" -> copia desde la memoria del host (CPU) a la memoria del dispositivo (GPU).

/*

   Otros tipos:

   "cudaMemcpyDeviceToHost" -> copia desde la memoria del dispositivo (GPU) a la memoria del host (CPU).

   "cudaMemcpyDeviceToDevice" -> copia dentro de la memoria del dispositivo. (de una region a otra)

   "cudaMemcpyHostToHost" -> copia dentro de la memoria del host. ( de una region a otra)


*/

//--------------------------------------------------------------------------%
//Kernel

int nb = (n + 256 - 1)/256;


sumaVectores<<<nb, 256>>>( d_A, d_B, d_C, n); // Lanza un kernel en la GPU.

// nb = numero de bloques que se lanzan | 256 = numero de hilos por bloque


// Lo que hay entre parentesis, son las mismas variables del "__global__".



//cudaDeviceSynchronize(); // Asegura que todas las operaciones en la GPU se hayan completado antes de que el host continue con la ejecucion.


cudaMemcpy(h_C, d_C, n*sizeof(float), cudaMemcpyDeviceToHost);


printf("\nResultado:\n");
for(int i = 0; i <  10; i++){

	printf("C[%d] = %f\n",i,h_C[i]);

}


free(h_A);
free(h_B);
free(h_C);

cudaFree(d_A);
cudaFree(d_B);
cudaFree(d_C);



return 0;
}
