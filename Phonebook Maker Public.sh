#!/bin/bash

linecount=0

#First section used to check the users in the system
curl -u user:pass "url" | sponge /filepath/here

awk -v  RS="dn" '{ print }' /filepath/here > /filepath/here

sed -e '{/Park/d;}' -e '{/"name":"admin"/d;}' -e '{/"type"/d;}' /filepath/here > /filepath/here

#Checks if anything has actually changed, if not it exits out because you don't need a new phonebook
linecount=$(sed -n '$=' /filepath/here/redirect.xml)

phonebookcount=$(sed -n '$=' /filepath/here/test.csv)

if [ "$linecount" = "$phonebookcount" ]; then exit ; fi

#Peruses the text files that all the info is stored in, sorts and refines it into useable data, converts it to a csv file
cat /filepath/here/redirect.xml | while read output; 
do 
    userid=$(echo "$output" | egrep '"id":"?"' | cut -d , -f 4 | egrep ':"?"' | cut -d : -f 2)

    username=$(echo "$output" | egrep '"name":"?"' | cut -d , -f 5 | egrep ':"?"' | cut -d : -f 2)

    userext=$(echo "$output" | egrep '"extension":"?"' | cut -d , -f 6 | egrep ':"?"' | cut -d : -f 2)

    echo "$userid,"","","$username","$userext","","","","","","","","","","","","","","","""

done > /filepath/here/test.csv

#Appending the top bit to the CSV file that Wildix seems to want/need
sed -i '1s/^/Id,Shortcut,NamePrefix,Name,Extension,Phone,Office,Mobile,Home,HomeMobile,Fax,Email,Organization,Type,Address,VatId,DocumentType,DocumentId,ImageUrl\n/' /home/test/Documents/test.csv