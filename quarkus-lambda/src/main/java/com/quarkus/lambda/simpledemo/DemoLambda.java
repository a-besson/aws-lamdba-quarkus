package com.quarkus.lambda.simpledemo;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.quarkus.lambda.simpledemo.common.Request;
import com.quarkus.lambda.simpledemo.common.Response;
import com.quarkus.lambda.simpledemo.interceptor.LambdaTracer;
import com.quarkus.lambda.simpledemo.service.ProcessingService;
import jakarta.inject.Inject;
import jakarta.inject.Named;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Named("demo")
@LambdaTracer
public class DemoLambda implements RequestHandler<Request, Response> {

    @Inject
    ProcessingService service;

    @Override
    public Response handleRequest(Request request, Context ctx) {
        return service.process(request);
    }
}
