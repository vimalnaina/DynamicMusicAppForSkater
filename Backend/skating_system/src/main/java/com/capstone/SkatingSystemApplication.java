package com.capstone;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.kafka.annotation.EnableKafka;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@SpringBootApplication
@EnableTransactionManagement  // 启用事务管理
@EnableKafka    //开启kafka功能
public class SkatingSystemApplication {

    public static void main(String[] args) {
        SpringApplication.run(SkatingSystemApplication.class, args);
    }

}
