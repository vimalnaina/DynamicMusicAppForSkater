package com.capstone.controller;

import com.capstone.common.BaseContext;
import com.capstone.config.RedisConfig;
import com.capstone.entity.Song;
import com.capstone.exception.BaseException;
import com.capstone.result.Result;
import com.capstone.service.MusicService;
import com.capstone.vo.SongByteVO;
import com.capstone.vo.SongInfoVO;
import com.capstone.vo.SongListVO;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.StringRedisSerializer;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.beans.beancontext.BeanContext;
import java.io.*;
import java.net.URLEncoder;
import java.util.List;

@RestController
@RequestMapping("/music")
@Api(tags = "music relevant")
@Slf4j
public class MusicController {

    @Autowired
    private MusicService musicService;

    @Autowired
    private RedisTemplate redisTemplate;


    @GetMapping("/{id}")
    @ApiOperation(value = "get song data by song_id")
    public void getById(@PathVariable Long id, HttpServletResponse response) throws IOException {
        byte[] songData = (byte[]) redisTemplate.opsForValue().get(id.toString());
        response.setHeader("Content-Disposition", "inline");
        // 设置 MIME 类型为音频
        response.setContentType("audio/mpeg");
        // 创建一个 ByteArrayInputStream 来读取字节数组
        InputStream in = new ByteArrayInputStream(songData);
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

    @GetMapping("/info/{id}")
    @ApiOperation("get song info by song_id")
    public Result<SongInfoVO> getInfoById(@PathVariable Long songId){
        SongInfoVO songInfoVO = musicService.getInfoById(songId);
        return Result.success(songInfoVO);
    }

    @PostMapping(value = "uploadSong", consumes = "multipart/form-data")
    @ApiOperation(value = "upload song")
    public Result uploadSong(@RequestParam(value = "musicData") MultipartFile musicData,
                                   @RequestParam(value = "imageData") MultipartFile imageData,
                                   @RequestParam(value = "difficultyLevel") int difficultyLevel,
                                   @RequestParam(value = "singer") String singer,
                             @RequestParam(value = "songName") String songName) throws IOException {

        if(!musicData.isEmpty() && !imageData.isEmpty()){
            musicService.uploadMusic(musicData, difficultyLevel, singer, songName, imageData);
        }else{
            throw new BaseException("missing music or cover image data...");
        }


        return Result.success("upload success!");
    }



    @GetMapping("/list")
    public Result<SongListVO> getSongList(){
        log.info("start get song list from server");
        Long userId = BaseContext.getCurrentId();
        SongListVO songListVO = musicService.getListById(userId);
        return Result.success(songListVO);
    }
}
