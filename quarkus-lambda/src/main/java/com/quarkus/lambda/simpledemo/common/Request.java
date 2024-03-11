package com.quarkus.lambda.simpledemo.common;

public record Request(String body) {

    public static Request empty() {
        return new Request("");
    }
}
