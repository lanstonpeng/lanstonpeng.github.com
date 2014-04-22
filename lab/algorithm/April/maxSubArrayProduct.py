arr= [1, -2, 3, 10, -4, 7, 2, -5]
temp = [0] * len(arr)

def cal():
    for i in range(0,len(arr)):
        if i == 0 :
            temp[i] = arr[i]
        if temp[i-1] > 0 and arr[i] >0:
            temp[i] = temp[i-1] * arr[i]
        elif temp[i-1] < 0 and arr[i] < 0:
            temp[i] = temp[i-1] * arr[i]
        else:
            if temp[i-1] > arr[i]:
                temp[i] = temp[i-1]
            else:
                temp[i] = arr[i]
    print temp
cal()

