package com.capstone.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.kafka.annotation.EnableKafka;
import org.springframework.kafka.config.KafkaListenerEndpointRegistry;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.core.ProducerFactory;
import org.springframework.kafka.support.serializer.JsonSerializer;

@Configuration
@EnableKafka
public class KafkaConfig {


    /**
     * I can auto bean in the ChunkMessageWebSocketHandler, so I register it manually.
     * @return
     */
//    @Bean
//    public KafkaListenerEndpointRegistry kafkaListenerEndpointRegistry() {
//        return new KafkaListenerEndpointRegistry();
//    }

}
