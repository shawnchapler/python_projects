
# coding: utf-8

# In[37]:

#read in input.txt
data = []
with open(r'input.txt') as f:
    for line in f:
        fields = line.split()
        rowdata = map(float, fields)
        data.extend(rowdata)

print(sum(data)/len(data))

