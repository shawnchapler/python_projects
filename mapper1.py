#!/usr/bin/env python3

import sys
from decimal import *
from datetime import datetime

def main(argv):
        line=sys.stdin.readline()
        getcontext().prec=8
        while line:
          #remove any unexpected carriage return or spaces in file
          line=line.strip('\r\n')
          line=line.strip()
          #split line into variables.  Using headers in file
          InvNo, StockCd, Desc, Quant, InvDt, UnitPr, Cust, Country=line.split(',')
          #look for header row           
          try:
          #look for header row
               InvNo=int(InvNo)  
               Cust=int(Cust)
               Quant=Decimal(Quant)
               UnitPr=Decimal(UnitPr)
               Sales=Quant*UnitPr 
               dt=datetime.strptime(InvDt, "%m/%d/%Y %H:%M").strftime('%m')
              # print(InvNo, StockCd, Desc, Quant, InvDt, UnitPr, Cust, Country, Sales)
               print('%s,%s\t%s:%.2f' % (dt,Country,Cust,Sales))
          except ValueError:
             pass
          
          line=sys.stdin.readline()

if __name__== "__main__":
   main(sys.argv)    

        


