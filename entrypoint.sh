#!/bin/bash

# Namespacing input arguments given by the user
EMAIL=$1
PASSWORD=$2
API_KEY=$3
CF_API_ENDPOINT=$4
MANIFEST_FILE_PATH=$5
ORG=$6
SPACE=$7

# Converting the absolute path of the manifest.yml to relative path
[[ $MANIFEST_FILE_PATH == ./* ]] || MANIFEST_FILE_PATH=./$MANIFEST_FILE_PATH

ROOT_PATH=$(dirname $MANIFEST_FILE_PATH)

echo "Performing Checks"

# Checking if Manifest File exists at the given location
if [[ ! -f $MANIFEST_FILE_PATH ]]
then
    echo "manifest.yml doesn't exist at $MANIFEST_FILE_PATH"
    echo "Exiting"
    exit 125
fi

# Checking if ORG env variable is non empty
if [[ -z $ORG ]]
then
    echo "ORG Name not passed"
    echo "Exiting"
    exit 125
fi

# Checking if SPACE env variable is non empty
if [[ -z $SPACE ]]
then
    echo "SPACE Name not passed"
    echo "Exiting"
    exit 125
fi


# Checking if API_KEY or EMAIL & PASSWORD is provided
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

# Checking CF_API_ENDPOINT is not NULL
if [[ -z $CF_API_ENDPOINT ]]
then
    echo "No cloud foundry API Endpoint found"
    echo "Exiting"
    exit 125
fi

echo "Initial Checks Successful"

echo "Installing ibmcloud"
# Downloading IBMcloud CLI
curl -fsSL https://clis.cloud.ibm.com/install/linux | sh > /dev/null

echo "Installing cloud foundry"
# Installing cloud foundry CLI
ibmcloud cf install -q

echo "Authenticating"

# Authenticating with given cred
{
    if [[ -z $API_KEY ]]; 
    then
        ibmcloud login -u $EMAIL -p $PASSWORD --no-region -q > /dev/null
    else
        ibmcloud login --apikey $API_KEY --no-region -q > /dev/null
    fi
} || {
    echo "Wrong Auth Credentials"
    exit 1
}
echo "Auth Success"

# Adding other metadata like CF_API_ENDPOINT, org name and space
{
    ibmcloud target --cf-api $CF_API_ENDPOINT -o $ORG -s $SPACE -q > /dev/null
} || {
    echo "Wrong CF_API_ENDPOINT or ORG or SPACE Credentials"
    exit 1
}

# Changing the working dir to the manifest.yml directory
cd $ROOT_PATH

# Pushing all files and starting deployment process
{
    echo "Starting deployment"
    ibmcloud cf push > /dev/null
} || {
    echo "Deployment Failed"
    exit 1
}

# Deployment Successful
echo "Deployment Success"
