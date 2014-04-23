'''
[1,2,3] have the following permutations:
[1,2,3], [1,3,2], [2,1,3], [2,3,1], [3,1,2], and [3,2,1].
'''

class Solution:
    def permute(self, num):
        self.temp = []
        self.result = []
        self.recur(num,0)
        return self.result
    def recur(self,num,l):
        if l == len(num):
            self.result.append(list(self.temp))
            return
        for i in range(0,len(num)):
            if num[i] not in self.temp:
                self.temp.append(num[i])
                self.recur(num,l+1)
                self.temp.pop()

s = Solution()
print s.permute([1,2,3])
