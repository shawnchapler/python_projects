
# coding: utf-8

# In[14]:

#Prompt User for Two Integers Variables & Validate they are floats to capture negatives

userinputa=input('Enter first number: ')
#while True:
try:
    userinputa=float(userinputa)

except ValueError:
    print('Please enter second number')
    pass
   
    
userinputb=input('Enter Second Number: ')
try:
    userinputb=float(userinputb)
except ValueError:
    print('Please enter a valid number')
    pass   

#Initialize Prime List and variables
primelist=[]
x=0
y=0
count=0

#Correctly assign lowest value to x and higher value to y.  Convert to integers for prime calc.
if userinputa < userinputb:
        x=int(userinputa)
        y=int(userinputb)
else:
        x=int(userinputb)
        y=int(userinputa)

#Iterate through the numbers and append to primelist with separators 
for num in range(x+1,y):
        if x < 2 and y < 2:
            print ("No Primes")
            break
        elif all(num%i!=0 for i in range(2,num)):
            if num > 1:
                count=count+1
                if count==1:
                    primelist.append(str(num))
                elif count==2:
                    primelist.append(':'+str(num))
                elif count==3:
                    primelist.append('!'+str(num))
                elif count==4:
                    primelist.append(','+str(num))
                    count=1  #reset count to start over on separator

if len(primelist)==0:
   print("No Primes")
else:
#print list joining all values in a single output line
   print("".join(primelist))


# In[ ]:




# In[ ]:



