package com.capstone.controller;

import com.capstone.common.BaseContext;
import com.capstone.dto.RaceListDTO;
import com.capstone.result.Result;
import com.capstone.service.CompetitionService;
import com.capstone.vo.RaceListVO;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/competition")
public class CompetitionController {

    @Autowired
    private CompetitionService competitionService;

    @PostMapping("/addRaceList")
    public Result<RaceListVO> addRaceList(@RequestBody RaceListDTO raceListDTO){
        RaceListVO raceListVO = competitionService.addRaceList(raceListDTO);
        return Result.success(raceListVO);
    }

    @GetMapping("/getRaceList")
    public Result<List<RaceListVO>> getRaceList(){
        Long currentId = BaseContext.getCurrentId();
        List<RaceListVO> raceLists = competitionService.getRaceLists(currentId);
        return Result.success(raceLists);
    }
}
