#!/bin/sh

EMAIL=$1
PASSWORD=$2
API_KEY=$3
CF_API_ENDPOINT=$4
MANIFEST_FILE_PATH=$5
ORG=$6
SPACE=$7


[[ $MANIFEST_FILE_PATH == ./* ]] || MANIFEST_FILE_PATH=./$MANIFEST_FILE_PATH

ROOT_PATH=$(dirname $MANIFEST_FILE_PATH)

echo "Performing Checks"

if [[ ! -f $MANIFEST_FILE_PATH ]]
then
    echo "manifest.yml doesn't exist at $MANIFEST_FILE_PATH"
    echo "Exiting"
    exit 125
fi


if [[ -z $ORG ]]
then
    echo "ORG Name not passed"
    echo "Exiting"
    exit 125
fi


if [[ -z $SPACE ]]
then
    echo "SPACE Name not passed"
    echo "Exiting"
    exit 125
fi



if [[ (-z $EMAIL) ||  (-z $PASSWORD) ]] && [[ -z $API_KEY ]]
then
    if [[ -z $API_KEY ]]; 
    then
        echo "No API_KEY found"
    fi
    if [[ -z $EMAIL ]]; 
    then
        echo "No Email found"
    else
        echo "Email found"
    fi
    if [[ -z $PASSWORD ]]; 
    then
        echo "No Password found"
    else
        echo "Password found"
    fi
    echo "Please provide either API_KEY or EMAIL and PASSWORD for connecting with you IBM Cloud Account"
    echo "Exiting"
    exit 125
fi

if [[ -z $CF_API_ENDPOINT ]]
then
    echo "No cloud foundry API Endpoint found"
    echo "Exiting"
    exit 125
fi

echo "Initial Checks Successful"


echo "Installing ibmcloud"
curl -fsSL https://clis.cloud.ibm.com/install/linux | sh
echo "Installing cloud foundry"
ibmcloud cf install -q

if [[ -z $API_KEY ]]; 
then
    ibmcloud login -u $EMAIL -p $PASSWORD --no-region
else
    ibmcloud login --apikey $API_KEY --no-region
fi


ibmcloud target --cf-api $CF_API_ENDPOINT -o $ORG -s $SPACE 

cd $ROOT_PATH

ibmcloud cf push

