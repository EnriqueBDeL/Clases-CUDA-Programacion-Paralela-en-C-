/*

CUDA (Compute Unified Device Architecture) es una plataforma de computación paralela desarrollada por NVIDIA. 
Permite a los desarrolladores utilizar las GPU (Unidades de Procesamiento Gráfico) para realizar cálculos de propósito general, no solo gráficos.

*/

#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>//Contiene definiciones y funciones necesarias para programar y gestionar aplicaciones CUDA en C.

int main (int argc, char **argv){

        int contar;
        cudaGetDeviceCount(&contar);

        printf("\nEl numero de GPUs disponibles es: %d\n\n",contar);



}
