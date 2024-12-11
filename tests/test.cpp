#include <iostream>
#include <cassert>
#include <cmath>
#include <stdio.h>
#include "../funcA.h"
#include <vector>
#include <algorithm>
#include <chrono>

// Function to measure the performance of the computation and sorting
void verifyPerformance() {
    FuncA func;  // Create instance of FuncA class
    std::vector<double> results;
    results.reserve(2000000);  // Reserve memory for 2 million results

    // Fill the vector with computed values
    for (int i = 0; i < 2000000; i++) {
        results.push_back(func.compute(0.5, 5));
    }

    // Record start time
    auto start = std::chrono::high_resolution_clock::now();
    
    // Perform sorting multiple times to simulate load
    for (int i = 0; i < 1200; i++) {
        std::sort(results.begin(), results.end());
    }

    // Record end time
    auto end = std::chrono::high_resolution_clock::now();
    
    // Calculate elapsed time in milliseconds
    auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count();

    // Validate that the duration is within the expected range
    assert(duration >= 5000 && duration <= 20000 && "Performance verification failed");
}

// Main test execution function
int main() {
    testCompute();  // Assuming there's another function for basic tests
    verifyPerformance();  // Run the performance test
    return 0;
}
