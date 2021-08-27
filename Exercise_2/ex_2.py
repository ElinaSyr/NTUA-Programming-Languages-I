from collections import deque 
import copy
import sys

# Function to convert list to string
def listToString(s): 
    
    # initialize an empty string
    str1 = " " 
    
    # return string  
    return (str1.join(str(elem) for elem in s))

# Read input file
inputFile = open(sys.argv[1])
input = inputFile.read().split('\n')[:-1]
N = int(input[0])
with open(sys.argv[1]) as f:
    input,List = [line.rstrip() for line in f]

N = int(input)
L = list((List).split(" "))
for i in range(0,len(L)):
    L[i] = int(L[i])


# Functions to mark state as visited and check if state has been visited
def visit(visited,node):
    q1 = listToString(node[0])
    s1 = listToString(node[1])
    visited.add((q1,s1))


def have_visited(visited,node):
    q1 = listToString(node[0])
    s1 = listToString(node[1])
    if (q1,s1) in visited:
        return True
    else: 
        return False


# Functions to perform Q move or S move
def Q (oldnode):
    popped_elem = oldnode[0][0]
    newq = oldnode[0][1:]
    news = oldnode[1] + [popped_elem]
    path =oldnode[2]+['Q']
    newnode = [newq,news,path]
    return newnode


def S (oldnode):
    popped_elem =oldnode[1][-1]
    newq = oldnode[0] + [popped_elem]
    news = oldnode[1][:-1]
    path = oldnode[2] + ['S']
    newnode = [newq,news,path]
    return newnode

# Create first node to add to fifo_stack (first state)
father = [L,[],[]]

#Initialize fifo stack to perform bfs
fifo_stack = deque()
fifo_stack.append(father)

# Initialize visited set to store states we have already expanded and checked
visited = set()


# Functions to check if list is sorted
def check_sort(L,len_L): 
    flag = True
    for i in range(0,len_L-1): 
        if (L[i]>L[i+1] or L[len_L - 2 -i] > L[len_L -1 -i] ):
            flag = False
            break
    return flag


def st_check():
    if (check_sort(fifo_stack[0][0],len(fifo_stack[0][0]))==True):
        return True


# Main function to run BFS
def main(fifo_stack): 
    finished = False 
    count = 0 
    #counter = 0 
    if (st_check()):
        print('empty')
        return 
    while(finished != True and not fifo_stack==deque([]) ): 
        #print(visited)
        count = count + 1
        """"
        print(count)
        print("FIFO_STACK:")
        print(fifo_stack)
        print("VISITED:")
        print(visited)
        """
        father = fifo_stack.popleft()
        """"
        print("FATHER:")
        print(father)
        print(have_visited(visited,father))
        print("\n")
        """
        if (have_visited(visited,father)):
            continue
        else:
            visit(visited,father)
            #mother1 = copy.deepcopy(father)
            #mother2 = copy.deepcopy(father)
            if (len(father[0])!= 0): 
                left_child = Q(father)

                fifo_stack.append(left_child)
                # print("THIS IS Left CHILD" + str(left_child))
                if len(left_child[1]) == 0:
                     if (check_sort(left_child[0],len(left_child[0])) ==True):
                         #print("sort ")
                        #print(left_child)
                        print (''.join(left_child[2]))
                        #print(count)
                        finished = True
                        break 

            #print("This is father" + str(father))
            if (len(father[1]) != 0 ):
                    right_child = S(father)

                #print("THIS IS RIGHT CHILD" + str(right_child))
                    fifo_stack.append(right_child)
                    if len(right_child[1]) == 0:
                        if (check_sort(right_child[0],len(right_child[0])) == True):
                            #print("sort ")
                            #print(right_child)
                            print (''.join(right_child[2]))

                            #print(count)
                            finished = True 
                            break 


main(fifo_stack)
