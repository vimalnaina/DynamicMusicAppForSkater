package com.capstone.service.Impl;

import com.amazonaws.services.polly.model.OutputFormat;
import com.capstone.common.BaseContext;
import com.capstone.exception.BaseException;
import com.capstone.common.MusicDuration;
import com.capstone.common.SnowFlake;

import com.capstone.entity.SongList;
import com.capstone.mapper.MusicMapper;
import com.capstone.entity.Song;
import com.capstone.service.MusicService;
import com.capstone.util.TTSUtil;
import com.capstone.vo.SongInfoVO;
import com.capstone.vo.SongListVO;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class MusicServiceImpl implements MusicService {

    @Autowired
    private MusicMapper musicMapper;

    @Autowired
    private MusicDuration musicDuration;

    @Autowired
    private RedisTemplate redisTemplate;

    @Override
    public void uploadMusic(MultipartFile musicData, int difficultyLevel, String singer, String songName, MultipartFile imageData) throws IOException {
        SnowFlake snowFlake = new SnowFlake(1, 1);
        TTSUtil ttsUtil = new TTSUtil();
        int time = musicDuration.getDuration(musicData);
        Song song = new Song();
        Long songId = snowFlake.nextId();
        Long coverImageId = snowFlake.nextId();
        song.setId(songId);
        song.setDuration(time);
        song.setDifficultyLevel(difficultyLevel);
        song.setName(songName);
        song.setSongId(songId);
        song.setSinger(singer);
        song.setCreateTime(LocalDateTime.now());
        song.setImageId(coverImageId);
        song.setCreateUserId(BaseContext.getCurrentId());

        redisTemplate.opsForValue().set(songId.toString(), musicData.getBytes());
        redisTemplate.opsForValue().set(coverImageId.toString(), imageData.getBytes());

        //generate this song's announcement, and storage it into redis
        byte[] songAnnounce = ttsUtil.getByteFile("Next music is" + songName, OutputFormat.Mp3);
        Long audioId = snowFlake.nextId();
        redisTemplate.opsForValue().set(audioId.toString(), songAnnounce);
        song.setAudioId(audioId);

        musicMapper.uploadMusic(song);
        return;
    }

//    @Override
//    public SongByteVO getById(Long id) {
//        return musicMapper.getById(id);
//    }

    @Override
    public SongInfoVO getInfoById(Long songId) {
        return musicMapper.getInfoById(songId);
    }

    @Override
    public SongListVO getListById(Long userId) {

        List<Song> songs = musicMapper.getSongsByUserId(userId);
        SongList songList = musicMapper.getListInfoByUserId(userId);
        if(songList == null){
            throw new BaseException("you didn't have your song list");
        }
        SongListVO songListVO = new SongListVO();
        BeanUtils.copyProperties(songList, songListVO);
        songListVO.setSongList(songs);
        return songListVO;
    }
}
