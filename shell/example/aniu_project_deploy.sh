#!/bin/bash
##################################################################################################
#    Aniu api service deploy
#
#    Description:
#    - deploy all api 
#    - deploy all admin
#    - deploy product-api,product-service
##################################################################################################
#
#    CHANGELOG
#
#    History
#    2016-12-14      wanghui     First version release for testing
#    2016-12-30      wanghui     add remote exceute script
##################################################################################################

version_num=2016-12-12

##################################################################################################
#       set variable
##################################################################################################
Date=/bin/date
Date_Format="date +%F_%T"
Old_Project=/data/svn
New_Project=/data/svn/aniu-project
Crm_Project=/data/svn/v2.0

#

##################################################################################################
#   Old Project: mvn clean package -Dmaven.test.skip=true -q
##################################################################################################
#
jar() {
  echo "******  Begin deploy dependency jar. ******"
  #mvn_cmd=`mvn clean deploy -q`

  cd $Old_Project/tysx-mms-base && svn up && mvn clean deploy -q
  if [ $? -eq 0 ];
    then
      echo "################################################"
      echo "#-- Dependency tysx-mms-base deploy succeed! --#"
      echo "################################################"
      cd $Old_Project/tysx-mms-db && svn up && mvn clean deploy -q
      if [ $? -eq 0 ];
        then
        echo "##############################################"
        echo "#-- Dependency tysx-mms-db deploy succeed! --#"
        echo "##############################################"
        cd $Old_Project/tysx-mms-service && svn up && mvn clean deploy -q
        if [ $? -eq 0 ];
          then
            echo "###################################################"
            echo "#-- Dependency tysx-mms-service deploy succeed! --#"
            echo "###################################################"
          else
            echo "###################################################"
            echo "#-- Dependency tysx-mms-service deploy failed! --#"
            echo "###################################################"
            exit 0
        fi
        else
        echo "##############################################"
        echo "#-- Dependency tysx-mms-db deploy failed! --#"
        echo "##############################################"
        exit 0
      fi
    else
    echo "################################################"
    echo "#-- Dependency tysx-mms-base deploy failed! --#"
    echo "################################################"
    exit 0
  fi
}

#################################################################################################
# Old project: aniu api deploy 
#################################################################################################

api() {
  echo "******  Use jar for deploy aniu-api.  *******"
  #mvn_cmd=`mvn clean package -Dmaven.test.skip=true -q`
  jar
  if [ $? -eq 0 ];then
    cd $Old_Project/aniu-api && svn up && mvn clean package -Dmaven.test.skip=true -q
    if [ $? -eq 0 ];then
      echo "###################################"
      echo "### --  Api deploy succeed!  -- ###"
      else
      echo "###################################"
      echo "### --  Api deploy failed!  -- ###"
      exit 0
    fi
  else
   echo "##################################################"
  echo "### Can't use jar,beause deploy jar was failed! ###"
  exit 0
fi
#############################################################################################
# deploy aniu-api: 192.168.0.25, 192.168.0.35
############################################################################################
#echo "****************************************"
#echo " Remote deployment aniu-api "
#deploy_script=/data/script/deploy_api.sh
#for host in 192.168.0.25 192.168.0.35
#  do
#  echo $host
#  ssh -p54077 $host '$deploy_script'
#  if [ $? -eq 0 ];then
#       echo "***********************************************"
#       echo "***   Remote deploy aniu-api succeed!       ***"
##     else
#       echo "***********************************************"
#       echo "***   Remote deploy aniu-api failed!       ***"
# # fi
#  done
}


#################################################################################################
# Old project: aniu api deploy 
#################################################################################################

admin() {
  echo "******  Use jar for deploy aniu-admin.  *******"
  jar
  if [ $? -eq 0 ];then
    cd $Old_Project/aniu-admin && svn up && mvn clean package -Dmaven.test.skip=true -q
    if [ $? -eq 0 ];then
      echo "#####################################"
      echo "### --  Admin deploy succeed!  -- ###"
      else
      echo "#####################################"
      echo "### --  Admin deploy failed!  -- ###"
      exit 0
    fi
  else
   echo "##################################################"
   echo "### Can't use jar,beause deploy jar was failed! ###"
  exit 0
fi
}

#################################################################################################
# New project: aniu project deploy
# deploy aniu-dependency, aniu-module, aniu-core
#################################################################################################
#
kernel() {
  echo "******  Begin deploy dependency-module-core. ******"
  #mvn_cmd=`mvn clean deploy -q -Ponline`

  cd $New_Project/aniu-dependency && svn up && mvn clean deploy -q -Ponline
  if [ $? -eq 0 ];
    then
      echo "################################################"
      echo "#--      aniu-dependency deploy succeed!     --#"
      echo "################################################"
      cd $New_Project/aniu-module && svn up && mvn clean deploy -q -Ponline
      if [ $? -eq 0 ];
        then
        echo "##############################################"
        echo "#--   aniu-module deploy succeed!           --#"
        echo "##############################################"
        cd $New_Project/aniu-core && svn up && mvn clean deploy -q -Ponline
        if [ $? -eq 0 ];
          then
            echo "###################################################"
            echo "#--         aniu-core deploy succeed!           --#"
            echo "###################################################"
          else
            echo "###################################################"
            echo "#--         aniu-core deploy failed!            --#"
            echo "###################################################"
            exit 0
        fi
        else
        echo "##############################################"
        echo "#--         aniu-module deploy failed!     --#"
        echo "##############################################"
        exit 0
      fi
    else
    echo "################################################"
    echo "#--       aniu-dependency deploy failed!     --#"
    echo "################################################"
    exit 0
  fi
}


#################################################################################################
# New project: deploy niukeme api, 80,81
#################################################################################################

niukeme() {
  echo "******  Use kernel jar for deploy niukeme api  *******"
  kernel
  if [ $? -eq 0 ];then
    cd $New_Project/aniu-api-product_nkm && svn up && mvn clean deploy -q -Ponline
    if [ $? -eq 0 ];then
      echo "#####################################################"
      echo "### --  aniu-api-product_nkm deploy succeed!  -- ###"
      else
      echo "#####################################################"
      echo "### --  aniu-api-product_nkm deploy failed!  -- ###"
      exit 0
    fi
  else
   echo "##########################################################"
   echo "### Can't use kernel jar,beause kernel jar was failed! ###"
  exit 0
fi
}

#################################################################################################
# New project: deploy niukeme api task, 78-8083
#################################################################################################

niukeme_task() {
  echo "******  Use kernel jar for deploy niukeme api task *******"
  kernel
  if [ $? -eq 0 ];then
    cd $New_Project/aniu-api-product_nkm_task && svn up && mvn clean deploy -q -Ponline
    if [ $? -eq 0 ];then
      echo "#####################################################"
      echo "### --  aniu-api-product_nkm_task deploy succeed!  -- ###"
      else
      echo "#####################################################"
      echo "### --  aniu-api-product_nkm_task deploy failed!  -- ###"
      exit 0
    fi
  else
   echo "##########################################################"
   echo "### Can't use kernel jar,beause kernel jar was failed! ###"
  exit 0
fi
}

#################################################################################################
# New project: aniu crm project dependency
#################################################################################################
#
crm(){
  echo "******  begin deploy crm dependency"
  cd $Crm_Project/aniu-crm-dependency && svn up && mvn clean deploy -Ponline -q
  if [ $? -eq 0 ];then 
      echo "###  aniu-crm-dependency deploy succeed! ###"
    else 
      echo "###  aniu-crm-dependency deploy failed! ###"
      exit 0
  fi
#
  cd $Crm_Project/aniu-crm-module && svn up && mvn clean deploy -Ponline -q
  if [ $? -eq 0 ];then 
      echo "###  aniu-crm-dependency deploy succeed! ###"
    else 
      echo "###  aniu-crm-dependency deploy failed! ###"
      exit 0
  fi
#
  cd $Crm_Project/aniu-crm-dao && svn up && mvn clean deploy -Ponline -q
  if [ $? -eq 0 ];then 
      echo "###  aniu-crm-dependency deploy succeed! ###"
    else 
      echo "###  aniu-crm-dependency deploy failed! ###"
      exit 0
  fi
#
  cd $Crm_Project/aniu-crm-service && svn up && mvn clean deploy -Ponline -q
  if [ $? -eq 0 ];then 
      echo "###  aniu-crm-dependency deploy succeed! ###"
    else 
      echo "###  aniu-crm-dependency deploy failed! ###"
      exit 0
  fi
#
  cd $Crm_Project/aniu-crm-core && svn up && mvn clean deploy -Ponline -q 
  if [ $? -eq 0 ];then 
      echo "###  aniu-crm-dependency deploy succeed! ###"
    else 
      echo "###  aniu-crm-dependency deploy failed! ###"
      exit 0
  fi
}

#################################################################################################
# New project: deploy aniu crm admin,8-8100
#################################################################################################

crm_admin() {
  echo "******  Use crm dependency for deploy aniu crm admin *******"
  crm
  if [ $? -eq 0 ];then
    cd $Crm_Project/aniu-crm-admin && svn up && mvn clean deploy -q -Ponline
    if [ $? -eq 0 ];then
      echo "#####################################################"
      echo "### --  aniu-crm-admin deploy succeed!  -- ###"
      else
      echo "#####################################################"
      echo "### --  aniu-crm-admin deploy failed!  -- ###"
      exit 0
    fi
  else
   echo "##############################################################"
   echo "### Can't use crm dependency,beause kernel jar was failed! ###"
  exit 0
fi
}



#################################################################################################
# New project: deploy aniu crm api, 65-8083, 73-8081
#################################################################################################

crm_api() {
  echo "******  Use crm dependency for deploy aniu crm admin *******"
  crm
  if [ $? -eq 0 ];then
    cd $Crm_Project/aniu-crm-api && svn up && mvn clean deploy -q -Ponline
    if [ $? -eq 0 ];then
      echo "#####################################################"
      echo "### --  aniu-crm-api deploy succeed!  -- ###"
      else
      echo "#####################################################"
      echo "### --  aniu-crm-api deploy failed!  -- ###"
      exit 0
    fi
  else
   echo "##############################################################"
   echo "### Can't use crm dependency,beause kernel jar was failed! ###"
  exit 0
fi
}

#################################################################################################
# New project: deploy aniu-message-channel api, 38-8082, 40-8082
#################################################################################################

message() {
  echo "******  Use kernel jar for deploy message api  *******"
  kernel
  if [ $? -eq 0 ];then
    cd $New_Project/aniu-message-channel && svn up && mvn clean deploy -q -Ponline
    if [ $? -eq 0 ];then
      echo "#####################################################"
      echo "### --  aniu-message-channel deploy succeed!  -- ###"
      else
      echo "#####################################################"
      echo "### --  aniu-message-channel deploy failed!  -- ###"
      exit 0
    fi
  else
   echo "##########################################################"
   echo "### Can't use kernel jar,beause kernel jar was failed! ###"
  exit 0
fi
}


#################################################################################################
# New project: deploy stock api, 80,81
#################################################################################################

stock() {
  echo "******  Use kernel jar for deploy stock api  *******"
  kernel
  if [ $? -eq 0 ];then
    cd $New_Project/aniu-api-stock && svn up && mvn clean deploy -q -Ponline
    if [ $? -eq 0 ];then
      echo "#####################################################"
      echo "### --  aniu-api-stock deploy succeed!  -- ###"
      else
      echo "#####################################################"
      echo "### --  aniu-api-stock deploy failed!  -- ###"
      exit 0
    fi
  else
   echo "##########################################################"
   echo "### Can't use kernel jar,beause kernel jar was failed! ###"
  exit 0
fi
}

#################################################################################################
# New project: deploy vcms api, 78-8081,8082, 65-8082
#################################################################################################

vcms() {
  echo "******  Use kernel jar for deploy niukeme api  *******"
  kernel
  if [ $? -eq 0 ];then
    cd $New_Project/aniu-vcms-api && svn up && mvn clean deploy -q -Ponline
    if [ $? -eq 0 ];then
      echo "#####################################################"
      echo "### --  aniu-vcms-api deploy succeed!  -- ###"
      else
      echo "#####################################################"
      echo "### --  aniu-vcms-api deploy failed!  -- ###"
      exit 0
    fi
  else
   echo "##########################################################"
   echo "### Can't use kernel jar,beause kernel jar was failed! ###"
  exit 0
fi
}

#################################################################################################
# New project: deploy aniu-vcms-synch,  65-8081
#################################################################################################

vcms_synch() {
  echo "******  Use kernel jar for deploy aniu-vcms-synch  *******"
  kernel
  if [ $? -eq 0 ];then
    cd $New_Project/aniu-vcms-synch && svn up && mvn clean deploy -q -Ponline
    if [ $? -eq 0 ];then
      echo "#####################################################"
      echo "### --  aniu-vcms-synch deploy succeed!  -- ###"
      else
      echo "#####################################################"
      echo "### --  aniu-vcms-synch deploy failed!  -- ###"
      exit 0
    fi
  else
   echo "##########################################################"
   echo "### Can't use kernel jar,beause kernel jar was failed! ###"
  exit 0
fi
}

#################################################################################################
# New project: deploy aniu product dependency, 15,34 
#################################################################################################
#
product(){
  echo "******  begin deploy aniu product dependency  ******"
  cd $New_Project/aniu-dependency && svn up && mvn clean deploy -Ponline -q
  if [ $? -eq 0 ];then 
      echo "###  aniu-dependency deploy succeed! ###"
    else 
      echo "###  aniu-dependency deploy failed! ###"
      exit 0
  fi
#
  cd $New_Project/aniu-module && svn up && mvn clean deploy -Ponline -q
  if [ $? -eq 0 ];then 
      echo "###  aniu-module deploy succeed! ###"
    else 
      echo "###  aniu-module deploy failed! ###"
      exit 0
  fi
#
  cd $New_Project/aniu-product-dao && svn up && mvn clean deploy -Ponline -q
  if [ $? -eq 0 ];then 
      echo "###  aniu-product-dao deploy succeed! ###"
    else 
      echo "###  aniu-product-dao deploy failed! ###"
      exit 0
  fi
#
  cd $New_Project/aniu-product-service && svn up && mvn clean deploy -Ponline -q
  if [ $? -eq 0 ];then 
      echo "###  aniu-product-service deploy succeed! ###"
    else 
      echo "###  aniu-product-service deploy failed! ###"
      exit 0
  fi
#
  cd $New_Project/aniu-product-core && svn up && mvn clean deploy -Ponline -q 
  if [ $? -eq 0 ];then 
      echo "###  aniu-product-core deploy succeed! ###"
    else 
      echo "###  aniu-product-core deploy failed! ###"
      exit 0
  fi
}

#################################################################################################
# New project: deploy aniu-vcms-admin,  8-8092
#################################################################################################

vcms_admin() {
  echo "******  Use kernel jar for deploy vcms admin  *******"
  kernel
  if [ $? -eq 0 ];then
    cd $New_Project/aniu-vcms-admin && svn up && mvn clean deploy -q -Ponline
    if [ $? -eq 0 ];then
      echo "#####################################################"
      echo "### --  aniu-vcms-admin deploy succeed!  -- ###"
      else
      echo "#####################################################"
      echo "### --  aniu-vcms-admin deploy failed!  -- ###"
      exit 0
    fi
  else
   echo "##########################################################"
   echo "### Can't use kernel jar,beause kernel jar was failed! ###"
  exit 0
fi
}

#################################################################################################
# New project: deploy aniu-api-product,  15,34
#################################################################################################

product_api() {
  echo "******  Use product dependency for deploy aniu-service-product  *******"
  product
  if [ $? -eq 0 ];then
    cd $New_Project/aniu-api-product && svn up && mvn clean deploy -q -Ponline
    if [ $? -eq 0 ];then
      echo "#####################################################"
      echo "### --  aniu-api-product deploy succeed!  -- ########"
      else
      echo "#####################################################"
      echo "### --  aniu-api-product deploy failed!  -- #########"
      exit 0
    fi
  else
   echo "#########################################################################"
   echo "### Can't use kernel jar,beause deploy product dependency was failed! ###"
  exit 0
fi
}


#################################################################################################
# New project: deploy aniu-service-product,  8-8091
#################################################################################################

product_service() {
  echo "******  Use product dependency for deploy aniu-service-product  *******"
  product
  if [ $? -eq 0 ];then
    cd $New_Project/aniu-service-product && svn up && mvn clean deploy -q -Ponline
    if [ $? -eq 0 ];then
      echo "#####################################################"
      echo "### --  aniu-service-product deploy succeed!  -- ###"
      else
      echo "#####################################################"
      echo "### --  aniu-service-product deploy failed!  -- ###"
      exit 0
    fi
  else
   echo "##########################################################"
   echo "### Can't use kernel jar,beause kernel jar was failed! ###"
  exit 0
fi
}

#################################################################################################
# Old project: aniu mmadmin deploy 
#################################################################################################

mmadmin() {
  echo "******  Use jar for deploy aniu-mmsadmin.  *******"
  jar
  if [ $? -eq 0 ];then
    cd $Old_Project/tysx-mms-admin && svn up && mvn clean package -Dmaven.test.skip=true -q
    if [ $? -eq 0 ];then
      echo "#############################################"
      echo "### --  aniu-mmsadmin deploy succeed!  -- ###"
      esle
      echo "#############################################"
      echo "### --  aniu-mmsadmin deploy failed!  -- ###"
      exit 0
    fi
  esle
   echo "##################################################"
   echo "### Can't use jar,beause deploy jar was failed! ###"
  exit 0
fi
}

#################################################################################################
# Old project: aniu-admin-icntv deploy 
#################################################################################################

admin_icntv() {
  echo "******  Use jar for deploy aniu-admin-icntv.  *******"
  jar
  if [ $? -eq 0 ];then
    cd $Old_Project/aniu-admin-icntv && svn up && mvn clean package -Dmaven.test.skip=true -q
    if [ $? -eq 0 ];then
      echo "#############################################"
      echo "### --  aniu-admin-icntv deploy succeed!  -- ###"
      esle
      echo "#############################################"
      echo "### --  aniu-admin-icntv deploy failed!  -- ###"
      exit 0
    fi
  esle
   echo "##################################################"
   echo "### Can't use jar,beause deploy jar was failed! ###"
  exit 0
fi
}

#################################################################################################
# New project: aniu-admin-icntv deploy 
#################################################################################################

aniu_pay() {
    echo "***  deploy aniou pay jar for product api  ***" 
    cd $Old_Project/aniu-pay && svn up && mvn clean deploy -q
    if [ $? -eq 0 ];then
      echo "#############################################"
      echo "### --  aniu-pay deploy succeed!  -- ###"
      esle
      echo "#############################################"
      echo "### --  aniu-pay deploy failed!  -- ###"
      exit 0
    fi
}


#################################################################################################
# Script common functions
#################################################################################################

help() {
  print_version
  printf "Usage: %s: [-j] [-i] [-a] [-h] [-k] [-m] [-t] [-c] [-C] [-I] [-M] [-s] [-v] [-V] [-S] [-p] args" $(basename $0)
  printf "\n
  -h -- display help (this page)
  -j -- deploy tysx-jar
  -i -- deploy aniu-api
  -a -- deploy aniu-admin
  -k -- deploy aniu kernel jar
  -m -- deploy niukeme api
  -t -- deploy niukeme api task 
  -c -- deploy aniu crm dependency 
  -C -- deploy aniu crm admin
  -I -- deplou aniu crm api 
  -M -- deploy aniu message api
  -s -- deploy aniu stock api
  -v -- deploy aniu vcms api
  -V -- deploy aniu vcms synch 
  -p -- deploy aniu product dependency jar
  -S -- deploy aniu vcms admin
  -P -- deploy aniu product api
  -w -- deploy aniu product service
  -A -- deploy aniu mmadmin
  -n -- deploy aniu admin icntv
  -y -- deploy aniu pay  \n\n"
}

# display version number
print_version() {
  printf "Version: %s\n" $version_num
}
# get options to play with and define the script behavior
get_options() {
  while getopts 'hvjiakmtcCIMsvVSpPwAny' OPTION;
  do
    case "$OPTION" in
      h)    help
                exit 0
                ;;
      v)    print_version
                exit 0
                ;;
      j)    jar
                exit 0
                ;;
      i)    api
                exit 0
                ;;
      a)    admin
                exit 0
                ;;
      k)    kernel
                exit 0
                ;;
      m)    niukeme
                exit 0
                ;;
      t)    niukeme_task
                exit 0
                ;;
      c)    crm
              exit 0
                ;;
      C)    crm_admin
              exit 0
                ;;
      I)    crm_api
              exit 0
                ;;
      M)    message
                exit 0
                ;;
      s)    stock
                exit 0
                ;;
      v)    vcms
              exit 0
                ;;
      V)    vcms_synch
              exit 0
                ;;
      S)    aniu-vcms-admin
              exit 0
                ;;
      p)    product
              exit 0
               ;;
      P)    product_api
              exit 0
                ;;
      w)    product_service
              exit 0
                ;;
      A)    mmadmin
             exit 0
                ;;
      n)    admin_icntv
              exit 0
                ;;
      y)    aniu_pay
              exit 0
                ;;
      ?)    help >&2
              exit 2
               ;;
    esac
    # if a parameter entered by the user is '-'
    if [ -z "$OPTION" ]; then
    echo -e "$RED ERROR: Invalid option entered $NO_COLOR" >&2
      help >&2
      exit 2
    fi
  done
}

# check that at least one parameter has been added when lauching the script
if [ -z "$@" ]; then
  help >&2
  exit 2
fi

parameter=`echo "$@" | awk '{print substr($0,0,1)}'`
if [ "$parameter" != "-" ]; then
  help >&2
  exit 2
fi

# get options
get_options "$@"
