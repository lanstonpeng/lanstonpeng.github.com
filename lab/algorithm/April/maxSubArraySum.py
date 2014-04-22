arr= [1, -2, 3, 10, -4, 7, 2, -5]
temp = [0] * len(arr)

def cal():
    for i in range(0,len(arr)):
        if i == 0 or temp[i-1] <= 0:
            temp[i] = arr[i]
        elif i!=0 and temp[i-1] >0:
            temp[i] = temp[i-1] + arr[i]
    print temp
cal()

