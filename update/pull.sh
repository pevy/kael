#!/bin/bash
#mail:*******
# 当前脚本目录
mydir=$(cd "$(dirname "$0")"; pwd)
source $mydir/conf/env.conf


#########部分参数处理#######

#########使用方法########
function usage(){
    echo -e  "\033[43;35m 使用方法如下：以下参数支持版本号\033[0m \n" 
    echo -e  "\033[43;35m ****** usage(root):$0 all  ::: 拉取所有项目的最新版本至 release 目录 \033[0m \n"
    echo -e  "\033[43;35m ******             $0 <user> [<version>] ::: 拉取指定运行用户的最新版本或指定版本\033[0m \n"
    echo -e  "\033[43;35m ****** usage(not root):$0 ::: 拉取当前用户运行程序的最新版本 \033[0m \n"
    echo -e  "\033[43;35m ******                 $0 [<verison>] ::: 拉取当前用户运行程序的指定版本\033[0m \n"

}
######root执行时#######
function root_exec(){
    user_name=$1
    version=$2
    file=$mydir/conf/users
    if [ ! -f $file ];then
        echo "*****error *****:the $file  is not exit"
        exit 3
    fi


    if [ -z "$user_name" ];then
        echo " *** error *** : the input user_name is null, exit"
        usage
        exit 200
    fi

    ## not all
    if [ "all" != "$user_name" ];then
        id $user_name >& /dev/null
        if [ $? -ne 0 ];then
            echo " *** error ***: the user[$user_name] is not exist, exit!!!"
            exit 201
        fi
        
        su - $user_name <<EOF
        /bin/sh kael/update/pull.sh $version;
EOF
    ## all
    else
        for user_name in $(cat $mydir/conf/users);do
            /bin/sh $mydir/pull.sh $user_name
        done
    fi

}


##########非root用户执行时#########
function not_root_exec(){
    service=$PROJECT_NAME
    if [ -z "$service" ];then
        echo " *** error *** service name is null, exit."
        exit 100
    fi

    version=$1
    if [ -z "$version" ];then
        version_url=$PACKAGE_STORE_URL_PREFIX/$service/version-latest
        echo "=> it will fetch the package version from url : $version_url"
        version=`curl $version_url`
        if [ -z "$version" ]; then
            echo " *** error *** version is null, exit."
            exit 101
        fi
    fi

    type_url=$PACKAGE_STORE_URL_PREFIX/$service/type
    echo "=> it will fetch the package type from url : $type_url"
    package_type=`curl $type_url`
    if [ -z "$package_type" ]; then
        package_type=jar
    fi
    
    ## download package
    package_name=$service-$version.$package_type
    echo "=> the package_name is : $package_name"
    package_url=$PACKAGE_STORE_URL_PREFIX/$service/$package_name
    echo "=> the package_url is : $package_url"
    dir=$mydir/release
    mkdir -p $dir
    wget -SO $dir/$package_name $package_url 
    find $dir/ -name "*.jar" -size 0 -exec rm -f {} \;
    find $dir/ -name "*.war" -size 0 -exec rm -f {} \;
    find $dir/ -name "*.zip" -size 0 -exec rm -f {} \;
    
    groupname=$(id -gn $(whoami))
    chown -R $(whoami).$groupname $dir

}

#########
current_user=$(whoami)
if [ $current_user = "root" ];then
   root_exec $@
else
   not_root_exec $@
fi

