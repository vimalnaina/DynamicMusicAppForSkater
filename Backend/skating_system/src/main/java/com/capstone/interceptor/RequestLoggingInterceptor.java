package com.capstone.interceptor;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.util.ContentCachingRequestWrapper;
import org.springframework.web.util.ContentCachingResponseWrapper;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Collections;

@Slf4j
@Component
public class RequestLoggingInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

//        if (!(request instanceof ContentCachingRequestWrapper)) {
//            request = new ContentCachingRequestWrapper(request);
//        }
//        if (!(response instanceof ContentCachingResponseWrapper)) {
//            response = new ContentCachingResponseWrapper(response);
//        }

        log.info("=================== New Request coming ====================");
        String ipAddress = request.getRemoteAddr();
        log.info("request ip address is:" + ipAddress);

        String requestUrl = request.getRequestURL().toString();
        log.info(("request URL is:" + requestUrl));

        String method = request.getMethod();
        log.info("request method is:" + method);

        // Headers
        HttpServletRequest finalRequest = request;
        Collections.list(request.getHeaderNames())
                .forEach(headerName -> Collections.list(finalRequest.getHeaders(headerName))
                        .forEach(headerValue -> log.info("Header '{}' = {}", headerName, headerValue)));


        log.info("===========================================================");
        return true;
    }

//    @Override
//    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
//        if (!(request instanceof ContentCachingRequestWrapper)) {
//            request = new ContentCachingRequestWrapper(request);
//        }
//        if (!(response instanceof ContentCachingResponseWrapper)) {
//            response = new ContentCachingResponseWrapper(response);
//        }
//        logResponseDetails(response);
//        HandlerInterceptor.super.postHandle(request, response, handler, modelAndView);
//    }
//
//    private void logResponseDetails(HttpServletResponse response) throws IOException {
//        log.info("into postHandler");
//        if (response instanceof ContentCachingResponseWrapper) {
//            ContentCachingResponseWrapper wrappedResponse = (ContentCachingResponseWrapper) response;
//            String responseBody = new String(wrappedResponse.getContentAsByteArray(), StandardCharsets.UTF_8);
//
//            log.info("=================== Response Info ====================");
//            log.info("Status code: {}", response.getStatus());
//            log.info("Response Body: {}", responseBody);
//
//            // Headers
//            response.getHeaderNames().forEach(headerName ->
//                    response.getHeaders(headerName).forEach(headerValue ->
//                            log.info("Header '{}' = {}", headerName, headerValue)));
//
//            log.info("======================================================");
//
//            // 必须调用以下方法，否则响应将不会被完整发送给客户端
//            wrappedResponse.copyBodyToResponse();
//        }
//    }
}
