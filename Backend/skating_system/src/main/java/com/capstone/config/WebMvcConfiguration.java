package com.capstone.config;

import com.capstone.common.JacksonObjectMapper;
import com.capstone.interceptor.JwtTokenAdminInterceptor;
import com.capstone.interceptor.RequestLoggingInterceptor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurationSupport;
import springfox.documentation.builders.ApiInfoBuilder;
import springfox.documentation.builders.PathSelectors;
import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.service.ApiInfo;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;
import org.springframework.web.servlet.config.annotation.CorsRegistry;

import java.util.List;

/**
 * 配置类，注册web层相关组件
 */
@Configuration
@Slf4j
public class WebMvcConfiguration extends WebMvcConfigurationSupport {

    @Autowired
    private JwtTokenAdminInterceptor jwtTokenAdminInterceptor;

    @Autowired
    private RequestLoggingInterceptor requestLoggingInterceptor;


    /**
     * add global Cors interception handler
     * @param registry
     */
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOriginPatterns("http://*", "https://*")
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowedHeaders("*")
                .exposedHeaders("token", "Content-Type")
                .allowCredentials(true)
                .maxAge(3600);
    }


    /**
     * regist the interceptor
     *
     * @param registry
     */
    protected void addInterceptors(InterceptorRegistry registry) {

        /**
         * try to figure out the using ngrok connect the local server
         */
//        registry.addInterceptor(new HandlerInterceptorAdapter() {
//            @Override
//            public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
//                response.setHeader("Content-Security-Policy", "default-src 'self' https://cdn.ngrok.com 'unsafe-eval' 'unsafe-inline'; img-src 'self' data: https://www.w3.org/2000/svg;");
//                super.afterCompletion(request, response, handler, ex);
//            }
//        });

        log.info("start the globalRequestInterceptor...");
        registry.addInterceptor(requestLoggingInterceptor)
                        .addPathPatterns("/**");

        log.info("start the jwt interceptor...");
        registry.addInterceptor(jwtTokenAdminInterceptor)
                .addPathPatterns("/**")
                .excludePathPatterns("/user/login",
                        "/user/save",
                        "/user/logout",
                        "/reservation/available/**",
                        "/doc.html",
                        "/webjars/**",
                        "/swagger-resources/**",
                        "/v2/api-docs/**",
                        "/ws/**");

    }

    /**
     * using knife4j generate Swagger document
     *
     * @return
     */
    @Bean
    public Docket docket1() {
        log.info("generating document!");
        ApiInfo apiInfo = new ApiInfoBuilder()
                .title("dynamic music playing system interface")
                .version("1.0")
                .description("dynamic music playing system interface document")
                .build();
        Docket docket = new Docket(DocumentationType.SWAGGER_2)
                .groupName("interface management")
                .apiInfo(apiInfo)
                .select()
                .apis(RequestHandlerSelectors.basePackage("com.capstone.controller"))
                .paths(PathSelectors.any())
                .build();
        return docket;
    }

    /**
     * Set static resource mapping
     *
     * @param registry
     */
    protected void addResourceHandlers(ResourceHandlerRegistry registry) {
        log.info("start static resource mapping!");
        registry.addResourceHandler("/doc.html").addResourceLocations("classpath:/META-INF/resources/");
        registry.addResourceHandler("/webjars/**").addResourceLocations("classpath:/META-INF/resources/webjars/");
    }

    /**
     * extend Spring MVC HttpMessageConverter
     *
     * @param converters
     */
    @Override
    protected void extendMessageConverters(List<HttpMessageConverter<?>> converters) {
        log.info("extend HttpMessageConverter...");
        //Create a message converter object
        MappingJackson2HttpMessageConverter converter = new MappingJackson2HttpMessageConverter();
        //set up an object converter for the message converter. The object converter can serialize Java objects into json data.
        converter.setObjectMapper(new JacksonObjectMapper());
        //Add your own message converter to the container, and add index 0 to indicate that the message converter you added is ranked first. Use this strategy first.
        converters.add(0, converter);
    }
}
