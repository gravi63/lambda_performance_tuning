


<img width="1588" height="446" alt="image" src="https://github.com/user-attachments/assets/636b2eb2-82c3-4c44-93bd-10e8201aa1e7" />


<img width="1588" height="446" alt="image" src="https://github.com/user-attachments/assets/2e38f677-6524-486b-977b-3be7e38f83f4" />



Select the powerTuningStateMachine, click “Start execution”. 
Get your Lambda ARN and put in the below JSON. Then copy the whole JSON and put it in input.

{
  "lambdaARN": "YOUR LAMBDA ARN HERE",
  "powerValues": [
    128,
    256,
    512,
    1024
  ],
  "num": 10,
  "payload": {
    "operation": "list",
    "tableName": "lambda-apigateway",
    "payload": {}
  },
  "parallelInvocation": true,
  "strategy": "cost"
}

Once it done running, click Execution input and output tab. 
Select and copy the visualization link. 

<img width="1588" height="583" alt="image" src="https://github.com/user-attachments/assets/f10d164d-9952-423d-955e-18542e08712f" />

Open in new browser. 
This graph shows cost and performance tradeoff. 
So here we can see 256 MB will be nice option which satisfies both cost and performace on avg.

<img width="1776" height="871" alt="image" src="https://github.com/user-attachments/assets/21153f06-1936-480f-b710-f3a2842c734b" />
