package com.capstone.service;

import com.capstone.dto.RaceListDTO;
import com.capstone.vo.RaceListVO;

import java.util.List;

public interface CompetitionService {
    RaceListVO addRaceList(RaceListDTO raceListDTO);

    List<RaceListVO> getRaceLists(Long currentId);
}
