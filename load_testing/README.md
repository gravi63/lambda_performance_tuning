
# Postman Load Testing 

This is another way to load test your microservice and get performance info. This one can be use irrespective of whether it’s serverless or not (Power tuning above is just for Lambda).

Make sure you have the latest Postman app https://www.postman.com/downloads/ 
Under Collections, click “+”
Click “Add a request”
Click "Save"


<img width="1724" height="661" alt="image" src="https://github.com/user-attachments/assets/609816ac-adcb-404b-beb5-baaf36805ae4" />



Click “...” in the collection name, and from the drop down click “Run”
NOTE: A common mistake is to look for “Run” in the “POSt New Request”. “Run” option is available in the collection name


<img width="579" height="625" alt="image" src="https://github.com/user-attachments/assets/4c13f848-18ee-468e-87e4-348ee6ff3f96" />



Click “Performance”, then select “Ramp up” under Load Profile, select “10” in Virtual users, and Test duration as 2 mins. Click Run!


<img width="1469" height="586" alt="image" src="https://github.com/user-attachments/assets/c196ee7e-0822-4c18-80c7-ef0305732223" />


Let it run for 2 mins.
After 2 mins is over and the run completed, click “...”, and download pdf. So, this is initial test, note the average response time in pdf. In my case it’s 115 ms, it can be different in your case


<img width="1894" height="855" alt="image" src="https://github.com/user-attachments/assets/329f3867-9cf5-472e-9812-b2925aa913e9" />
