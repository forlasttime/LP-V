#include <iostream>
#include <random>
#include <chrono>
#include <omp.h>

using namespace std;

const int VECTOR_SIZE = 100;

int main()
{
    // set up a random number generator
    unsigned seed = chrono::system_clock::now().time_since_epoch().count();
    mt19937 generator(seed);
    uniform_int_distribution<int> distribution(0, 9999);

    // allocate memory for the vectors
    int* vector1 = new int[VECTOR_SIZE];
    int* vector2 = new int[VECTOR_SIZE];
    int* result = new int[VECTOR_SIZE];

    // fill the vectors with random numbers
    #pragma omp parallel for
    for (int i = 0; i < VECTOR_SIZE; i++)
    {
        vector1[i] = distribution(generator);
        vector2[i] = distribution(generator);
    }

    // add the vectors in parallel using OpenMP
    #pragma omp parallel for
    for (int i = 0; i < VECTOR_SIZE; i++)
    {
        result[i] = vector1[i] + vector2[i];
    }

    // print the first and second vectors and their sum
    cout << "Vector 1: \n[";
    for (int i = 0; i < VECTOR_SIZE; i++)
    {
        cout << vector1[i];
        if (i != VECTOR_SIZE - 1)
        {
            cout << ", ";
        }
    }
    cout << "]" << endl;

    cout << "Vector 2:\n [";
    for (int i = 0; i < VECTOR_SIZE; i++)
    {
        cout << vector2[i];
        if (i != VECTOR_SIZE - 1)
        {
            cout << ", ";
        }
    }
    cout << "]" << endl;
    cout << "Result: \n[";
    for (int i = 0; i < VECTOR_SIZE; i++)
    {
        cout << result[i];
        if (i != VECTOR_SIZE - 1)
        {
            cout << ", ";
        }
    }
    cout << "]" << endl;

    // free the allocated memory
    delete[] vector1;
    delete[] vector2;
    delete[] result;

    return 0;
}



