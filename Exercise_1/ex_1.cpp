//With the help of the following code  
//https://www.geeksforgeeks.org/longest-subarray-having-average-greater-than-or-equal-to-x/

#include <iostream>
#include <climits>
#include <bits/stdc++.h>
#include <fstream>
using namespace std;
 
// Function used to compare elements of preSum vector 
bool evaluate(const pair<int, int>& a, const pair<int, int>& b)
{
    if (a.first == b.first)
        return a.second < b.second;
  
    return a.first < b.first;
}
  
// Function to find index in preSum vector upto which
// all prefix sum values are less than or equal to val.
int bin_search(vector<pair<int, int> >& preSum, int arr_length, int valI)
{
    int lw = 0; //Set starting index
    int hg = arr_length - 1; //Set endin index
    int mid_v; 
  
    int ind_v = -1; // answer, value of index 
  
    //The following while loop, checks if middle value is 
    // less than or equal to given val index. In this case the answer can 
    // lie in mid_v + 1 .. n. In any other case it lies in 0 .. mid-1 
    while (lw <= hg) {
        mid_v = (lw + hg) / 2;
        if (preSum[mid_v].first <= valI) {
            ind_v = mid_v;
            lw = mid_v + 1;
        }
        else
            hg = mid_v - 1;
    }
  
    return ind_v;
}
  

//Main function to find longest subarray having avaerage 
//greater than or equal to 0
int LongestSub(int arr[], int n)
{
    int i,j;
    int max_k = 0;  //store length of longest subarray
    vector<pair<int, int> > preSum; //vextor to store prefix sum and ending index value of the prefix sum
    int n_sum = 0; // value of prefix sum
    int mInd[n]; // minimum Index Value of 0..i of preSum vector
    
  
    // Make the preSum vector, it consists of the sum and the corrensponding ending index
    for (i = 0; i < n; i++) {
        n_sum = n_sum + arr[i];
        preSum.push_back({ n_sum, i });
    }
   
    // sort Vector according to sum, in case of equal sum, sort according to index (through evaluate)
    sort(preSum.begin(), preSum.end(), evaluate);
    
   
    // Update minInd array.
    mInd[0] = preSum[0].second;
   
   //mInd stores the minimum index value in range [0..i] in sorted prefix sum vector
    for (j = 1; j < n; j++) {
        mInd[j] = min(mInd[j - 1], preSum[j].second);
    }
  
    n_sum = 0;
    for (i = 0; i < n; i++) {
        n_sum = n_sum + arr[i];

        // answer is i + 1 if n_sum>=0

        if (n_sum >= 0){
            max_k = i + 1;
        }
        // if n_sum <=0 then we search for an array 
        // that has sum that needs to be added to 
        // the current sum so that total sum is 
        // greater than or equal to 0. 
        else {
            int index = bin_search(preSum, n, n_sum);
            if (index != -1 && mInd[index] < i){
                // If that can be done, then we compare the length of 
                // the new subarray with maximum length found so far.
                max_k = max(max_k, i - mInd[index]);
            }
        }
    }
  
    return max_k;
}

int main(int argc, char **argv)
{
    char* filename = argv[1];

        ifstream myfile (filename);
        if (myfile.is_open())
        {
            ifstream in(filename, ios::in);
        int number;
        in >> number;
        int m = number;
        

        in >> number;
        int n = number;
        

        int arr[m];
        int i=0;
        while (in >> number) 
        {
            arr[i]=number;
            i++;
        }
        in.close();
        
        // Update array by subtracting m, the number of hospitals from each element.
        for (i = 0; i < m; i++){
        arr[i] = -arr[i] -n;
        }
        
        int k = LongestSub(arr, m);
        cout << k << endl;
        }
        else
        {
            perror("Unable to open file");
        }
        
        return 0;
} 