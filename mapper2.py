#!/usr/bin/env python3

import sys
import re

def main(argv):
        line=sys.stdin.readline()
        pattern=re.compile(r"")
        while line:
          line=line.strip('\r\n')
          #split line into variables.  Used in defining output
          key,friends=line.split(':')    
  	  #strip trailing space  from keys
          key=key.rstrip()
          #strip leading zeros from friends
          friends=friends.strip()
          #output first line for person      
          print(key+'\t'+key+":"+friends)
          #Iterate through friends 
          for number in friends.split(): 
            print(number+'\t'+key+":"+friends)
          line=sys.stdin.readline()

if __name__== "__main__":
   main(sys.argv)    

        


