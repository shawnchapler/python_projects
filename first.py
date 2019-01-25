
# coding: utf-8

# In[41]:

#Reinitialize variable val
val=0

#Prompt User Integer
while True:
    try:
        val=int(input('Enter number: '))
    except ValueError:
        print('Please enter a number greater than zero')
        continue
    
    if val < 0:
        print('Please enter a number greater than zero')
        continue
    else:
        break

#function to calculate factorial   
def factorial(val):
    if val == 0:
        return 1
    else:
        return val * factorial(val-1)
    
print(factorial(val))    

