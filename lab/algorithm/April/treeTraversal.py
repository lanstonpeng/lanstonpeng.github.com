class TreeNode:
    def __init__(self, x):
        self.val = x
        self.left = None
        self.right = None

class Solution:
    def preOrderRecursive(self,root,curDepth,maxDepth):
        if root:
            #print root.val
            curDepth = curDepth + 1
            maxDepth = max(maxDepth,curDepth)
            self.preOrderRecursive(root.left,curDepth,maxDepth)
            self.preOrderRecursive(root.right,curDepth,maxDepth)
            print maxDepth
    def inOrderRecursive(self,root):
        if root:
            self.inOrderRecursive(root.left)
            print root.val
            self.inOrderRecursive(root.right)
            return
    def postOrderRecursive(self,root):
        if root:
            self.postOrderRecursive(root.left)
            self.postOrderRecursive(root.right)
            print root.val
            return
    def preOrderNonRecursive1(self,root):
        stack = []
        stack.append(root)
        while len(stack) != 0:
            cur = stack.pop()
            print cur.val
            if cur.right:
                stack.append(cur.right)
            if cur.left:
                stack.append(cur.left)
    def preOrderNonRecursive2(self,root):
        stack = []
        cur = root
        stack.append(root)
        while len(stack) != 0:
            while cur:
                print cur.val
                stack.append(cur)
                cur = cur.left
            cur = stack.pop()
            cur = cur.right
    def inOrderNonRecursive1(self,root):
        stack = []
        cur = root
        while len(stack) != 0 or cur:
            while cur:
                stack.append(cur)
                cur = cur.left
            cur = stack.pop()
            if cur:
                print cur.val
            cur = cur.right

    def postOrderNonRecursive1(self,root):
        stack = []
        cur = root
        while len(stack) != 0 or cur:
            while cur:
                stack.append(cur)
                cur = cur.left
            cur = stack.pop()
            cur = cur.right




root = TreeNode(0)
node1 = TreeNode(1)
node2 = TreeNode(2)
node3 = TreeNode(3)
node4 = TreeNode(4)

root.left = node1
node1.left = node2
node2.right = node3
root.right = node4

s = Solution()
s.postOrderNonRecursive1(root)


#s.preOrderNonRecursive2(root)
#s.preOrderRecursive(root,0,1)
#s.inOrderRecursive(root)
#s.postOrderRecursive(root)

