package com.capstone.amazon;


import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;

import com.amazonaws.ClientConfiguration;
import com.amazonaws.auth.DefaultAWSCredentialsProviderChain;
import com.amazonaws.regions.Region;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.polly.AmazonPolly;
import com.amazonaws.services.polly.AmazonPollyClient;
import com.amazonaws.services.polly.AmazonPollyClientBuilder;
import com.amazonaws.services.polly.model.DescribeVoicesRequest;
import com.amazonaws.services.polly.model.DescribeVoicesResult;
import com.amazonaws.services.polly.model.OutputFormat;
import com.amazonaws.services.polly.model.SynthesizeSpeechRequest;
import com.amazonaws.services.polly.model.SynthesizeSpeechResult;
import com.amazonaws.services.polly.model.Voice;

import javazoom.jl.player.advanced.AdvancedPlayer;
import javazoom.jl.player.advanced.PlaybackEvent;
import javazoom.jl.player.advanced.PlaybackListener;

public class PollyDemo {
    private final AmazonPolly polly;
    //private final Voice voice;
    private static final String SAMPLE = "Hi, I am YuHan happy to use AWS";

//    public PollyDemo(Region region) {
//        // create an Amazon Polly client in a specific region
//        polly = new AmazonPollyClient(new DefaultAWSCredentialsProviderChain(),
//                new ClientConfiguration());
//        polly.setRegion(region);
//        // Create describe voices request.
//        DescribeVoicesRequest describeVoicesRequest = new DescribeVoicesRequest().withLanguageCode("en-US");
//
//        // Synchronously ask Amazon Polly to describe available TTS voices.
//        DescribeVoicesResult describeVoicesResult = polly.describeVoices(describeVoicesRequest);
//        voice = describeVoicesResult.getVoices().get(0);
//    }

    public PollyDemo() {
        // Initialize Amazon Polly client with default credentials and region
        polly = AmazonPollyClientBuilder.standard()
                .withCredentials(new DefaultAWSCredentialsProviderChain())
                .withRegion("us-east-1") // You can change the region if needed
                .build();
    }

    /**
     * return a InputStream type
     * @param text
     * @param format
     * @return
     * @throws IOException
     */
//    public InputStream synthesize(String text, OutputFormat format) throws IOException {
//        SynthesizeSpeechRequest synthReq =
//                new SynthesizeSpeechRequest()
//                        .withText(text)
//                        .withLanguageCode("en-US")
//                        .withVoiceId("Joanna")
//                        .withOutputFormat(format)
//                        .withEngine("neural");
//        SynthesizeSpeechResult synthRes = polly.synthesizeSpeech(synthReq);
//
//        return synthRes.getAudioStream();
//    }

    /**
     * create and return a byte[] type file
     * @param text
     * @param format
     * @return
     * @throws IOException
     */
    public byte[] synthesize(String text, OutputFormat format) throws IOException {
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

    public static void main(String args[]) throws Exception {
        //create the test class
        PollyDemo pollyDemo = new PollyDemo();
        //get the audio stream
        //InputStream speechStream = pollyDemo.synthesize(SAMPLE, OutputFormat.Mp3);

        byte[] audioBytes = pollyDemo.synthesize(SAMPLE, OutputFormat.Mp3);

//        //create an MP3 player
//        AdvancedPlayer player = new AdvancedPlayer(speechStream,
//                javazoom.jl.player.FactoryRegistry.systemRegistry().createAudioDevice());
//
//        player.setPlayBackListener(new PlaybackListener() {
//            @Override
//            public void playbackStarted(PlaybackEvent evt) {
//                System.out.println("Playback started");
//                System.out.println(SAMPLE);
//            }
//
//            @Override
//            public void playbackFinished(PlaybackEvent evt) {
//                System.out.println("Playback finished");
//            }
//        });
//
//
//        // play it!
//        player.play();

    }
}
