#include <stdio.h>
#include <iostream>
#include <fstream>
#include <stack>
#include <bits/stdc++.h> 
using namespace std;


bool isSafe (int x, int y, int row, int col, bool**& vis)
{	
    //if x or y is outside of bounds return false 
    if (x <0 || y <0 || x >= row || y >= col)
        return false;
    // if cell is already visited 
    if (vis[x][y])
        return false;

    //otherwise, it can be visited 
    return true; 
}
int loops_rooms (char**& arr,int row, int col, bool**& vis){
    int i;
    int count = 0; 
    int k = row*col; 
    
    stack <pair<int, int> > st;  
    
    for (i=0;i<col;i++){
        if (arr[0][i] == 'U'){
            st.push({0,i});
            vis[0][i] = true;

        }
    }
    for (i=0;i<col;i++){
        if (arr[row-1][i] == 'D'){
            st.push({row-1,i});
            vis[row-1][i] = true; 
        }
    }
    for (i=0;i<row;i++){
        if (arr[i][0] == 'L'){
            st.push({i,0});
            vis[i][0] = true;
        }
    }
    for (i=0;i<row;i++){
        if (arr[i][col-1] == 'R'){
            st.push({i,col-1});
            vis[i][col-1] = true; 
        }
    }
    while (!st.empty()){
        pair<int, int> curr = st.top();
        st.pop(); 
        count++;
        int r = curr.first;
        int c = curr.second; 
        
        if (isSafe(r,c+1,row,col,vis) && arr[r][c+1] == 'L'){
            st.push({r,c+1}); 
            vis[r][c+1] = true;
            
        }
        if (isSafe(r,c-1,row,col,vis) && arr[r][c-1] == 'R'){
            st.push({r,c-1}); 
            vis[r][c-1] = true; 
            
        }
        if (isSafe(r+1,c,row,col,vis) && arr[r+1][c] == 'U'){
            st.push({r+1,c}); 
            vis[r+1][c] = true; 
            
        }
        if (isSafe(r-1,c,row,col,vis) && arr[r-1][c] == 'D'){
            st.push({r-1,c}); 
            vis[r-1][c] = true; 
            
        }
    }
    
    return k-count; 

}

int main(int argc, char** argv)
{
    
    ifstream myfile ;
    myfile.open(argv[1]);
    int row, col; 

    myfile >> row >> col ;


    char** arr = new char*[row];

    for (int i = 0 ; i < row ; i++){
    	arr[i] = new char[col];
    }

    for (int i =0;i<row;i++){
    	for (int j =0;j<col;j++){
    		myfile >> arr[i][j];
    	}
    }
   
    bool** vis = new bool*[row];

    for (int i = 0 ; i < row ; i++){
    	vis[i] = new bool[col];
    }

    
    int k = loops_rooms(arr,row,col,vis);
    cout << k << endl;
      
    for(int i =0; i<row;++i){
    	delete [] arr[i];
    }

    return 0;
}        