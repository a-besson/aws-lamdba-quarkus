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

```
aws s3 mb s3://cloud-public-quarkus-lambda-tf-stack
```


#### Performance test

```bash
npm install -g artillery@latest
artillery run src/test/resources/lambda-load-test.yml --target https://example.lambda-url.eu-west-3.on.aws/
```

#### Errors
```shell
[INFO] --- failsafe:3.2.5:integration-test (default) @ quarkus-lambda-api-gateway-rest ---
[INFO] Using auto detected provider org.apache.maven.surefire.junitplatform.JUnitPlatformProvider
[INFO]
[INFO] -------------------------------------------------------
[INFO]  T E S T S
[INFO] -------------------------------------------------------
[INFO] Running com.quarkus.lambda.rest.RestApiDemoIT
2024-03-11 12:02:18,268 INFO  [io.qua.ama.lam.run.MockEventServer] (build-4) Mock Lambda Event Server Started
Executing "/Users/adrien/workspace/dev/aws-lambda-lab/aws-lamdba-quarkus/quarkus-lambda-api-gateway-rest/target/quarkus-lambda-api-gateway-rest-1.0-SNAPSHOT-runner -Dquarkus.http.port=8081 -Dquarkus.http.ssl-port=8444 -Dtest.url=http://localhost:8081 -Dquarkus.log.file.path=/Users/adrien/workspace/dev/aws-lambda-lab/aws-lamdba-quarkus/quarkus-lambda-api-gateway-rest/target/quarkus.log -Dquarkus.log.file.enable=true -Dquarkus.log.category."io.quarkus".level=INFO -Dquarkus-internal.aws-lambda.test-api=localhost:8081/_lambda_ -Dquarkus.native.container-build=true"
/Users/adrien/workspace/dev/aws-lambda-lab/aws-lamdba-quarkus/quarkus-lambda-api-gateway-rest/target/quarkus-lambda-api-gateway-rest-1.0-SNAPSHOT-runner: /Users/adrien/workspace/dev/aws-lambda-lab/aws-lamdba-quarkus/quarkus-lambda-api-gateway-rest/target/quarkus-lambda-api-gateway-rest-1.0-SNAPSHOT-runner: cannot execute binary file
[ERROR] Tests run: 1, Failures: 0, Errors: 1, Skipped: 0, Time elapsed: 3.760 s <<< FAILURE! -- in com.quarkus.lambda.rest.RestApiDemoIT
[ERROR] com.quarkus.lambda.rest.RestApiDemoIT.testRestApiDemo -- Time elapsed: 0.010 s <<< ERROR!
java.lang.RuntimeException:
java.lang.RuntimeException: Unable to successfully launch process '98192'. Exit code is: '126'.
This may be caused by building the native binary in a Linux container while the host is macOS.
        at io.quarkus.test.junit.QuarkusIntegrationTestExtension.throwBootFailureException(QuarkusIntegrationTestExtension.java:366)
        at io.quarkus.test.junit.QuarkusIntegrationTestExtension.beforeEach(QuarkusIntegrationTestExtension.java:117)
        at java.base/java.util.ArrayList.forEach(ArrayList.java:1596)
        at java.base/java.util.ArrayList.forEach(ArrayList.java:1596)
Caused by: java.lang.RuntimeException: Unable to successfully launch process '98192'. Exit code is: '126'.
This may be caused by building the native binary in a Linux container while the host is macOS.
        at io.quarkus.test.common.LauncherUtil.ensureProcessIsAlive(LauncherUtil.java:124)
        at io.quarkus.test.common.LauncherUtil.waitForCapturedListeningData(LauncherUtil.java:87)
        at io.quarkus.test.common.DefaultNativeImageLauncher.start(DefaultNativeImageLauncher.java:110)
        at io.quarkus.test.junit.IntegrationTestUtil.startLauncher(IntegrationTestUtil.java:195)
        at io.quarkus.test.junit.QuarkusIntegrationTestExtension.doProcessStart(QuarkusIntegrationTestExtension.java:294)
        at io.quarkus.test.junit.QuarkusIntegrationTestExtension.ensureStarted(QuarkusIntegrationTestExtension.java:163)
        at io.quarkus.test.junit.QuarkusIntegrationTestExtension.beforeAll(QuarkusIntegrationTestExtension.java:130)
        ... 1 more

[INFO]
[INFO] Results:
[INFO]
[ERROR] Errors:
[ERROR]   RestApiDemoIT.testRestApiDemo » Runtime java.lang.RuntimeException: Unable to successfully launch process '98192'. Exit code is: '126'.
This may be caused by building the native binary in a Linux container while the host is macOS.
[INFO]
[ERROR] Tests run: 1, Failures: 0, Errors: 1, Skipped: 0

```


