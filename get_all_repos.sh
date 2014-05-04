#/usr/bin/sh

git_host="https://github.com"
tmp_log="tmp_repos.log"

function gitclone()
{
  username=$1
  mkdir -p $username
  #username="kkme"
  echo "----------STARTING CLONE, USERNAME : $username ----------"
  curl $git_host/$username?tab=repositories |grep href |grep $username|grep -v Stargazers |grep -v title= > $tmp_log
  num=`grep -n class=\"follow\" $tmp_log |awk -F':' '{print $1}'`
  awk -F'"' 'NR>'$num'{print $2}' tmp_repos.log |while read line; do
     echo "Starting Get " $git_host$line
     if [ -d .$line ];then 
         echo ".$line allready exist, run fetch"
         cd .$line
         git fetch
         git rebase
         cd ../..
     else
        git clone $git_host$line .$line
     fi
  done
  rm -vf $tmp_log
  echo "----------END CLONE, USERNAME : $username----------"
}


if [ $# = 0 ] ; then
  echo "Usage : ./get_all_reops.sh name1 name2 .."
else
    for i in "$@"
    do
        gitclone $i
    done
fi

