#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>


__device__ int suma(int a, int b){ 	// "__device__" se utiliza para declarar variables o funciones que se ejecutan dentro de la GPU.
					// Solo se puede acceder a un "__device" desde el codigo que tambien se ejecute en la GPU, como el "__global__" u otro "__device__".

	return a + b;

}



__global__ void kernel(){

 	int resultado = suma(5, 3);
	
	printf("\n\nEl resultado de la suma es: %d\n", resultado);

}



int main(int argc, char **argv){

	kernel<<<1, 1>>>();

	cudaDeviceSynchronize();	

	return 0;
}
