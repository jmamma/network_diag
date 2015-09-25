#!/bin/bash
N=10000
LOG="pingchecker.log"
STORAGE_IP="172.26.13.115"
a=0
detect=0
function fcomp() {
    awk -v n1=$1 -v n2=$2 'BEGIN{ if (n1>n2) printf 1; else printf 0}'
}

echo "Ping Checker" > $LOG
while [ $a -lt $N ]; do
    date=$(date)
    ping=$(ping -c 1 $STORAGE_IP | tail -1| awk -F '/' '{print $5}')
    #ping=$(ping -c 1 $STORAGE_IP | grep "time=" | cut -f7 -d' ' | cut -f2 -d'=' | tr -d ' ')
    a=$(expr $a + 1)
    if [ "$(fcomp $ping .5)" == 1 ] && [ $detect -eq 0 ]; then
        N=$(expr $a + 20)
        detect=1
    fi  
    echo $date $ping | tee -a $LOG
    sleep 1;
done
cat $LOG | mail -s "Ping Checker $(hostname)" justin.mammarella@unimelb.edu.au -a "From: rc-melbourne@nectar.org.au" rc-melbourne@nectar.org.au
