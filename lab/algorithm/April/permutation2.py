class Solution:
    def permuteUnique(self, num):
        self.temp = []
        self.result = []
        self.position = {}
        self.recur(num,0)
        return self.result
    def recur(self,num,count):
        if count == len(num):
            self.result.append(list(self.temp))
            return
        for i in range(0,len(num)):
            if i not in self.position :
                self.position[i] = 1
                self.temp.append(num[i])
                self.recur(num,count+1)
                self.temp.pop()
                self.position.pop(i)
s = Solution()
print s.permuteUnique([-1,2,-1,2,1,-1,2,1])
#print s.permuteUnique([-1,2,-1,1])

