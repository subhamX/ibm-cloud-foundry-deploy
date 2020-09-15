# IBM Cloud Foundry Deploy

The following Github Action allows developers to deploy 🚀 the application to `IBM cloud foundry` seamlessly. For more information on cloud foundry, please visit [here](https://www.ibm.com/cloud/cloud-foundry).


## Pre-requisites
* You need to have an IBM Cloud account and a cloud foundry instance.
* You can create a IBM Cloud account [here](https://cloud.ibm.com/) and create a new cloud foundry instance [here](https://cloud.ibm.com/catalog/starters/cloud-foundry).
 
## Checklist 

* Ensure that there exists a `manifest.yml` file in the root directory. For more information on App Manifests head over to [this link](https://docs.cloudfoundry.org/devguide/deploy-apps/manifest.html).
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


## Example YAML Snippets

Head over to this [repo](https://github.com/subhamX/fiboapp) to see action logs and workflow yml file in action. It hosts a simple NodeJS application and uses this action for seamless deployment. 

### Deploying NodeJS Application

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
    - name: Deploy NodeJS
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

**Note:** We are suppressing all major output logs as potentially it might reveal your IBM cloud email, Cloud Foundry application name, etc. In this process, some information like final deploy URL etc. is also getting ignored. We are working on adding more information to the logs, but safeguarding your minute credentials is our utmost priority. Deploy URL and other build information will be added in the next version, very soon! Meanwhile, you can access the deploy logs and additional information in the cloud foundry dashboard.


## Contributing

This project welcomes contributions and suggestions. Feel free to report bugs and suggest features. It will help us improve this project. ⚡⚡

