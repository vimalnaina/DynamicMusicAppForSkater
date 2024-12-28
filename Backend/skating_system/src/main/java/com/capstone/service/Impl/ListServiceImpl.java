package com.capstone.service.Impl;

import com.capstone.dto.SongListDTO;
import com.capstone.entity.Song;
import com.capstone.entity.SongList;
import com.capstone.mapper.ListMapper;
import com.capstone.service.ListService;
import com.capstone.vo.SongListVO;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
public class ListServiceImpl implements ListService {

    @Autowired
    private ListMapper listMapper;


    @Override
    public SongListVO addSongList(SongListDTO songListDTO) {
        Long songlistId = listMapper.insert(songListDTO);
        List<Long> songIds = songListDTO.getSongIds();
        for (Long songId : songIds) {
            System.out.println("songId:" + songId + " songListId: " + songListDTO.getSonglistId());
            listMapper.insertEachSong(songListDTO.getSonglistId(), songId);
        }
        List<Song> songs = listMapper.getSongsInfo(songListDTO.getSonglistId());
        SongList songList = listMapper.getSongList(songListDTO.getSonglistId());
        SongListVO songListVO = new SongListVO();
        BeanUtils.copyProperties(songList, songListVO);
        songListVO.setSongList(songs);
        return songListVO;
    }

    @Override
    public List<Song> getSongsByLevel(int level) {
        List<Song> songs = listMapper.getSongsByLevel(level);
        return songs;
    }

    @Override
    public List<SongListVO> getListsByUserId(Long userId) {
        List<SongListVO> songListVOs = new ArrayList<>();
        List<SongList> songLists = listMapper.getSongLists(userId);
        for (SongList songList : songLists) {
            Long songlistId = songList.getSonglistId();
            List<Song> songs = listMapper.getSongs(songlistId);
            SongListVO songListVO = new SongListVO();
            BeanUtils.copyProperties(songList, songListVO);
            songListVO.setSongList(songs);
            songListVOs.add(songListVO);
        }

        return songListVOs;
    }


}
