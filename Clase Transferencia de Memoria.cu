#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>


int main(int argc, char **argv){

//host = CPU + memoria principal(RAM)

        int n = 10;


        float *h_dato = (float*)malloc(sizeof(float)*n);



        for ( int i = 0; i < n; i++){

                h_dato[i] = i * 1;

        }


        printf("%nDatos del host:%n");
        for(int i = 0; i < n; i++){

                printf("h_dato[%d] = %f%n",i,h_dato[i]);

        }


//------------------------------------------------------------------------------------------------------------------------------------|

        float *d_dato;

        cudaMalloc((void**)&d_dato,sizeof(float) * n); // "cudaMalloc" reserva memoria en la GPU.



        cudaMemcpy(d_dato, h_dato, sizeof(float) * n, cudaMemcpyHostToDevice); // "cudaMemcpy" copia datos entre CPU y la GPU.
        // "cudaMemcpyHostToDevice" indica que los datos deben copiarse desde el host a la memoria del dispositivo.


//------------------------------------------------------------------------------------------------------------------------------------|
//GPU

        float *h_resultado = (float*)malloc(sizeof(float) * n);

        cudaMemcpy(h_resultado,d_dato,sizeof(float) * n, cudaMemcpyDeviceToHost);
        // "cudaMemcpyDeviceToHost" indica que los datos deben copiarse desde la memoria del dispositivo a la memoria del host.

//------------------------------------------------------------------------------------------------------------------------------------|
//host


        printf("%nDatos depues de la copia a la GPU y de vuelta al host:%n");
        for(int i = 0; i < n; i++){

                printf("h_resultado[%d] = %f%n",i,h_resultado[i]);

        }


//Liberar memoria ----|
free(h_dato);
free(h_resultado);
cudaFree(d_dato); //Libera la memoria que le fue asignada a la GPU mediante "cudaMalloc".
//--------------------|


return 0;
}
                              

