package com.capstone.common;

import com.mpatric.mp3agic.ID3v2;
import com.mpatric.mp3agic.Mp3File;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;

@Component
public class MusicDuration {
    public int getDuration(MultipartFile file) {
        try {
            // Convert MultipartFile to InputStream
            InputStream input = file.getInputStream();

            // Create a temporary file to read MP3 properties
            java.nio.file.Path tempFile = Files.createTempFile("upload_", ".mp3");
            Files.copy(input, tempFile, StandardCopyOption.REPLACE_EXISTING);

            Mp3File mp3file = new Mp3File(tempFile.toFile());
            int duration = (int) mp3file.getLengthInSeconds();

            // Cleanup: Delete temporary file
            Files.delete(tempFile);

            return duration;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
}
