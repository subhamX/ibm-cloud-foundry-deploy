# IBM Cloud Foundry Deploy

A github action which allows developers to automate the deploy 🚀 process to `IBM cloud foundry`. 

### What is Cloud Foundry?
> Cloud Foundry is the industry-standard open source cloud application platform for developing and deploying enterprise cloud applications. Get started today!

For more information on IBM cloud foundry, please visit [here](https://www.ibm.com/cloud/cloud-foundry).


## Pre-requisites
* You need to have an IBM Cloud account and a cloud foundry instance.
* You can create a free IBM Cloud account [here](https://cloud.ibm.com/) and create a new cloud foundry instance [here](https://cloud.ibm.com/catalog/starters/cloud-foundry).
 
## Checklist 

* This action allows you to deploy applications built on runtimes of **Java**, **Node.js**, **PHP**, **Python**, **Ruby**, **ASP.NET**, **Tomcat**, **Swift** and **Go** to Cloud Foundry. 
  You need to define your deployment details like number of application instances to create, the amount of memory and disk quota to allocate, and other environment variables in the `manifest.yml` file. For more information on App Manifests head over to these links. [one](https://docs.cloudfoundry.org/devguide/deploy-apps/manifest.html) and [two](https://cloud.ibm.com/docs/cloud-foundry?topic=cloud-foundry-deploy_apps).
* We recommend using `.cfignore` and adding `.git/`, and other files, directories which you would like to ignore during the deployment.


## Authentication

We need access to your account to be able to deploy the application. Currently, we support two types of authentication. You can choose any one of the following based on your preference.
1. Authentication using API KEY (Recommended)
2. Authentication using Email & Password

To generate a new **API KEY**, head over to [this link](https://cloud.ibm.com/iam/apikeys) and click on **Create an IBM Cloud API key**. Give the API KEY a name like `gh-cf-deploy` and click on `Create` button.

Now copy the API KEY and make sure you store it safely. Please note that you won't be able to see this API key again, so you can't retrieve it later. 

**Voila!** You have successfully generated the API KEY, and now you need to add it into GitHub secrets. 👏👏

## Adding Credentials and other things as Secrets in GitHub 
1. Navigate to your repo.
2. Click on Settings and navigate to the "Secrets" tab.
3. Now, add the `CF_API_ENDPOINT` in Name, and the API endpoint in the `Value`. 
    Here is a small table which maps the Public CF Endpoint to the region.

    | Region | CF API Endpoint|
    | ----------|--------------|
    | public CF us-south | [https://api.us-south.cf.cloud.ibm.com](https://api.us-south.cf.cloud.ibm.com)|
    | public CF eu-de | [https://api.eu-de.cf.cloud.ibm.com](https://api.eu-de.cf.cloud.ibm.com)|
    | public CF eu-gb | [https://api.eu-gb.cf.cloud.ibm.com](https://api.eu-gb.cf.cloud.ibm.com)|
    | public CF au-syd | [https://api.au-syd.cf.cloud.ibm.com](https://api.au-syd.cf.cloud.ibm.com)|
    | public CF us-east | [https://api.us-east.cf.cloud.ibm.com](https://api.us-east.cf.cloud.ibm.com)|

4. Similarly, add `ORG` and `SPACE` to GitHub secrets.
5. If you wish to go with  `Authentication using API KEY`, then put `IBM_API_KEY` in Name, and the API_KEY generated in the previous step in the `Value` Textbox.
6. If you wish to go with  `Authentication using Email & Password`, then put `USER_EMAIL` in Name and your IBM Email in the `Value` textbox.
7. Similarly, add `USER_PASSWORD` in Name and your IBM Password in the `Value` textbox.

**Please note that you need to either add the IBM_API_KEY or USER_EMAIL and USER_PASSWORD. If you add both of them, then either of these two will be used for authentication.**


## Example YAML Snippet

```yaml
name: Deploy to IBM Cloud Foundry
on:
  push:
    branches: [master]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Deploy MyApp
      uses: subhamx/ibm-cloud-foundry-deploy@master
      with:
        # For Users who have opted for Authentication using Email & Password
        EMAIL: ${{ secrets.USER_EMAIL }}
        PASSWORD: ${{ secrets.USER_PASSWORD }}
        # For Users who have opted for Authentication using API KEY
        API_KEY: ${{ secrets.IBM_API_KEY }}
        # Cloud Foundry API Endpoint
        CF_API_ENDPOINT: ${{ secrets.CF_API_ENDPOINT }}
        # Path to manifest.yml
        MANIFEST_FILE_PATH: './src/manifest.yml'
        # Cloud Foundry ORG Name
        ORG: ${{ secrets.ORG }}
        # Cloud Foundry Space Name for the specified ORG
        SPACE: ${{ secrets.SPACE }}
```


Head over to this [repo](https://github.com/subhamX/fiboapp) which hosts a simple NodeJS application, and uses this action to deploy the application to `IBM Cloud` on every push to master branch.


**Note:** We are suppressing all major logs as IBM CLI displays your IBM cloud email, org name, etc. during the deploy. In this process, some information like final deploy URL etc. is also getting ignored. IBM Cloud CLI generates these logs, and there isn't an option to filter them. We are working on adding more detailed information to the action logs after filtering out sensitive ones. This action will output the final Deploy URL, and more detailed build information in the next version, very soon! Meanwhile, you can access the deploy logs and additional information in the cloud foundry dashboard.


## Contributing

This project welcomes contributions and suggestions. Feel free to report bugs and suggest features. It will help us improve this project. ⚡⚡

