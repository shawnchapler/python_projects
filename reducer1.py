#!/usr/bin/env python3

import sys
from decimal import *
from operator import itemgetter
from itertools import groupby

def main(argv): 
      getcontext().prec=8
      current_key=None
      current_sumsales=[]
      key=None
      salestup=() 
      sumsalestup=()
      keylist=[]
      for line in sys.stdin:
           line=line.strip()
           key,custval=line.split('\t')
           cust,sales=custval.split(':')
           salestup=cust, Decimal(sales)
           if current_key==key:
                current_sumsales.append(salestup)
           else:
              if current_key:
                 for current_cust, group in groupby(current_sumsales, itemgetter(0)):
                     current_sales=sum(Decimal(sales) for current_cust, sales in group)
                     
                     sumsalestup=current_sales, current_cust
                     keylist.append(sumsalestup)
                 maxval=max(keylist)[0] 
                 customerlist=[cust for (sale, cust) in keylist if sale == maxval]
                 print(current_key+':'+ ','.join(customerlist))
              current_key=key
              current_sumsales=[]
              current_sumsales.append(salestup)
              keylist=[]
      if current_key==key:
         for current_cust, group in groupby(current_sumsales, itemgetter(0)):
            current_sales=sum(Decimal(sales) for current_cust, sales in group)
            sumsalestup="{0:.2f}".format(current_sales), current_cust
            keylist.append(sumsalestup)
         maxval=max(keylist)[0]
         customerlist=[cust for (sale, cust) in keylist if sale == maxval]
         print(current_key+':'+ ','.join(customerlist))
if __name__=="__main__":
     main(sys.argv)
