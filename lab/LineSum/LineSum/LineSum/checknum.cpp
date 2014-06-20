//
//  checknum.cpp
//  LineSum
//
//  Created by Sun Xi on 5/7/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#include "checknum.h"
#include <map>

using namespace std;

#define MAX_NUM   (10)

bool instack(stack< pair<pair<int, int>, int> > numStack, int i, int j);

void check(int** num, int n, int i, int j, stack< pair<pair<int, int>, int> >& numStack) {
    
    static int sum = 0;
    static map<pair<int, int>, int> checkedArray;
    if (!instack(numStack, i, j)) {
        checkedArray[make_pair(i, j)] = 0;
        auto x = make_pair(make_pair(i, j), num[i][j]);
        numStack.push(x);
        printf("push: %d,%d : %d \n",x.first.first, x.first.second, x.second);
        sum += num[i][j];
    }
    // check right
    if (j + 1 < n && !instack(numStack, i, j+1) && checkedArray[make_pair(i, j)] < 1) {
        checkedArray[make_pair(i, j)] = 1;
        if (sum + num[i][j+1] < MAX_NUM) {
            return check(num, n, i, j+1, numStack);
        } else if(sum + num[i][j+1] == MAX_NUM) {
            numStack.push(make_pair(make_pair(i, j+1), num[i][j+1]));
            return;
        }
    }
    //check bottom
    if (i+1 < n && !instack(numStack, i+1, j)&& checkedArray[make_pair(i, j)] < 2) {
        checkedArray[make_pair(i, j)] = 2;
        if (sum + num[i+1][j] < MAX_NUM) {
            return check(num, n, i+1, j, numStack);
        } else if(sum + num[i+1][j] == MAX_NUM) {
            numStack.push(make_pair(make_pair(i+1, j), num[i+1][j]));
            return;
        }
    }
    //check left
    if (i-1>=0 && !instack(numStack, i-1, j) && checkedArray[make_pair(i, j)] < 3) {
        checkedArray[make_pair(i, j)] = 3;
        if (sum + num[i-1][j] < MAX_NUM) {
            return check(num, n, i-1, j, numStack);
        } else if(sum + num[i-1][j] == MAX_NUM) {
            numStack.push(make_pair(make_pair(i-1, j), num[i-1][j]));
            return;
        }
    }
    //check top
    if ( j-1>=0 && !instack(numStack, i, j-1) && checkedArray[make_pair(i, j)] < 4) {
        checkedArray[make_pair(i, j)] = 4;
        if (sum + num[i][j-1] < MAX_NUM) {
            return check(num, n, i, j-1, numStack);
        } else if(sum + num[i][j-1] == MAX_NUM) {
            numStack.push(make_pair(make_pair(i, j-1), num[i][j-1]));
            return;
        }
    }
    //pop stack
    printf("pop: %d,%d : %d\n",numStack.top().first.first, numStack.top().first.second, numStack.top().second);
    sum -= numStack.top().second;
    numStack.pop();
    if (numStack.empty()) {
        return;
    } else {
        auto top = numStack.top();
        return check(num, n, top.first.first, top.first.second, numStack);
    }
}

bool instack(stack< pair<pair<int, int>, int> > numStack, int i, int j) {
    while (!numStack.empty()) {
        auto x = numStack.top();
        if (x.first.first == i && x.first.second == j) {
            return true;
        }
        numStack.pop();
    }
    return false;
}
