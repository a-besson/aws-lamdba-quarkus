package com.quarkus.lambda.simpledemo.common;

public record Response(Integer statusCode,
                       String body) {
}
