class Solution:
    def combine(self,n,k):
        result = []
        path = []
        self.func(1,0,n,k,result,path)
        return result
    def func(self,start,curcount,n,k,result,path):
        if curcount == k:
            result.append(list(path));
            return
        for i in range(start,n+1):
            path.append(i)
            self.func(i + 1, curcount + 1,n,k,result,path)
            path.pop()

s = Solution()
print s.combine(4,2)

