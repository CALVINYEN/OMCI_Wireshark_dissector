#!/bin/bash

#Converst OMCI debug log file to wireshark .pcap file
 
#1. dos2unix
dos2unix $1
 
#2. Filter OMCI Hex
cat $1 | \
#| grep '[[:xdigit:]] [[:xdigit:]][[:xdigit:]]$' |grep '^ [[:xdigit:]][[:xdigit:]] [[:xdigit:]]'| \
 
#3. Reorganize Raw data to hexdump type
 #-- Merge OMCI line to one
#sed 'N;N;s/\n//g'| \
 #-- Insert OMCI Head for pcap 
sed 's/^/00 00 00 00 00 01 00 00 00 00 00 02 88 b5 /i'| \
 #-- Out put hexdump type format 
awk '{
	for(i=0;i<=NF;i++){
		if((i%16 ==0)) printf "\n%03x0 ",(i/16);
        	printf "%s ",$(i+1);
	}
	print "\n"
}' > temp.txt
 
#4. converst to .pcap
text2pcap temp.txt $1.pcap -q
rm temp.txt
echo "Done..."
