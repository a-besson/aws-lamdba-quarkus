# Quarkus Lambda with API Gateway

Simple quarkus lambda using quarkus-amazon-lambda-rest dependency.


> :warning: This sample could use some services/options not eligible to free account

## Getting started

```bash
# build & deploy to aws
make all
....
-------------------------------------------------------------------------------------------------
Outputs
-------------------------------------------------------------------------------------------------
....
Key                 BasicAWSApiGateway
Description         API Gateway endpoint URL for Staging stage for Hello World function
Value               https://ID.execute-api.eu-west-3.amazonaws.com/dev/demo/
-------------------------------------------------------------------------------------------------

user@mbp % curl -X GET https://ID.execute-api.eu-west-3.amazonaws.com/dev/demo/
Hello GET RESTEasy
user@mbp % curl -X POST https://ID.execute-api.eu-west-3.amazonaws.com/dev/demo/
Hello POST RESTEasy
user@mbp % curl -X PUT https://ID.execute-api.eu-west-3.amazonaws.com/dev/demo/
Hello PUT RESTEasy
```
