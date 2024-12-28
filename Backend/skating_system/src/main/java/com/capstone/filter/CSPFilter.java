package com.capstone.filter;

import org.springframework.stereotype.Component;

import javax.servlet.*;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * try to figure out the ngrok connection problem
 */
//@Component
//public class CSPFilter implements Filter {
//
//    @Override
//    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
//        HttpServletResponse httpServletResponse = (HttpServletResponse) response;
//        httpServletResponse.setHeader("Content-Security-Policy", "default-src 'self' https://cdn.ngrok.com; img-src 'self' data: https://www.w3.org/2000/svg;");
//        chain.doFilter(request, response);
//    }
//}
