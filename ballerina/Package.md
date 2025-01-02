## Overview

[HubSpot](https://developers.hubspot.com/docs/reference/api) is an AI-powered customer platform with all the software, integrations, and resources you need to connect your marketing, sales, and customer service

The `hubspot.crm.engagement.notes` package offers APIs to connect and interact with [Notes 
Engagements API](https://developers.hubspot.com/docs/reference/api/crm/engagements/notes) endpoints, specifically based on [HubSpot API v3](https://developers.hubspot.com/docs/reference/api).


## Setup guide

### Step 1: Create/Login to a HubSpot Developer Account

If you already have a HubSpot Developer Account, go to the [HubSpot developer portal](https://app.hubspot.com/).

If you don't have an account, you can sign up to a free account [here](https://developers.hubspot.com/get-started).

### Step 2 (Optional): Create a [Developer Test Account](https://developers.hubspot.com/beta-docs/getting-started/account-types#developer-test-accounts) under your account

Within app developer accounts, you can create developer test accounts to test apps and integrations without affecting any real HubSpot data.

**_These accounts are only for development and testing purposes. In production you should not use Developer Test Accounts._**

1. Go to `Test accounts` section from the left sidebar.

<img src="../docs/setup/resources/test-account.png" width="70%">

2. Click on the `Create developer test account` button on the top right corner.

<img src="../docs/setup/resources/create-test-account.png" width="70%">

3. In the pop-up window, provide a name for the test account and click on the `Create` button.

<img src="../docs/setup/resources/create-account.png" width="70%">

4. You will see the newly created test account in the list of test accounts.

<img src="../docs/setup/resources/test-account-portal.png" width="70%">

### Step 3: Create a HubSpot App

1. Now navigate to the `Apps` section from the left sidebar and click on the `Create app` button on the top right corner.
<img src="../docs/setup/resources/create-app.png" width="70%">

2. Provide a public app name and description for your app.

<img src="../docs/setup/resources/app-name-desc.png" width="70%">

### Step 4: Setup authentication

1. Move to the `Auth` tab.

<img src="../docs/setup/resources/config-auth.png" width="70%">


2. In the `Scopes` section, add the following scopes for your app using the `Add new scopes` button.

<img src="../docs/setup/resources/add-scopes.png" width="70%">

3. In the `Redirect URL` section, add the redirect URL for your app. This is the URL where the user will be redirected after the authentication process. You can use localhost for testing purposes. Then hit the `Create App` button.

<img src="../docs/setup/resources/redirect-url.png" width="70%">

### Step 5: Get the Client ID and Client Secret

Navigate to the `Auth` tab and you will see the `Client ID` and `Client Secret` for your app. Make sure to save these values.

<img src="../docs/setup/resources/client-id-secret.png" width="70%">

### Step 6: Setup Authentication Flow

Before proceeding with the Quickstart, ensure you have obtained the Access Token using the following steps:

1. Create an authorization URL using the following format:

   ```
   https://app.hubspot.com/oauth/authorize?client_id=<YOUR_CLIENT_ID>&scope=<YOUR_SCOPES>&redirect_uri=<YOUR_REDIRECT_URI>
   ```

   Replace the `<YOUR_CLIENT_ID>`, `<YOUR_REDIRECT_URI>` and `<YOUR_SCOPES>` with your specific value.

2. Paste it in the browser and select your developer test account to intall the app when prompted.

   <img src="../docs/setup/resources/hubspot-oauth-consent-screen.png" style="width: 70%;">

3. A code will be displayed in the browser. Copy the code.

   ```
   Received code: na1-129d-860c-xxxx-xxxx-xxxxxxxxxxxx
   ```

4. Run the following curl command. Replace the `<YOUR_CLIENT_ID>`, `<YOUR_REDIRECT_URI`> and `<YOUR_CLIENT_SECRET>` with your specific value. Use the code you received in the above step 3 as the `<CODE>`.

   - Linux/macOS

     ```bash
     curl --request POST \
     --url https://api.hubapi.com/oauth/v1/token \
     --header 'content-type: application/x-www-form-urlencoded' \
     --data 'grant_type=authorization_code&code=<CODE>&redirect_uri=<YOUR_REDIRECT_URI>&client_id=<YOUR_CLIENT_ID>&client_secret=<YOUR_CLIENT_SECRET>'
     ```

   - Windows

     ```bash
     curl --request POST ^
     --url https://api.hubapi.com/oauth/v1/token ^
     --header 'content-type: application/x-www-form-urlencoded' ^
     --data 'grant_type=authorization_code&code=<CODE>&redirect_uri=<YOUR_REDIRECT_URI>&client_id=<YOUR_CLIENT_ID>&client_secret=<YOUR_CLIENT_SECRET>'
     ```

   This command will return the access token necessary for API calls.

   ```json
   {
     "token_type": "bearer",
     "refresh_token": "<Refresh Token>",
     "access_token": "<Access Token>",
     "expires_in": 1800
   }
   ```

5. Store the access token securely for use in your application.


## Quickstart

[//]: # (TODO: Add a quickstart guide to demonstrate a basic functionality of the module, including sample code snippets.)

## Examples

The `Ballerina HubSpot CRM Engagement Notes Connector` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/module-ballerinax-hubspot.crm.engagement.notes/tree/main/examples/), covering the following use cases:

[//]: # (TODO: Add examples)
