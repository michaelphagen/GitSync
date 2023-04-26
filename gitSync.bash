#!/bin/bash

# This script is used to sync all github repos for a user with a local folder
# It will clone all repos that are not present locally and pull all repos that are present locally

# the script is called with flags -f, -u, -p, -f, and -s for folder, user, personalToken, and starred repos
# if no flags are passed, the script will throw an error

#get the flags and the variables
while getopts f:u:p:s flag
do
    case "${flag}" in
        f) localFolder=${OPTARG};;
        u) user=${OPTARG};;
        p) personalToken=${OPTARG};;
        s) starred=TRUE ;;
        *) echo "Usage: $0 [-f localFolder] [-u user] [-p privateKey] [-s starred]" >&2
           exit 1 ;;
    esac
done

getLists() {
    #if personalToken is specified, use it
    if [ "$#" -gt  2 ]; then
        curl -sH "Authorization: token $3" "https://api.github.com/search/repositories?q=user:$1" | grep "html_url" | grep "/$1/"| sed -e "s/\"html_url\": \"https:\/\//https:\/\/$3@/" -e 's/",//' -e 's/^ *//g'
    else
        curl -s "https://api.github.com/users/$1/repos" | awk '/^ {4}"html_url"/&&$0=$4' FS='"'
    fi
    if [ "$2" = TRUE ]; then
        curl -s "https://api.github.com/users/$1/starred" | awk '/^ {4}"html_url"/&&$0=$4' FS='"'
    fi
}

syncRepos(){
# Loop through the list and clone or pull each repo into folders by username/repoName
while read -r line; do
  repoOwner=$(echo "$line" | awk -F/ '{print $(NF-1)}')
  repoName=$(echo "$line" | awk -F/ '{print $NF}')
  if [ ! -d "$repoOwner" ]; then
    mkdir "$repoOwner"
  fi
  if [ ! -d "$repoOwner/$repoName" ]; then
    echo "Cloning $repoName"
    git clone "$line" "$repoOwner/$repoName"
  else
    cd "$repoOwner/$repoName" || exit
    echo "Pulling $repoName"
    git pull
    cd "$localFolder" || exit
  fi
done <<< "$1"
}

main() {
  if [ "$#" -gt  2 ]; then
  list=$(getLists "$1" "$2" "$3")
  echo "$list is list"
  syncRepos "$list"
  else
  list=$(getLists "$1" "$2")
  syncRepos "$list"
  fi
}

#if localfolder doesn't exist, create it
if [ ! -d "$localFolder" ]; then
  mkdir "$localFolder"
fi
cd "$localFolder" || exit

# IF user contains commas, split it into an array and loop through it
if [[ "$user" == *,* ]]; then
  # if personalToken was specified
    if [ -n "$personalToken" ]; then
        if [[ "$personalToken" == *,* ]]; then
            IFS=',' read -r -a tokens <<< "$personalToken"
            IFS=',' read -r -a users <<< "$user"
            for i in "${!users[@]}"; do
                cd "$localFolder" || exit
                main "${users[i]}" "$starred" "${tokens[i]}"
            done
            exit
        else
            # Throw error, personalToken must be comma separated if user is comma separated
            echo "If user is comma separated, personalToken must be comma separated"
            echo "Usage: $0 [-f localFolder] [-u user] [-p privateKey] [-s starred]" >&2
        fi
    else
    IFS=',' read -r -a users <<< "$user"
    for i in "${users[@]}"; do
        cd "$localFolder" || exit
        main "$i" "$starred"
    done
    exit
    fi
else
  if [ -n "$personalToken" ]; then
    main "$user" "$starred" "$personalToken"
    exit
  else
    main "$user" "$starred"
  fi
  exit
fi