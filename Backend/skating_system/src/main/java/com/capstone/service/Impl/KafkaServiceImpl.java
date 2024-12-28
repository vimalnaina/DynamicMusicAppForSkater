package com.capstone.service.Impl;

import com.capstone.entity.Song;
import com.capstone.entity.SongList;
import com.capstone.entity.User;
import com.capstone.exception.BaseException;
import com.capstone.mapper.KafkaMapper;
import com.capstone.service.KafkaService;
import com.capstone.vo.SongListVO;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class KafkaServiceImpl implements KafkaService {

    @Autowired
    private KafkaMapper kafkaMapper;

    @Override
    public SongListVO getByListId(Long id) {

        List<Song> songs = kafkaMapper.getListById(id);
        SongList songList = kafkaMapper.getListInfo(id);
        if(songList == null){
            throw new BaseException("Did not have this song list id...");
        }
        SongListVO songListVO = new SongListVO();
        BeanUtils.copyProperties(songList, songListVO);
        songListVO.setSongList(songs);
        return songListVO;
    }

    @Override
    public Long getUserAudio(Long userId) {
        Long audioId = kafkaMapper.getUserAudio(userId);
        return audioId;
    }

    @Override
    public void updateSongAudioId(Long songAudioId, Long songId) {
        kafkaMapper.updateSongAudioId(songAudioId, songId);
    }

    @Override
    public Song getSongById(Long id) {
        Song song = kafkaMapper.getSongById(id);
        return song;
    }

    @Override
    public User getUserById(Long id) {
        User user = kafkaMapper.getUserById(id);
        return user;
    }

    @Override
    public void updateUserAudioId(Long userAudioId, Long id) {
        kafkaMapper.updateUserAudioId(userAudioId, id);
    }


}
