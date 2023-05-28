#include <iostream>
#include <vector>
#include <omp.h>
using namespace std;
int parallelMin(const std::vector<int>& arr) {
    int min_val = arr[0];

    #pragma omp parallel for reduction(min : min_val)
    for (int i = 1; i < arr.size(); i++) {
        if (arr[i] < min_val) {
            min_val = arr[i];
        }
    }

    return min_val;
}

int parallelMax(const std::vector<int>& arr) {
    int max_val = arr[0];

    #pragma omp parallel for reduction(max : max_val)
    for (int i = 1; i < arr.size(); i++) {
        if (arr[i] > max_val) {
            max_val = arr[i];
        }
    }

    return max_val;
}

int parallelSum(const std::vector<int>& arr) {
    int sum = 0;

    #pragma omp parallel for reduction(+: sum)
    for (int i = 0; i < arr.size(); i++) {
        sum += arr[i];
    }

    return sum;
}

double parallelAverage(const std::vector<int>& arr) {
    int sum = parallelSum(arr);
    double avg = static_cast<double>(sum) / arr.size();
    return avg;
}

int main() {
    int n;
    cout << "Enter the number of elements: ";
    cin >> n;

    // Generate random numbers for the array
    vector<int> arr(n);
    for (int i = 0; i < n; i++) {
        cout<<"Enter element "<<i+1<<": ";
        cin>>arr[i];
    }

    // Perform parallel reduction operations
    int min_val = parallelMin(arr);
    int max_val = parallelMax(arr);
    int sum = parallelSum(arr);
    double avg = parallelAverage(arr);

    // Print results
    cout << "Array: ";
    for (int num : arr) {
        cout << num << " ";
    }
    cout << endl;

    cout << "Min: " << min_val <<endl;
    cout << "Max: " << max_val <<endl;
    cout << "Sum: " << sum << endl;
    cout << "Average: " << avg << endl;

    return 0;
}