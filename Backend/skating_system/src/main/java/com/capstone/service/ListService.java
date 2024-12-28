package com.capstone.service;

import com.capstone.dto.SongListDTO;
import com.capstone.entity.Song;
import com.capstone.entity.SongList;
import com.capstone.vo.SongListVO;

import java.util.List;

public interface ListService {
    /**
     * add a new songList and return this new songList Info
     * @param songListDTO
     * @return
     */
    SongListVO addSongList(SongListDTO songListDTO);

    /**
     * get Songs by difficulty Level
     * @param level
     * @return
     */
    List<Song> getSongsByLevel(int level);

    List<SongListVO> getListsByUserId(Long userId);
}
