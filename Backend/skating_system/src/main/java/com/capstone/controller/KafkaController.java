package com.capstone.controller;


import com.amazonaws.services.polly.model.OutputFormat;
import com.capstone.common.BaseContext;
import com.capstone.common.SnowFlake;
import com.capstone.entity.ChunkMessage;
import com.capstone.entity.Song;
import com.capstone.entity.User;
import com.capstone.handle.ChunkMessageWebSocketHandler;
import com.capstone.mapper.MusicMapper;
import com.capstone.result.Result;
import com.capstone.service.KafkaService;
import com.capstone.util.TTSUtil;
import com.capstone.vo.SongInfoVO;
import com.capstone.vo.SongListVO;
import com.capstone.vo.UserSaveVO;
import org.apache.kafka.clients.producer.RecordMetadata;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.support.SendResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.ExecutionException;
import java.security.SecureRandom;

/**
 * Kafka producer
 */
@RestController
@RequestMapping("/kafka")
public class KafkaController {

    private static final String TOPIC_NAME = "capstoneTest2";

    // 0.5MB
    private static final int CHUNK_SIZE = 524288;

    @Autowired
    private KafkaTemplate<Long, Object> kafkaTemplate;

    @Autowired
    private KafkaService kafkaService;

    @Autowired
    private RedisTemplate redisTemplate;

    @Autowired
    private MusicMapper musicMapper;


    /**
     * get all song's text-to-speech and data using songList_id
     * @param id songList_id
     * @return
     * @throws ExecutionException
     * @throws InterruptedException
     */
    @GetMapping("/{id}")
    public Result<String> sendData(@PathVariable("id") Long id) throws ExecutionException, InterruptedException, IOException {

        SongListVO songListVO = kafkaService.getByListId(id);

        List<Song> songs = songListVO.getSongList();

        Long userId = BaseContext.getCurrentId();


        for (Song song : songs) {

            //TODO send each song's announcement grab from redis to frontend using kafka

            byte[] songAudioData;
            if(song.getAudioId() != null){
                songAudioData = (byte[]) redisTemplate.opsForValue().get(song.getAudioId().toString());
            }else{
                TTSUtil ttsUtil = new TTSUtil();
                SnowFlake snowFlake = new SnowFlake(1,1);
                //generate user info audio
                Long songAudioId = snowFlake.nextId();
                String songMessage = "Next song name is" + song.getName();
                songAudioData = ttsUtil.getByteFile(songMessage, OutputFormat.Mp3);
                redisTemplate.opsForValue().set(songAudioId.toString(), songAudioData);
                kafkaService.updateSongAudioId(songAudioId, song.getSongId());
            }

            int numberOfChunks1 = (int) Math.ceil((double) songAudioData.length / CHUNK_SIZE);

            for (int i = 0; i < numberOfChunks1; i++) {

                int start = i * CHUNK_SIZE;
                int end = Math.min(songAudioData.length , start + CHUNK_SIZE);

                byte[] chunk = new byte[end - start];
                System.arraycopy(songAudioData, start, chunk, 0, end - start);

                // 打印每个分片的ASCII码
                System.out.println("Chunk " + (i + 1) + " ASCII values:");
                //System.out.println(Arrays.toString(chunk));

                ChunkMessage message = new ChunkMessage(song.getAudioId(), i, numberOfChunks1, chunk, 2);

                SendResult<Long, Object> result = kafkaTemplate.send(TOPIC_NAME, 0, song.getAudioId(), message).get();

                RecordMetadata metadata = result.getRecordMetadata();

                System.out.println("Message sent to topic:" + metadata.topic() +
                        " partition:" + metadata.partition() +
                        " offset:" + metadata.offset() +
                        " at time:" + metadata.timestamp());
            }




            Long songId = song.getSongId();

            byte[] songData = (byte[]) redisTemplate.opsForValue().get(songId.toString());

            // 打印原始byte[]数组的ASCII码
            System.out.println("Original byte[] ASCII values:");
            //System.out.println(Arrays.toString(songData));


            int numberOfChunks = (int) Math.ceil((double) songData.length / CHUNK_SIZE);

            for (int i = 0; i < numberOfChunks; i++) {

                int start = i * CHUNK_SIZE;
                int end = Math.min(songData.length , start + CHUNK_SIZE);

                byte[] chunk = new byte[end - start];
                System.arraycopy(songData, start, chunk, 0, end - start);

                // 打印每个分片的ASCII码
                System.out.println("Chunk " + (i + 1) + " ASCII values:");
                //System.out.println(Arrays.toString(chunk));

                ChunkMessage message = new ChunkMessage(songId, i, numberOfChunks, chunk, 3);

                SendResult<Long, Object> result = kafkaTemplate.send(TOPIC_NAME, 0, songId, message).get();

                RecordMetadata metadata = result.getRecordMetadata();

                System.out.println("Message sent to topic:" + metadata.topic() +
                        " partition:" + metadata.partition() +
                        " offset:" + metadata.offset() +
                        " at time:" + metadata.timestamp());
            }


        }


        return Result.success("add byte[] data in kafka successful, please get the data using WebSocket!");
    }


    /**
     * send user announcement to the frontend using WebSocket while user register
     * @param userSaveVO
     * @throws ExecutionException
     * @throws InterruptedException
     */
    public void sendUserAudio(UserSaveVO userSaveVO) throws ExecutionException, InterruptedException {
        byte[] userAudio = userSaveVO.getUserAudioData();
        Long userId = userSaveVO.getId();
        int numberOfChunks = (int) Math.ceil((double) userAudio.length / CHUNK_SIZE);

        for (int i = 0; i < numberOfChunks; i++) {

            int start = i * CHUNK_SIZE;
            int end = Math.min(userAudio.length, start + CHUNK_SIZE);

            byte[] chunk = new byte[end - start];
            System.arraycopy(userAudio, start, chunk, 0, end - start);

            ChunkMessage message = new ChunkMessage(userId, i, numberOfChunks, chunk, 1);

            SendResult<Long, Object> result = kafkaTemplate.send(TOPIC_NAME, 0, userId, message).get();

            RecordMetadata metadata = result.getRecordMetadata();

            System.out.println("Message sent to topic:" + metadata.topic() +
                    " partition:" + metadata.partition() +
                    " offset:" + metadata.offset() +
                    " at time:" + metadata.timestamp());
        }
    }


    public void sendSongAnnouncement(Long id) throws IOException, ExecutionException, InterruptedException {

        Song song = kafkaService.getSongById(id);

        //TODO send each song's announcement grab from redis to frontend using kafka


        byte[] songAudioData;
        if(song.getAudioId() != null){
            songAudioData = (byte[]) redisTemplate.opsForValue().get(song.getAudioId().toString());
        }else{
            TTSUtil ttsUtil = new TTSUtil();
            SnowFlake snowFlake = new SnowFlake(1,1);
            //generate user info audio
            Long songAudioId = snowFlake.nextId();
            String songMessage = "Next song name is" + song.getName();
            songAudioData = ttsUtil.getByteFile(songMessage, OutputFormat.Mp3);
            redisTemplate.opsForValue().set(songAudioId.toString(), songAudioData);
            kafkaService.updateSongAudioId(songAudioId, song.getSongId());
        }

        int numberOfChunks1 = (int) Math.ceil((double) songAudioData.length / CHUNK_SIZE);

        for (int i = 0; i < numberOfChunks1; i++) {

            int start = i * CHUNK_SIZE;
            int end = Math.min(songAudioData.length , start + CHUNK_SIZE);

            byte[] chunk = new byte[end - start];
            System.arraycopy(songAudioData, start, chunk, 0, end - start);

            // 打印每个分片的ASCII码
            System.out.println("Chunk " + (i + 1) + " ASCII values:");
            //System.out.println(Arrays.toString(chunk));

            ChunkMessage message = new ChunkMessage(song.getAudioId(), i, numberOfChunks1, chunk, 2);

            SendResult<Long, Object> result = kafkaTemplate.send(TOPIC_NAME, 0, song.getAudioId(), message).get();

            RecordMetadata metadata = result.getRecordMetadata();

            System.out.println("Message sent to topic:" + metadata.topic() +
                    " partition:" + metadata.partition() +
                    " offset:" + metadata.offset() +
                    " at time:" + metadata.timestamp());
        }
    }

    public void sendUserAnnouncement(Long id) throws IOException, ExecutionException, InterruptedException {
        User user = kafkaService.getUserById(id);

        //TODO send each song's announcement grab from redis to frontend using kafka


        byte[] userAudioData;
        if(user.getAudio() != null){
            userAudioData = (byte[]) redisTemplate.opsForValue().get(user.getAudio().toString());
        }else{
            TTSUtil ttsUtil = new TTSUtil();
            SnowFlake snowFlake = new SnowFlake(1,1);
            //generate user info audio
            Long userAudioId = snowFlake.nextId();
            String userMessage = "Next user is" + user.getUserName();
            userAudioData = ttsUtil.getByteFile(userMessage, OutputFormat.Mp3);
            redisTemplate.opsForValue().set(userAudioId.toString(), userAudioData);
            kafkaService.updateUserAudioId(userAudioId, user.getId());
        }

        int numberOfChunks1 = (int) Math.ceil((double) userAudioData.length / CHUNK_SIZE);

        for (int i = 0; i < numberOfChunks1; i++) {

            int start = i * CHUNK_SIZE;
            int end = Math.min(userAudioData.length , start + CHUNK_SIZE);

            byte[] chunk = new byte[end - start];
            System.arraycopy(userAudioData, start, chunk, 0, end - start);

            // 打印每个分片的ASCII码
            System.out.println("Chunk " + (i + 1) + " ASCII values:");
            //System.out.println(Arrays.toString(chunk));

            ChunkMessage message = new ChunkMessage(user.getAudio(), i, numberOfChunks1, chunk, 1);

            SendResult<Long, Object> result = kafkaTemplate.send(TOPIC_NAME, 0, user.getId(), message).get();

            RecordMetadata metadata = result.getRecordMetadata();

            System.out.println("Message sent to topic:" + metadata.topic() +
                    " partition:" + metadata.partition() +
                    " offset:" + metadata.offset() +
                    " at time:" + metadata.timestamp());
        }
    }

}
