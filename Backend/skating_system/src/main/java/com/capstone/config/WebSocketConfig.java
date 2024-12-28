package com.capstone.config;

import com.capstone.handle.ChunkMessageWebSocketHandler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.*;

@Configuration
@EnableWebSocket
public class WebSocketConfig implements WebSocketConfigurer {
    @Autowired
    private ChunkMessageWebSocketHandler chunkMessageWebSocketHandler;
    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        registry.addHandler(chunkMessageWebSocketHandler, "/chunkMessage")
                .setAllowedOrigins("*");
    }
}
