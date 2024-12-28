package com.capstone.handle;

import com.capstone.entity.ChunkMessage;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.config.KafkaListenerEndpointRegistry;
import org.springframework.kafka.listener.MessageListenerContainer;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.util.Collections;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

@Slf4j
@Component
public class ChunkMessageWebSocketHandler extends TextWebSocketHandler {
    private Set<WebSocketSession> sessions = Collections.newSetFromMap(new ConcurrentHashMap<>());
    private ObjectMapper objectMapper = new ObjectMapper();

//    @Autowired
//    private KafkaListenerEndpointRegistry kafkaListenerEndpointRegistry;

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        sessions.add(session);
        log.info("New WebSocket connection established.");

//        try {
//            // Resume Kafka consumer
//            resumeKafkaConsumer();
//        } catch (Exception e) {
//            log.error("Error in resumeKafkaConsumer: ", e);
//        }

        try {
            // Send hello
            sendHelloToSession(session);
        } catch (Exception e) {
            log.error("Error in sendHelloToSession: ", e);
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        sessions.remove(session);
        System.out.println("WebSocket connection closed.");

        if (sessions.isEmpty()) {
            // 暂停 Kafka 消费者
            //pauseKafkaConsumer();
        }
    }

    public boolean sendChunkMessage(ChunkMessage chunkMessage) {
        if (!sessions.isEmpty()) {
            String message;
            try {
                message = objectMapper.writeValueAsString(chunkMessage);
            } catch (Exception e) {
                e.printStackTrace();
                return false;
            }

            boolean allSent = true;
            for (WebSocketSession session : sessions) {
                if (session.isOpen()) {
                    try {
                        session.sendMessage(new TextMessage(message));
                    } catch (Exception e) {
                        e.printStackTrace();
                        allSent = false;
                    }
                } else {
                    allSent = false;
                }
            }
            return allSent;
        } else {
            System.out.println("No WebSocket clients connected.");
            return false;
        }
    }

//    private void pauseKafkaConsumer() {
//        MessageListenerContainer listenerContainer = kafkaListenerEndpointRegistry.getListenerContainer("chunkListener");
//        if (listenerContainer != null) {
//            listenerContainer.pause();
//            System.out.println("Kafka consumer paused.");
//        }
//    }
//
//    private void resumeKafkaConsumer() {
//        if (kafkaListenerEndpointRegistry == null) {
//            log.error("kafkaListenerEndpointRegistry is null.");
//            return;
//        }
//        MessageListenerContainer listenerContainer = kafkaListenerEndpointRegistry.getListenerContainer("chunkListener");
//        if (listenerContainer != null) {
//            listenerContainer.resume();
//            System.out.println("Kafka consumer resumed.");
//        } else {
//            log.warn("Listener container 'chunkListener' not found.");
//        }
//    }

    private void sendHelloToSession(WebSocketSession session) {
        if (session.isOpen()) {
            try {
                session.sendMessage(new TextMessage("Hello"));
            } catch (Exception e) {
                log.error("Failed to send hello message to session", e);
            }
        } else {
            log.warn("Session is closed when trying to send hello message.");
        }
    }
}
