package com.capstone.service;

import com.capstone.entity.Song;
import com.capstone.vo.SongByteVO;
import com.capstone.vo.SongInfoVO;
import com.capstone.vo.SongListVO;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

public interface MusicService {
    void uploadMusic(MultipartFile musicData, int difficultyLevel, String singer, String songName, MultipartFile imageData) throws IOException;

    //SongByteVO getById(Long id);

    SongInfoVO getInfoById(Long songId);

    SongListVO getListById(Long userId);
}
