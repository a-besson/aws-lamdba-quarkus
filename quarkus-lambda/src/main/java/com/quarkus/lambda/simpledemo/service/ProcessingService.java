package com.quarkus.lambda.simpledemo.service;

import com.quarkus.lambda.simpledemo.common.Request;
import com.quarkus.lambda.simpledemo.common.Response;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class ProcessingService {

    public Response process(Request input) {
        return new Response(200, input.body());
    }
}
