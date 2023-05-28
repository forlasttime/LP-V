#include <iostream>
#include <omp.h>
#include <algorithm>
#include <chrono>
using namespace std;
void merge(int *arr, int l, int m, int r) {
    int i, j, k;
    int n1 = m - l + 1;
    int n2 = r - m;

    int L[n1], R[n2];

    for (i = 0; i < n1; i++)
        L[i] = arr[l + i];
    for (j = 0; j < n2; j++)
        R[j] = arr[m + 1 + j];

    i = 0;
    j = 0;
    k = l;
    while (i < n1 && j < n2) {
        if (L[i] <= R[j]) {
            arr[k] = L[i];
            i++;
        } else {
            arr[k] = R[j];
            j++;
        }
        k++;
    }

    while (i < n1) {
        arr[k] = L[i];
        i++;
        k++;
    }

    while (j < n2) {
        arr[k] = R[j];
        j++;
        k++;
    }
}

void mergeSortSequential(int *arr, int l, int r) {
    if (l < r) {
        int m = l + (r - l) / 2;

        mergeSortSequential(arr, l, m);
        mergeSortSequential(arr, m + 1, r);

        merge(arr, l, m, r);
    }
}

void mergeSortParallel(int *arr, int l, int r) {
    if (l < r) {
        int m = l + (r - l) / 2;

#pragma omp task firstprivate(arr, l, m)
        mergeSortParallel(arr, l, m);

#pragma omp task firstprivate(arr, m, r)
        mergeSortParallel(arr, m + 1, r);

#pragma omp taskwait

        merge(arr, l, m, r);
    }
}

int main() {
    const int n = 100;
    int *arr = new int[n];
    int *arr2 = new int[n];

    for (int i = 0; i < n; i++) {
        arr[i] = rand() % n;
        arr2[i] = arr[i];
    }
     cout<<"Before sorting"<<endl;
     for(int i=0;i<n;i++){
         cout<<arr[i]<<" ";
     }
     cout<<endl;
    auto start = chrono::high_resolution_clock::now();
    mergeSortSequential(arr, 0, n - 1);
    cout<<"After sorting"<<endl;
     for(int i=0;i<n;i++){
         cout<<arr[i]<<" ";
     }
     cout<<endl;
    auto end =chrono::high_resolution_clock::now();
    auto duration =chrono::duration_cast<std::chrono::microseconds>(end - start);
    std::cout << "Sequential sort: " << duration.count() << " microseconds" <<endl;

    start = chrono::high_resolution_clock::now();
#pragma omp parallel
#pragma omp single
    mergeSortParallel(arr2, 0, n - 1);
    end = chrono::high_resolution_clock::now();
    duration = chrono::duration_cast<std::chrono::microseconds>(end - start);
    cout << "Parallel sort: " << duration.count() << " microseconds" << endl;

    delete[] arr;
    delete[] arr2;

    return 0;
}
