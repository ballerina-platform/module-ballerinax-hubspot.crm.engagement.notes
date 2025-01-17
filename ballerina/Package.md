## Overview

[HubSpot](https://www.hubspot.com/) is an AI-powered customer relationship management (CRM) platform.

The `ballerinax/module-ballerinax-hubspot.crm.engagement.notes` connector offers APIs to connect and interact with the [Hubspot Engagement Notes API](https://developers.hubspot.com/docs/reference/api/crm/engagements/notes) endpoints, specifically based on the [HubSpot REST API](https://developers.hubspot.com/docs/reference/api/overview).

## Setup guide

### Step 1: Create/Login to a HubSpot Developer Account

If you already have a HubSpot Developer Account, go to the [HubSpot developer portal](https://app.hubspot.com/).

If you don't have an account, you can sign up to a free account [here](https://developers.hubspot.com/get-started).

### Step 2 (Optional): Create a Developer Test Account under your account

Within app developer accounts, you can create a [Developer Test Account](https://developers.hubspot.com/beta-docs/getting-started/account-types#developer-test-accounts) to test apps and integrations without affecting any real HubSpot data.

 > **Note:** These accounts are only for development and testing purposes. In production you should not use Developer Test Accounts.

1. Go to `Test accounts` section from the left sidebar.
![test_account image](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.engagement.notes/main/docs/setup/resources/test-account.png)

2. Click on the `Create developer test account` button on the top right corner.
![create_test_account image](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.engagement.notes/main/docs/setup/resources/create-test-account.png)

3. In the pop-up window, provide a name for the test account and click on the `Create` button.
![create_account image](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.engagement.notes/main/docs/setup/resources/create-account.png)

4. You will see the newly created test account in the list of test accounts.
![test_account_portal image](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.engagement.notes/main/docs/setup/resources/test-account-portal.png)

### Step 3: Create a HubSpot App

1. Now navigate to the `Apps` section from the left sidebar and click on the `Create app` button on the top right corner.
![create_app image](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.engagement.notes/main/docs/setup/resources/create-app.png)

2. Provide a public app name and description for your app.
![app_name_description image](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.engagement.notes/main/docs/setup/resources/app-name-desc.png)

### Step 4: Setup authentication

1. Move to the `Auth` tab.
![config_auth image](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.engagement.notes/main/docs/setup/resources/config-auth.png)


2. In the `Scopes` section, add the following scopes for your app using the `Add new scopes` button.
![add_scopes image](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.engagement.notes/main/docs/setup/resources/add-scopes.png)

3. In the `Redirect URL` section, add the redirect URL for your app. This is the URL where the user will be redirected after the authentication process. You can use localhost for testing purposes. Then hit the `Create App` button.
![redirect_url image](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.engagement.notes/main/docs/setup/resources/redirect-url.png)

### Step 5: Get the Client ID and Client Secret

Navigate to the `Auth` tab and you will see the `Client ID` and `Client Secret` for your app. Make sure to save these values.

![client_id_secret image](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.engagement.notes/main/docs/setup/resources/client-id-secret.png)

### Step 6: Setup Authentication Flow

Before proceeding with the Quickstart, ensure you have obtained the Access Token using the following steps:

1. Create an authorization URL using the following format:

   ```
   https://app.hubspot.com/oauth/authorize?client_id=<YOUR_CLIENT_ID>&scope=<YOUR_SCOPES>&redirect_uri=<YOUR_REDIRECT_URI>
   ```

   Replace the `<YOUR_CLIENT_ID>`, `<YOUR_REDIRECT_URI>` and `<YOUR_SCOPES>` with your specific value.

2. Paste it in the browser and select your developer test account to intall the app when prompted.

   ![hubspot_auth_config_screen image](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.engagement.notes/main/docs/setup/resources/hubspot-oauth-consent-screen.png)

3. A code will be displayed in the browser. Copy the code.

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

To use the `HubSpot Engagement Notes` connector in your Ballerina application, update the `.bal` file as shown below:

### Step 1: Import the module

Import the `hubspot.crm.engagement.notes` module and `oauth2` module.

```ballerina
import ballerina/oauth2;
import ballerinax/hubspot.crm.engagement.notes as hsengnotes;
```

### Step 2: Instantiate a new connector

1. Instantiate `hsengnotes:OAuth2RefreshTokenGrantConfig` with the obtained credentials and initialize the connector with it.

   ```ballerina 
   configurable string clientId = ?;
   configurable string clientSecret = ?;
   configurable string refreshToken = ?;

   hsengnotes:OAuth2RefreshTokenGrantConfig auth = {
      clientId,
      clientSecret,
      refreshToken,
      credentialBearer: oauth2:POST_BODY_BEARER
   };

   final hsengnotes:Client hubSpotNotes = check new ({auth});
   ```

2. Create a `Config.toml` file and, configure the obtained credentials in the above steps as follows:

   ```toml
   clientId = "<Client Id>"
   clientSecret = "<Client Secret>"
   refreshToken = "<Refresh Token>"
   ```

### Step 3: Invoke the connector operation

Now, utilize the available connector operations. A sample use case is shown below.

#### Get the note with a given ID

```ballerina
public function main() returns error? {
   string noteId = ""; // ID of the note that needs to be read
   hsengnotes:SimplePublicObjectWithAssociations readResponse = check hubSpotNotes->/[noteId]();
}  
```

### Step 4: Run the Ballerina application

```bash
bal run
```

## Examples

The `Ballerina HubSpot CRM Engagement Notes Connector` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/module-ballerinax-hubspot.crm.engagement.notes/tree/main/examples/), covering the following use cases:

1. [Managing a single note](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.engagement.notes/tree/main/examples/manage_notes) - Operations on a single note such as creating, updating and deleting, as well as getting a list of available notes and searching for a note by its content.

2. [Working with a batch of notes](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.engagement.notes/tree/main/examples/manage_notes_batch) - Operations on a batch of notes such as creating, updating and deleting, as well as getting notes by their ID.