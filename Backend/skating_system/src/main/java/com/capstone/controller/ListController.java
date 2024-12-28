package com.capstone.controller;


import com.capstone.common.BaseContext;
import com.capstone.dto.SongListDTO;
import com.capstone.entity.Song;
import com.capstone.entity.SongList;
import com.capstone.result.Result;
import com.capstone.service.ListService;
import com.capstone.vo.SongListVO;
import io.swagger.annotations.Api;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/list")
@Api("skater history list relevant")
public class ListController {

    @Autowired
    private ListService listService;

    /**
     * add song list manually
     * @param songListDTO
     * @return
     */
    @PostMapping("/add")
    public Result<SongListVO> addSongList(@RequestBody SongListDTO songListDTO){
        SongListVO songListVO = listService.addSongList(songListDTO);
        return Result.success(songListVO);
    }

    /**
     * get songs by difficulty level
     * @param level
     * @return
     */
    @GetMapping("/{level}")
    public Result<List<Song>> getSongsByLevel(@PathVariable int level) {
        List<Song> songs = listService.getSongsByLevel(level);
        return Result.success(songs);
    }

    /**
     * get now login user's all songlist
     * @return
     */
    @GetMapping
    public Result<List<SongListVO>> getAllInfoByUserId(){
        Long userId = BaseContext.getCurrentId();
        List<SongListVO> songListVOS = listService.getListsByUserId(userId);
        return Result.success(songListVOS);
    }
}
