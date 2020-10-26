# Stone Challenge API
API developed by Kadmo Hardy.

To start your Phoenix server:

- Install dependencies with ````mix deps.get````
- Create and migrate your database with ````mix ecto.create && mix ecto.migrate````
- Start Phoenix endpoint with ````mix phx.server````
- Now you can visit ````localhost:4000```` from your browser.

## 1. Modules
The main modules of api are ````accounts```` and ````banking````. In these modules, you can realize user registration, authentication and banking transactions. 

### 1.1 Accounts

To register a new user you can send a POST request to ````localhost:4000/users```` with following json body
````
{
	"name": "User Name",
	"email": "useremail@gmail.com", 
	"password": "user password", 
	"customer": true (for customer) || false (for backoffice admin)	
	
}
````

Following, we have a example of response: 
````
{
    "account": {
        "account_number": "197023",
        "name": 1000
    },
    "email": "joao10@gmail.com",
    "id": 23,
    "name": "Joao10"
    "customer": true
}
````

### 1.2 Authentication

To authenticate a customer user it is necessary give authentication token you can send a POST request to ````localhost:4000/sessions```` with following json body
````
{
	"account_number": "000000", 
  	"password": "user password"
}
```` 
and for admin user 
````
{
	"email": "user@email.com", 
  	"password": "user password"
}
```` 

After that, the user receives a authentication token, like this: 
````
{
    "data": {
        "token": "SFMyNTY.g2gDdAAAAAtkAAhfX21ldGFfX3QAAAAGZAAKX19zdHJ1Y3RfX2QAG0VsaXhpci5FY3RvLlNjaGVtYS5NZXRhZGF0YWQAB2NvbnRleHRkAANuaWxkAAZwcmVmaXhkAANuaWxkAAZzY2hlbWFkACNFbGl4aXIuU3RvbmVDaGFsbGVuZ2UuQWNjb3VudHMuVXNlcmQABnNvdXJjZW0AAAAFdXNlcnNkAAVzdGF0ZWQABmxvYWRlZGQACl9fc3RydWN0X19kACNFbGl4aXIuU3RvbmVDaGFsbGVuZ2UuQWNjb3VudHMuVXNlcmQAB2FjY291bnR0AAAACGQACF9fbWV0YV9fdAAAAAZkAApfX3N0cnVjdF9fZAAbRWxpeGlyLkVjdG8uU2NoZW1hLk1ldGFkYXRhZAAHY29udGV4dGQAA25pbGQABnByZWZpeGQAA25pbGQABnNjaGVtYWQAJUVsaXhpci5TdG9uZUNoYWxsZW5nZS5CYW5raW5nLkFjY291bnRkAAZzb3VyY2VtAAAACGFjY291bnRzZAAFc3RhdGVkAAZsb2FkZWRkAApfX3N0cnVjdF9fZAAlRWxpeGlyLlN0b25lQ2hhbGxlbmdlLkJhbmtpbmcuQWNjb3VudGQADmFjY291bnRfbnVtYmVybQAAAAYxOTcwMDNkAAdiYWxhbmNlYgAAKf5kAAJpZGEDZAALaW5zZXJ0ZWRfYXR0AAAACWQACl9fc3RydWN0X19kABRFbGl4aXIuTmFpdmVEYXRlVGltZWQACGNhbGVuZGFyZAATRWxpeGlyLkNhbGVuZGFyLklTT2QAA2RheWEJZAAEaG91cmECZAALbWljcm9zZWNvbmRoAmEAYQBkAAZtaW51dGVhEGQABW1vbnRoYQhkAAZzZWNvbmRhL2QABHllYXJiAAAH5GQACnVwZGF0ZWRfYXR0AAAACWQACl9fc3RydWN0X19kABRFbGl4aXIuTmFpdmVEYXRlVGltZWQACGNhbGVuZGFyZAATRWxpeGlyLkNhbGVuZGFyLklTT2QAA2RheWEJZAAEaG91cmEVZAALbWljcm9zZWNvbmRoAmEAYQBkAAZtaW51dGVhMmQABW1vbnRoYQhkAAZzZWNvbmRhM2QABHllYXJiAAAH5GQAB3VzZXJfaWRhA2QAC2F1dGhfdG9rZW5zdAAAAARkAA9fX2NhcmRpbmFsaXR5X19kAARtYW55ZAAJX19maWVsZF9fZAALYXV0aF90b2tlbnNkAAlfX293bmVyX19kACNFbGl4aXIuU3RvbmVDaGFsbGVuZ2UuQWNjb3VudHMuVXNlcmQACl9fc3RydWN0X19kACFFbGl4aXIuRWN0by5Bc3NvY2lhdGlvbi5Ob3RMb2FkZWRkAAVlbWFpbG0AAAAPcGF1bG9AZ21haWwuY29tZAACaWRhA2QAC2luc2VydGVkX2F0dAAAAAlkAApfX3N0cnVjdF9fZAAURWxpeGlyLk5haXZlRGF0ZVRpbWVkAAhjYWxlbmRhcmQAE0VsaXhpci5DYWxlbmRhci5JU09kAANkYXlhCWQABGhvdXJhAmQAC21pY3Jvc2Vjb25kaAJhAGEAZAAGbWludXRlYRBkAAVtb250aGEIZAAGc2Vjb25kYS9kAAR5ZWFyYgAAB-RkAARuYW1lbQAAAAVQYXVsb2QACHBhc3N3b3JkZAADbmlsZAANcGFzc3dvcmRfaGFzaG0AAACDJHBia2RmMi1zaGE1MTIkMTYwMDAwJHlYMlVzNXByUk94S2ZET1RDcUZ0NkEkazJmUURjMHFKM3dBMm5HTVBKRFpKMWowQkp2ZkwyL25rY1ZudHlVVFJvb1NrSFRkMFgxZ2pOMnM3QUVsaWx3LnRTOHh3MG1lNTRiakVTdktoLmRRdFFkAAp1cGRhdGVkX2F0dAAAAAlkAApfX3N0cnVjdF9fZAAURWxpeGlyLk5haXZlRGF0ZVRpbWVkAAhjYWxlbmRhcmQAE0VsaXhpci5DYWxlbmRhci5JU09kAANkYXlhCWQABGhvdXJhAmQAC21pY3Jvc2Vjb25kaAJhAGEAZAAGbWludXRlYRBkAAVtb250aGEIZAAGc2Vjb25kYS9kAAR5ZWFyYgAAB-RuBgDYlTzkcwFiAAFRgA.6rQadBi5VOUHJBetrnfuhz_v7M1JBi5SVHDgL0e7Nqg"
    }
}
````

### 1.3 Banking trasactions
We have two transaction types: bank draft and bank transfer. To make a bank transfer you need send a POST request to ````localhost:4000/transactions```` with following json body 

````
{
	"amount": 50,                       // amount of money
	"type": 1,                          // type of transaction (1: bank draft, 2: bank transfer)    
	"target_account_number": "197003"   // target account number (if bank draft, target_account_number is same of account_number of user that make transaction)
}
````

To make a bank transfer you need send a POST request to ````localhost:4000/sessions```` with following json body

````
{
	"amount": 50,                       // amount of money (integers values)
	"type": 2,                          // type of transaction (1: bank draft, 2: bank transfer)    
	"target_account_number": "197004"   // target account number (if bank draft, target_account_number is same of account_number of user that make transaction)
}
````

It`s important to note that transaction operations needs an authentication token to be realized. We using integers number for money amount in order to simplify transactions process.

### 1.4 Back Office
  The API provide a set of very simplistic reports that inform the total traded per day, month and year. To give diary report, the user needs make a GET request using the following route: 
  ````localhost:4000/reports?type=diary&day=07&month=08&year=2020````
  where ````type```` is the type of report (diary, monthly, yearly, or total), ````day````is day, ````month```` is a number of month and ````year````is year. 
  
  In the same way, for give monthly report, use
  ````localhost:4000/reports?type=monthly&day=07&month=08````
  and ````localhost:4000/reports?type=yearly&year=08````, for yearly report.
  
  Finally, to total reports, uses
  ````localhost:4000/reports?type=total````
  
  The given response has following format
  ````
  {
    "data": {
        "total": 2150
    }
  } 
  ````
  
Note that user should be a backoffice user in order to have access to reports.

## 2. Postman JSON 
In the root of this repository, we have a postman project name 
```` 
Stone.postman_collection.json 
```` 
that could be used to test API.

## 3. Tests 
The tests for api are present in /test. For models, tests could be started using 

````mix test test/stone_challenge/accounts_test.exs````
````mix test test/stone_challenge/banking_test.exs````
````mix test test/stone_challenge/tokens_test.exs````,

for controllers,

````mix test test/stone_challenge_web/controllers/page_controller_test.exs````
````mix test test/stone_challenge_web/controllers/user_controller_test.exs````
````mix test test/stone_challenge_web/controllers/session_controller_test.exs````
````mix test test/stone_challenge_web/controllers/bank_draft_controller_test.exs````
````mix test test/stone_challenge_web/controllers/bank_transfer_controller_test.exs````,

and, finally, for views, 

````mix test test/stone_challenge_web/views/bank_draft_view_test.exs````
````mix test test/stone_challenge_web/views/bank_transfer_view_test.exs````
````mix test test/stone_challenge_web/views/user_view_test.exs````
````mix test test/stone_challenge_web/views/session_view_test.exs````
````mix test test/stone_challenge_web/views/reports_view_test.exs````

## 4. Deployed version 
The server was deployed on a digital ocean server. We have a docker container running a PostGres db instance. You can vizualize on the following route.
http://104.248.48.177 [StoneChallengeAPI](http://104.248.48.177). For API requests use 

````http://104.248.48.177/api````
