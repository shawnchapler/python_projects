#!/usr/bin/env python3

import sys

current_key=None
current_contactvalues=[]
current_keyvalues=[] 
for line in sys.stdin:
    line=line.strip('\n')
    #split line into key and values
    key, val=line.split('\t')
    #split values into contact and friends
    contact, friends=val.split(':')
    friends=friends.split()
    #check for current key, add contact friends to list
    if current_key==key:
        if current_key==contact:
           current_keyvalues+=friends
           current_keyvalues.append(key)
        else:
           current_contactvalues+=friends
    else:
        if current_key:
            #filter for friends not in key list
            r=filter(lambda x : x not in current_keyvalues, current_contactvalues)
            r=list(r)
            #create lists for might 2-3, probably 4 or more  
            might=[x for x in set(r) if r.count(x) >1 and r.count(x) < 4]
            probably=[x for x in set(r) if r.count(x) >3]
            #sort output in lists
            might.sort(key=int)
            probably.sort(key=int)
            if len(might) > 0:
              mightname='Might'+'('+(','.join(might))+')'
            else:
              mightname=""
            if len(probably) > 0:
              probablyname='Probably'+'('+(','.join(probably))+')'
            else:
              probablyname=""
            print('%s:%s %s' % (current_key, mightname, probablyname))
        #initialize variables for new key
        current_contactvalues=[]       
        current_keyvalues=[]
        current_key=key
        if current_key==contact:
           current_keyvalues.append(key)
           current_keyvalues+=friends
        else:
           current_contactvalues=friends
if current_key==key:
       r=filter(lambda x : x not in current_keyvalues, current_contactvalues)
       r=list(r)
       might=[x for x in set(r) if r.count(x) > 1 and r.count(x) <4]
       might.sort(key=int)
       probably=[x for x in set(r) if r.count(x) >3]
       probably.sort(key=int)
       if len(might) > 0:
           mightname='Might'+'('+(','.join(might))+')'
       else:
           mightname=""
       if len(probably) > 0:
           probablyname='Probably'+'('+(','.join(probably))+')'
       else:
           probablyname=""
       print('%s:%s %s' % (current_key, mightname, probablyname))
