#!/usr/bin/env python3

import sys

current_key = None
current_count = 0
 
for line in sys.stdin:
    line=line.rstrip()
    key,count=line.split('\t', 1)
    count=int(count)
    if current_key==key:
            current_count+=count
    else:
        if current_key:
            print('%s:%s' % (current_key, current_count))
        current_count=count
        current_key=key
if current_key==key:
       print('%s:%s' % (current_key, current_count))
           
         
      
 
    

        
     
 




