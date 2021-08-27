import numpy as np
import sys


inputFile = open(sys.argv[1])

maze = []
for line in inputFile:
    maze.extend(line.split())    

row = int(maze.pop(0))
col = int(maze.pop(0))

for i in range(0,row):
     maze[i] = list(maze[i]) 


mul = col*row

vis1 = [] 
for i in range(0,col):
    vis1.append(0)

vis= []
for i in range(0,row):
    vis.append(vis1)

visited = np.array(vis)


def isSafe(x,y,vis):
    if (x<0 or y<0 or x>=row or y>=col):
        return False 
    if (vis[x][y]):
        return False 
    return True

def check_outline(maze,col,row,vis):
    stack = []
    for i in range(0,col):
        if maze[0][i] == 'U':
            stack.append((0,i))
            visited[0][i] = 1
            
    for i in range(0,col):
        if maze[row-1][i] == 'D':
            stack.append((row-1,i))
            visited[row-1][i] = 1
            
    for i in range(0,row):
        if maze[i][0] == 'L':
            stack.append((i,0))
            visited[i][0] = 1
            
    for i in range(0,row):
        if maze[i][col-1] == 'R':
            stack.append((i,col-1))
            visited[i][col-1] = 1
            
    return stack,visited

    
    
stack,visited = check_outline(maze,col,row,visited)

def maze_f():
    k = 0
    mul = col*row
    while(len(stack)!=0):
        pair = stack[len(stack)-1]
        stack.pop(len(stack)-1)
        k = k + 1 
        r = pair[0]
        c = pair[1]
        if (isSafe(r,c+1,visited)==True and maze[r][c+1] =='L'):
            stack.append((r,c+1))
            visited[r][c+1] = 1 
        if (isSafe(r,c-1,visited)==True and maze[r][c-1] =='R'):
            stack.append((r,c-1))
            visited[r][c-1] = 1 
        if (isSafe(r+1,c,visited)==True and maze[r+1][c] =='U'):
            stack.append((r+1,c))
            visited[r+1][c] = 1
        if (isSafe(r-1,c,visited)==True and maze[r-1][c] =='D'):
            stack.append((r-1,c))
            visited[r-1][c] = 1 
    return mul-k
    
print(maze_f())        