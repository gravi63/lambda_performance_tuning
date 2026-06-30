lambda_performance_tuning
----

A step-by-step guide to building and fine-tuning a serverless HTTP API on AWS — one that's ready for real-world use. It covers routing different types of requests through a multiple Python functions, keeping things secure, and using load testing data to make the setup faster and cheaper.

<img width="801" height="341" alt="image" src="https://github.com/user-attachments/assets/921b0172-7574-4f4a-86ff-a082411fe133" />



Steps for Power Tuning
----
1. Execute terraform script at performance_tuning/serverless_repo_prov.tf
2. This is Step Function "powertuning_xxx"

<img width="731" height="121" alt="image" src="https://github.com/user-attachments/assets/31159707-d0be-4164-9edf-451ed38e283e" />


To begin, select the powerTuningStateMachine and click "Start execution." 
Next, retrieve your Lambda ARN and insert it into the JSON below, then copy the entire JSON object and paste it into the input field:

```json
{
  "lambdaARN": "YOUR LAMBDA ARN HERE",
  "powerValues": [128, 256, 512, 1024],
  "num": 10,
  "payload": {
    "operation": "list",
    "tableName": "lambda-apigateway",
    "payload": {}
  },
  "parallelInvocation": true,
  "strategy": "cost"
}
```
Once the execution finishes running, go to the "Execution input and output" tab, then select and copy the visualization link.






