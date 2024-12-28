package com.capstone.controller;

import com.capstone.result.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
import java.util.concurrent.ExecutionException;

@RestController
@RequestMapping("/announcement")
public class AnnouncementController {

    @Autowired
    private KafkaController kafkaController;

    @GetMapping("/song/{id}")
    public Result getSongAnnouncement(@PathVariable Long id) throws IOException, ExecutionException, InterruptedException {
        kafkaController.sendSongAnnouncement(id);
        return Result.success();
    }

    @GetMapping("/user/{id}")
    public Result getUserAnnouncement(@PathVariable Long id) throws IOException, ExecutionException, InterruptedException {
        kafkaController.sendUserAnnouncement(id);
        return Result.success();
    }
}
