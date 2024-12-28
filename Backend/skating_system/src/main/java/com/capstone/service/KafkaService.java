package com.capstone.service;

import com.capstone.entity.Song;
import com.capstone.entity.SongList;
import com.capstone.entity.User;
import com.capstone.vo.SongListVO;

public interface KafkaService {
    SongListVO getByListId(Long id);

    Long getUserAudio(Long userId);

    void updateSongAudioId(Long songAudioId, Long songId);

    Song getSongById(Long id);

    User getUserById(Long id);

    void updateUserAudioId(Long userAudioId, Long id);
}
