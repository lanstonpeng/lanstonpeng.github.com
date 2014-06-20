//
//  checknum.h
//  LineSum
//
//  Created by Sun Xi on 5/7/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#ifndef __LineSum__checknum__
#define __LineSum__checknum__

#include <stack>
#include <iostream>

void check(int** num, int n, int i, int j, std::stack< std::pair<std::pair<int, int>, int> >& numStack);

#endif /* defined(__LineSum__checknum__) */
