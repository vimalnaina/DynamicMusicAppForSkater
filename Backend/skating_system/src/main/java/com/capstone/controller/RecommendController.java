package com.capstone.controller;

import com.capstone.common.BaseContext;
import com.capstone.entity.Song;
import com.capstone.result.Result;
import com.capstone.service.MusicService;
import com.capstone.service.RecommendService;
import com.capstone.vo.FavouriteInfoVO;
import com.capstone.vo.FavouriteVO;
import com.capstone.vo.SongInfoVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/recommend")
public class RecommendController {

    @Autowired
    private RecommendService recommendService;

    @Autowired
    private MusicService musicService;

    @GetMapping("/add/{songId}")
    public Result addCount(@PathVariable Long songId) {
        Long userId = BaseContext.getCurrentId();
        recommendService.isExist(userId, songId);
        return Result.success();
    }

    @GetMapping("/favourite")
    public Result<List<FavouriteInfoVO>> getFavouriteSongList() {
        Long userId = BaseContext.getCurrentId();
        List<FavouriteVO> favouriteVOS = recommendService.getFavouriteList(userId);
        List<FavouriteInfoVO> favouriteInfoVOS = new ArrayList<>();
        for (FavouriteVO favouriteVO : favouriteVOS) {
            Long songId = favouriteVO.getSongId();
            Song song = recommendService.getInfoById(songId);
            FavouriteInfoVO favouriteInfoVO = new FavouriteInfoVO(song, favouriteVO.getCount());
            favouriteInfoVOS.add(favouriteInfoVO);
        }
        return Result.success(favouriteInfoVOS);
    }
}
