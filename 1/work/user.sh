#!/bin/bash

#1. Get user input information
echo "Please enter 1 for local connection; Please enter 2 for url file;"
read fileType

if [ -z "${fileType}" ];then
	fileType=1
fi

echo "Please enter the URL address："
read filePath

echo ${filePath}
case $fileType in
1)
    if [ -z "${filePath}" ];then
      filePath1="./users.csv"
    else
      filePath1=${filePath}
    fi
  ;;
2)
    filePath1="./users.csv"
    wget -O $filePath1 https://moodle.op.ac.nz/pluginfile.php/1656683/mod_assign/introattachment/0/users.xlsx?forcedownload=1
  ;;
esac

#2. Get file data circularly
cat $filePath1  | while read line
do
    #2.1 Get account name
    lineOne=${line}
    oneF=`expr index "$lineOne" ";"`
    usernameData=(${lineOne:0:oneF-1})
    usernameData1=(${usernameData//@/ })
    usernameData2=(${usernameData1[0]//./ })
    username=(${usernameData2[0]:0:1}${usernameData2[1]})


    #2.2 Get password
    lineTwo=(${lineOne:oneF})
    twoF=`expr index "$lineTwo" ";"`
    passwdData=(${lineTwo:0:twoF-1})
    passwdData1=(${passwdData//// })
    passwd=(${passwdData1[2]}${passwdData1[0]}${username})


    #2.3 Get group
    lineThree=(${lineTwo:twoF})
    threeF=`expr index "$lineThree" ";"`
    groupData=(${lineThree:0:threeF-1})
    if [[ -z $groupData ]];
    then
      groupData=${username}
    fi


    #2.3 Get shareFile
    lineFour=(${lineThree:threeF})
    fourF=`expr index "$lineFour" ";"`
    shareFile=(${lineFour:0:fourF-1})
    if [[ -z $shareFile ]];
    then
      shareFile=${username}
    fi


    # 3.Judge whether the shared file exists
    if [[ ! -d $shareFile ]]; then
        mkdir -p $shareFile
        echo "shareFile add $shareFile success!"
    else
        echo "shareFile  $shareFile exist!"
    fi


    # 4.Judge whether the group exists
    if [[ -z  `getent group $groupData` ]]
    then
      sudo groupadd $groupData
      echo "group add $groupData success!"
    else
     echo "group  $groupData exist!"
    fi

    # 5. Judge whether the user exists

    if id -u ${username} >/dev/null 2>&1 ;then
      echo " ${username} exists."
    else
  		sudo useradd -s /bin/bash -m $username -g $groupData
    	echo "$username:$passwd" | sudo chpasswd
  		echo "User $username's password has been changed!"
  		 `ln -s $shareFile /home/$username`
    fi

  echo
done
