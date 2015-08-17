#!/bin/bash
# set -x

repo=$1
branch=$2

# If the temp folder doens't exist, create it
if [ ! -d temp ]; then
   mkdir temp
fi

echo $repo
echo $branch

# First, get the zip file
cd temp && wget -O file.zip -q https://github.com/$repo/archive/$branch.zip

# Second, unzip it, if the zip file exists
if [ -f file.zip ]; then
    # Unzip the zip file
    unzip -q file.zip

    # Name
    index=$(expr index "$repo" "/")
    echo "index $index"
    subString=${repo:$index}
    echo "substring $subString"
    mv "$subString-$branch" app
    #mv NodeAutoDeploy-deploy-production app

    # Delete zip file
    rm file.zip

    # Delete current directory
    rm -rf ../app || true

    # Rename project directory to desired name
    mv app/ ../app

    # Replace with new files
    #mv somesite.com /var/www/

    # Perhaps call any other scripts you need to rebuild assets here
    # or set owner/permissions
    # or confirm that the old site was replaced correctly
    cd ../app && /opt/node/bin/npm install
    /opt/node/bin/pm2 delete app || true
    /opt/node/bin/pm2 start app.js --name app
fi
