lambda_performance_tuning
----

A step-by-step guide to building and fine-tuning a serverless HTTP API on AWS — one that's ready for real-world use. It covers routing different types of requests through a multiple Python functions, keeping things secure, and using load testing data to make the setup faster and cheaper.

<img width="801" height="341" alt="image" src="https://github.com/user-attachments/assets/921b0172-7574-4f4a-86ff-a082411fe133" />

Steps to Create All Resources in the Architecture Diagram
----
1. create an account with http://auth0.com <br>
2. Create an API in Auth0 (http://auth0.com) <br>
   a. Go to Auth0 Dashboard → Applications → APIs → Create API <br>
   b. Set a name (e.g. DDB Operations API) and an Identifier (this becomes the audience, e.g. https://ddboperations.api) — note this down <br>
   c. Leave signing algorithm as RS256 <br>
3. Get your Auth0 Domain (http://auth0.com) <br>
   a. Go to Applications → Applications → Default App (or create a new one) <br>
   b. Note your Domain (e.g. dev-xxxx.us.auth0.com) — you'll need this for the JWKS URI <br>
4. Update Issuer and Audience parameters in terraform/variables.tf <br>
5. Execute terraform commands to create resources <br>
   a. terraform init <br>
   b. terraform plan <br>
   c. terraform apply <br>

Steps for Power Tuning
----
1. Execute terraform script at performance_tuning/serverless_repo_prov.tf <br>
   a. terraform init <br>
   b. terraform plan <br>
   c. terraform apply <br>
2. This creates Step Function "powertuning_xxx" <br>

<img width="731" height="121" alt="image" src="https://github.com/user-attachments/assets/31159707-d0be-4164-9edf-451ed38e283e" />


3. To begin, select the powerTuningStateMachine and click "Start execution."  <br>
4. Next, retrieve your Lambda ARN and insert it into the JSON below, then copy the entire JSON object and paste it into the input field: <br>

```json
{
  "lambdaARN": "YOUR LAMBDA ARN HERE",
  "powerValues": [128, 256, 512, 1024],
  "num": 10,
  "payload": {
    "operation": "list",
    "tableName": "ddb_table",
    "payload": {}
  },
  "parallelInvocation": true,
  "strategy": "cost"
}
```
5. Once the execution finishes running, go to the "Execution input and output" tab, then select and copy the visualization link. <br>

Steps for Load testing in Postman
----

1. Create a New Collection "lt_collection" <br>
2. Add new API request "ddb_api_request" <br>
   a. URL as "https://xxx.execute-api.us-east-1.amazonaws.com/Prod/ddbmanager?tableName=ddb_table" <br>
   b. click on Autharization tab and select auth type as bearer token. (get the bearer token calling Auth0 API) <br>
   c. click save and test <br>
4. Click the "..." next to the collection name and select "Run" from the dropdown — note that "Run" lives under the collection name, not inside the "POST New Request," which is a common spot   people mistakenly look for it. <br>
5. Click "Performance," then under Load Profile select "Ramp up." <br>
6. Set Virtual users to "10" and Test duration to "2 mins," then click "Run!" <br>
7. this genrates a visual graph report.





