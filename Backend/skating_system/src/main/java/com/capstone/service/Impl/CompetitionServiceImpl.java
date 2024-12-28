package com.capstone.service.Impl;

import com.capstone.common.BaseContext;
import com.capstone.dto.RaceListDTO;
import com.capstone.dto.SongUserPair;
import com.capstone.entity.Song;
import com.capstone.entity.SongList;
import com.capstone.mapper.ListMapper;
import com.capstone.service.CompetitionService;
import com.capstone.vo.RaceListVO;
import com.capstone.vo.SongListVO;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CompetitionServiceImpl implements CompetitionService {

    @Autowired
    private ListMapper listMapper;



    @Override
    public RaceListVO addRaceList(RaceListDTO raceListDTO) {
        listMapper.insertRaceList(raceListDTO);
        Long songlistId = raceListDTO.getSonglistId();
        System.out.println(raceListDTO.getSonglistId());
        List<SongUserPair> songUserPairs = raceListDTO.getSongUserPairs();
        for (SongUserPair songUserPair : songUserPairs) {
            System.out.println("songId:" + songUserPair.getSongId() + " songListId: " + songlistId);
            listMapper.insertEachRaceSong(songlistId, songUserPair);
        }
        RaceListVO raceListVO = new RaceListVO();
        BeanUtils.copyProperties(raceListDTO, raceListVO);
        raceListVO.setSonglistId(songlistId);
        return raceListVO;
    }

    @Override
    public List<RaceListVO> getRaceLists(Long currentId) {

        return listMapper.getRaceListsByUserId(currentId);
    }
}
