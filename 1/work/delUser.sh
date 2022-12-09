#!/bin/bash

filePath1="./users.csv"


cat $filePath1  | while read line
do

    lineOne=${line}
    oneF=`expr index "$lineOne" ";"`
    usernameData=(${lineOne:0:oneF-1})
    usernameData1=(${usernameData//@/ })
    usernameData2=(${usernameData1[0]//./ })
    username=(${usernameData2[0]:0:1}${usernameData2[1]})


    lineTwo=(${lineOne:oneF})
    twoF=`expr index "$lineTwo" ";"`
    passwdData=(${lineTwo:0:twoF-1})
    passwdData1=(${passwdData//// })
    passwd=(${passwdData1[2]}${passwdData1[0]}${username})


    lineThree=(${lineTwo:twoF})
    threeF=`expr index "$lineThree" ";"`
    groupData=(${lineThree:0:threeF-1})
    if [[ -z $groupData ]];
    then
      groupData=${username}
    fi

    lineFour=(${lineThree:threeF})
    fourF=`expr index "$lineFour" ";"`
    shareFile=(${lineFour:0:fourF-1})
    if [[ -z $shareFile ]];
    then
      shareFile=${username}
    fi



    if [[ -d $shareFile ]]; then
        rm -rf  $shareFile
        echo "shareFile rm $shareFile success!"
    else
        echo "shareFile  $shareFile no exist!"
    fi

    if id -u ${username} >/dev/null 2>&1 ;then
    		sudo userdel -r  $username 2>/dev/null
    		rm -rf /home/$username
    else
        echo " ${username} no exists."
    fi
done