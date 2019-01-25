#!/usr/bin/env python3


import sys
import re


def main(argv):
        line=sys.stdin.readline()
        pattern=re.compile("[A-Z]+")
        while line:
          for cust in pattern.findall(line):
              custlist=list(sorted(cust))
              print("".join(custlist)+"\t"+"1") 
          line=sys.stdin.readline()

if __name__== "__main__":
   main(sys.argv)    

