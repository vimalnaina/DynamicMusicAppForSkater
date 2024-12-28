package com.capstone.kafka;

import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.common.serialization.StringDeserializer;

import java.io.Serializable;
import java.time.Duration;
import java.util.Arrays;
import java.util.Collections;
import java.util.Properties;

public class MsgConsumer {
    public static void main(String[] args) {
       Properties props = new Properties();

       props.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, KafkaConstants.BROKER_LIST);
       props.put(ConsumerConfig.GROUP_ID_CONFIG, KafkaConstants.CONSUMER_GROUP);
       //props.put(ConsumerConfig.CLIENT_ID_CONFIG, KafkaConstants.CLIENT_ID);
       props.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
       props.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
       props.put(ConsumerConfig.ENABLE_AUTO_COMMIT_CONFIG, "false");

        KafkaConsumer<String, String> consumer = new KafkaConsumer<String, String>(props);

        consumer.subscribe(Arrays.asList(KafkaConstants.TOPIC_NAME));

        while(true){
            ConsumerRecords<String, String> records = consumer.poll(Duration.ofNanos(100));

            for (ConsumerRecord<String, String> record : records) {
                System.out.println("============================================================");
                System.out.printf("收到消息：partition = %d,offset = %d, key = %s, value = %s%n", record.partition(),
                        record.offset(), record.key(), record.value());
            }
            if(records.count() > 0){
                consumer.commitSync();
            }
        }

    }
}
