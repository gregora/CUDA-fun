#include <stdio.h>


#define N 1000


class c {
    public:
    float a = 32;


};



__global__
void add(int *a, int *b, c *c) {
    int i = blockIdx.x;
    int j = blockIdx.y;
    if (i<N) {
        b[i] = c->a;
    }
}



int main() {

    int ha[N], hb[N];
    int *da, *db;

    cudaMalloc((void **)&da, N*sizeof(int));
    cudaMalloc((void **)&db, N*sizeof(int));

    for (int i = 0; i<N; ++i) {
        ha[i] = i;
    }

    cudaMemcpy(da, ha, N*sizeof(int), cudaMemcpyHostToDevice);

    c hc;
    c* dc;

    cudaMalloc((void **)&dc, sizeof(c));
    cudaMemcpy(dc, &hc, sizeof(c), cudaMemcpyHostToDevice);


    add<<<N, 1>>>(da, db, dc);

    cudaMemcpy(hb, db, N*sizeof(int), cudaMemcpyDeviceToHost);

    for (int i = 0; i<N; ++i) {
        printf("%d\n", hb[i]);
    }

    cudaFree(da);
    cudaFree(db);

    return 0;
}
