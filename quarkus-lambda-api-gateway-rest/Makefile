LAMDBA_STACK="cloud-public-quarkus-lambda-api-gateway-rest-stack"
LAMDBA_BUCKET="${LAMDBA_STACK}-bucket"
LAMDBA_TEMPLATE="sam.native.yaml"

all: clean package deploy

clean:
	@echo "Clean stack ${LAMDBA_STACK} & bucket ${LAMDBA_BUCKET}"
	aws cloudformation delete-stack --stack-name ${LAMDBA_STACK} && \
	aws cloudformation wait stack-delete-complete --stack-name ${LAMDBA_STACK}; \
	aws s3 rm s3://${LAMDBA_BUCKET} --recursive; \
	aws s3 rb s3://${LAMDBA_BUCKET}; \
	mvn clean

test:
	mvn test

package:
	@echo "Build lambda with graalvm"
	mvn install -DskipTests -Dnative -Dquarkus.native.container-build=true

package-jvm:
	@echo "Build lambda with jvm"
	mvn install -DskipTests

deploy-local:
	sam local invoke --template cloudformation/${LAMDBA_TEMPLATE} \
 		--event ./src/test/resources/payload.json --region eu-west-3

deploy:
	@echo "Deploy lambda with cloudformation"
	aws cloudformation delete-stack --stack-name ${LAMDBA_STACK} && \
	aws cloudformation wait stack-delete-complete --stack-name ${LAMDBA_STACK}; \
	aws s3 mb s3://${LAMDBA_BUCKET}; \
	sam package --template-file cloudformation/${LAMDBA_TEMPLATE} \
		--output-template-file target/packaged.yaml \
		--s3-bucket ${LAMDBA_BUCKET} && \
	sam deploy --template-file target/packaged.yaml --stack-name ${LAMDBA_STACK} --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND
