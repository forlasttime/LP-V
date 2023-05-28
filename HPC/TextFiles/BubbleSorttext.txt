#include <iostream>
#include <omp.h>
#include <chrono>

using namespace std;
using namespace std::chrono;

void bubbleSort(int *arr, int n) {
    for (int i = 0; i < n - 1; i++) {
        for (int j = 0; j < n - i - 1; j++) {
            if (arr[j] > arr[j + 1]) {
                swap(arr[j], arr[j + 1]);
            }
        }
    }
}

void parallelBubbleSort(int *arr, int n) {
    int first;
    for (int i = 0; i < n; i++) {
        first = i % 2;
        #pragma omp parallel for default(none), shared(arr, first, n)
        for (int j = first; j < n - 1; j += 2) {
            if (arr[j] > arr[j + 1]) {
                swap(arr[j], arr[j + 1]);
            }
        }
    }
}

int main() {
    int n = 100;
    int *arr = new int[n];
    int *arr2 = new int[n];

    for (int i = 0; i < n; i++) {
        arr[i] = rand() % n;
        arr2[i] = arr[i];
    }
      cout<<"Before sorting"<<std::endl;
     for(int i=0;i<n;i++){
         cout<<arr[i]<<" ";
     }
     cout<<std::endl;
    auto start = high_resolution_clock::now();
    bubbleSort(arr, n);
    cout<<"After sorting"<<std::endl;
     for(int i=0;i<n;i++){
         cout<<arr[i]<<" ";
     }
     cout<<std::endl;
    auto stop = high_resolution_clock::now();
    auto duration = duration_cast<microseconds>(stop - start);
    cout << "Time taken by sequential bubble sort: " << duration.count() << " microseconds" << endl;

    start = high_resolution_clock::now();
    parallelBubbleSort(arr2, n);
    stop = high_resolution_clock::now();
    duration = duration_cast<microseconds>(stop - start);
    cout << "Time taken by parallel bubble sort: " << duration.count() << " microseconds" << endl;

    delete[] arr;
    delete[] arr2;

    return 0;
}
