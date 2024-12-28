package com.capstone.util;

import com.amazonaws.auth.DefaultAWSCredentialsProviderChain;
import com.amazonaws.services.polly.AmazonPolly;
import com.amazonaws.services.polly.AmazonPollyClientBuilder;
import com.amazonaws.services.polly.model.OutputFormat;
import com.amazonaws.services.polly.model.SynthesizeSpeechRequest;
import com.amazonaws.services.polly.model.SynthesizeSpeechResult;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;

/**
 * using AWS Text To Speech generate a byte[] file, and give to the frontend or store to the Redis
 */
public class TTSUtil {

    private final AmazonPolly polly;

    public TTSUtil() {
        // Initialize Amazon Polly client with default credentials and region
        polly = AmazonPollyClientBuilder.standard()
                .withCredentials(new DefaultAWSCredentialsProviderChain())
                .withRegion("us-east-1") // You can change the region if needed
                .build();
    }

    /**
     * create and return a byte[] type file
     * @param text
     * @param format
     * @return
     * @throws IOException
     */
    public byte[] getByteFile(String text, OutputFormat format) throws IOException {
        // Prepare the request for synthesizing speech
        SynthesizeSpeechRequest synthReq = new SynthesizeSpeechRequest()
                .withText(text)
                .withVoiceId("Joanna") // Example voice ID, change as needed
                .withOutputFormat(format)
                .withLanguageCode("en-US")
                .withEngine("neural");

        // Synthesize the speech and get the audio stream
        SynthesizeSpeechResult synthRes = polly.synthesizeSpeech(synthReq);
        try (InputStream audioStream = synthRes.getAudioStream();
             ByteArrayOutputStream buffer = new ByteArrayOutputStream()) {
            int nRead;
            byte[] data = new byte[1024];
            while ((nRead = audioStream.read(data, 0, data.length)) != -1) {
                buffer.write(data, 0, nRead);
            }
            buffer.flush();
            return buffer.toByteArray();
        }
    }
}
