#List and Tupils  (popping)

x = [4, True, 'hi'] # this is a list
#elements in a list do not need to be of the same type
print(x)

x.append('hello')
print(x)

x.extend([4,6,8,7,6,89, 'test'])
print(x)

y = [45, 'given', 98]

print(x.pop())
#what pop basically does is it takes the last element of the list and clears it out. 

print(y.pop())
print (y)

z =['hello', 'sigma', 'alfa']
print(z.pop(1))
print (z)



m = (0,0,2,5,6)

#if yo usee bracket like [] you can change things and assign the new value ot things 
# if you see () you can not append, extend or change the value of the first assigned. 