package com.capstone.service;

import com.capstone.entity.ChunkMessage;
import com.capstone.handle.ChunkMessageWebSocketHandler;
import com.capstone.result.Result;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.support.Acknowledgment;
import org.springframework.stereotype.Component;

import java.util.TreeMap;

/**
 * use for sent song and text to speech byte[] data to client side
 */

@Component
public class MyConsumer {

    // 用于存储收到的分段数据，key是歌曲ID，value是一个TreeMap，按顺序存储分段数据
    private final TreeMap<Long, TreeMap<Integer, byte[]>> receivedChunks = new TreeMap<>();

    @Autowired
    private ChunkMessageWebSocketHandler webSocketHandler;

    @KafkaListener(topics = "capstoneTest2", id = "chunkListener")
    public void listenFromCapstone(ConsumerRecord<Long, Object> record, Acknowledgment ack){
        Long key = record.key();
        System.out.println("Received record with key: " + key);
        ChunkMessage value = (ChunkMessage) record.value();
        System.out.println("Chunk index: " + value.getChunkIndex());
        //System.out.println(record);

        //TODO 在这里通过WebSocket将数据分片传输给frontend
        int retryCount = 0;
        int maxRetries = 1;
        boolean sent = false;

        while (!sent && retryCount < maxRetries) {
            sent = webSocketHandler.sendChunkMessage(value);
            if (!sent) {
                retryCount++;
                System.out.println("Failed to send message via WebSocket. Retry count: " + retryCount);
                try {
                    // 等待一段时间再重试
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                    break;
                }
            }
        }

        if (sent) {
            ack.acknowledge();
            System.out.println("Message sent via WebSocket and offset acknowledged.");
        } else {
            System.out.println("Failed to send message after retries. Offset not acknowledged.");
            // 可以在这里记录日志或采取其他措施
        }



        /* 数据组装
        // 将当前分片数据存入内存中的临时存储
        receivedChunks.putIfAbsent(value.getId(), new TreeMap<>());
        receivedChunks.get(value.getId()).put(value.getChunkIndex(), value.getData());


        // 检查是否已经接收到所有分片
        if(receivedChunks.get(value.getId()).size() == value.getTotalChunks()){
            // 重新组装完整的歌曲
            byte[] fullSong = assembleSong(receivedChunks.get(value.getId()));

            //看看最终fullSong拼装是否成功，大小是否相等
            double sizeInMB = fullSong.length / (1024.0 * 1024.0);
            System.out.println(sizeInMB);


            //TODO 将得到的fullSong传给前端




            // 移除已经组装好的数据
            receivedChunks.remove(value.getId());
        }
        */

        //submit offset annually
        //ack.acknowledge();
    }

    // 将所有分片数据组合成完整的文件
    private byte[] assembleSong(TreeMap<Integer, byte[]> chunkMap){
        int totalSize = chunkMap.values().stream().mapToInt(b -> b.length).sum();
        byte[] fullSong = new byte[totalSize];
        int position = 0;

        for (byte[] chunk : chunkMap.values()) {
            System.arraycopy(chunk, 0, fullSong, position, chunk.length);
            position += chunk.length;
        }
        return fullSong;
    }
}
