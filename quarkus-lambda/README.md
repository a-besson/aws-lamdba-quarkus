# Quarkus Lambda

Simple quarkus lambda using quarkus-amazon-lambda dependency.

![schema-quarkus-lambda.png](.assets%2Fschema-quarkus-lambda.png)

> :warning: This sample could use some services/options not eligible to free account

## Prerequisites

* java 21
* aws account
* aws cli & sam cli

## Getting started

### Run locally

#### Live coding and testing

```shell
mvn quarkus:dev
curl -d "{\"body\":\"hello lambda\"}" -X POST http://localhost:8080
```

#### Package

```shell
# build graalvm package
mvn install -DskipTests -Dnative -Dquarkus.native.container-build=true

# build jvm package
mvn install -DskipTests
```

#### Testing locally with the SAM

```shell
sam local invoke --template cloudformation/sam.native.yaml --event ./src/test/resources/payload.json --region eu-west-3
```

#### Deploy to AWS with SAM & Cloudformation

```shell
# create bucket for lambda
aws s3 mb s3://${LAMDBA_BUCKET};

# build app
mvn install -DskipTests -Dnative -Dquarkus.native.container-build=true

# package app with sam & upload lambda
sam package --template-file cloudformation/${LAMDBA_TEMPLATE} \
    --output-template-file target/packaged.yaml \
    --s3-bucket ${LAMDBA_BUCKET};

# Deploy lambda stack
sam deploy --template-file target/packaged.yaml \
  --stack-name ${LAMDBA_STACK} \
  --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND

# Test lambda
curl -X POST 'https://0hlaj71lk8.execute-api.eu-west-3.amazonaws.com/dev/demo' \
  -H 'content-type: application/json' \
  -d '{ "body": "hello lambda" }'
```

#### Deploy to AWS with SAM & Terraform

```bash
cd terraform/

terraform init
terraform plan
terraform apply -auto-approve
...
Apply complete! Resources: 9 added, 0 changed, 0 destroyed.
Outputs:
aws_lambda_function = "arn:aws:lambda:ZONE:ID:function:cloud-public-quarkus-lambda"
aws_lambda_function_url = "https://ID.lambda-url.eu-west-3.on.aws/"

curl -X POST 'https://ID.lambda-url.eu-west-3.on.aws/' \
    -H 'content-type: application/json' \
    -d '{ "body": "hello lambda" }'

{ "body": "hello lambda" }

terraform destroy -auto-approve
```

#### Performance test

```bash
npm install -g artillery@latest
artillery run src/test/resources/lambda-load-test.yml --target https://example.lambda-url.eu-west-3.on.aws/
```

