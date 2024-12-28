package com.capstone.service;

import com.capstone.entity.Song;
import com.capstone.vo.FavouriteVO;

import java.util.List;

public interface RecommendService {
    void isExist(Long userId, Long songId);

    List<FavouriteVO> getFavouriteList(Long userId);


    Song getInfoById(Long songId);
}
