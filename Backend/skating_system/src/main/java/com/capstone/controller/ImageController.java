package com.capstone.controller;


import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;


@RestController
@Api("cover image relevant")
@RequestMapping("/image")
public class ImageController {

    @Autowired
    private RedisTemplate redisTemplate;


    @GetMapping("/{id}")
    @ApiOperation("get cover image data by image_id")
    public void getById(@PathVariable Long id, HttpServletResponse response) throws IOException {
        byte[] imageData = (byte[]) redisTemplate.opsForValue().get(id.toString());

        if(imageData != null){
            response.setContentType(MediaType.IMAGE_JPEG_VALUE);
            response.setHeader(HttpHeaders.CONTENT_DISPOSITION, "inline");

            InputStream in = new ByteArrayInputStream(imageData);
            OutputStream out = response.getOutputStream();

            byte[] buffer = new byte[1024];
            int len;
            while ((len = in.read(buffer)) > 0) {
                out.write(buffer, 0, len);
            }

            in.close();
            out.close();
            return;

        }

    }
}
