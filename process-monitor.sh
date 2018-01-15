#!/bin/bash
echo "`date`"
echo "Start $0--------------------------------------------"
echo ""
sec=10
read -p "Process:" processString
if [ $? -eq 0 ]; then 
    eval $(ps -aux | grep $processString | grep -v grep | awk {'printf("memPercent=%s;CPUPercent=%s;PSS=%s;VSS=%s;myStatus=%s;pName=%s",$4,$3,$5/1024,$6/1024,$8,$11)'})
    #echo Name:$pName Status:$myStatus MPer:$memPercent CPUP:$CPUPercent PSS:$PSS:MB VSS:$VSS:MB
    testPrg=""
    while [ -n "$pName" -a "$myStatus" != "Z" ]
    do
        #echo"--------------------`date`--------------------"
        echo Name:$pName Status:$myStatus MPer:$memPercent CPUP:$CPUPercent PSS:$PSS:MB VSS:$VSS:MB\
        "-----"`date`"------"
        sleep $sec
        pName=""
        myStatus=""
        PSS=""
        VSS=""
        memPercent=""
        CPUPercent=""
        eval $(ps -aux | grep $processString | grep -v grep | awk {'printf("memPercent=%s;CPUPercent=%s;PSS=%s;VSS=%s;myStatus=%s;pName=%s",$4,$3,$5/1024,$6/1024,$8,$11)'})
        testPrg=`ps | grep "process-monitor" | awk '{printf $0}'`
        if [ -z "$testPrg" ]; then
            break
        fi
        testPrg=""
    done
fi
echo "End $0---($pName,$myStatus,$testPrg)------------------"
if [ -z "$pName" ]; then
    killall process-monitor
    echo "Stop monitor program process-monitor!"
fi
echo "`date`"
echo "--------------------Current Status--------------------"
ps |grep -E $processString |grep -v grep
echo ""
