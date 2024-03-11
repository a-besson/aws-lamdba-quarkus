package com.quarkus.lambda.simpledemo;

import io.quarkus.test.junit.QuarkusIntegrationTest;
import io.quarkus.test.junit.TestProfile;

@QuarkusIntegrationTest
@TestProfile(StreamLambdaProfile.class)
public class StreamLambdaIT extends DemoLambdaTest {
}
