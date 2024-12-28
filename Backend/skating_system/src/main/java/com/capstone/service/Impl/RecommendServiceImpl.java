package com.capstone.service.Impl;

import com.capstone.entity.Song;
import com.capstone.mapper.RecommendMapper;
import com.capstone.service.RecommendService;
import com.capstone.vo.FavouriteVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class RecommendServiceImpl implements RecommendService {

    @Autowired
    private RecommendMapper recommendMapper;

    @Override
    public void isExist(Long userId, Long songId) {
        // 查询是否存在记录
        int count = recommendMapper.isExist(userId, songId);

        if (count == 0) {
            // 如果不存在，插入新记录
            recommendMapper.insertRecord(userId, songId);
        } else {
            // 如果存在，更新记录的 count 值
            recommendMapper.updateCount(userId, songId);
        }
    }

    @Override
    public List<FavouriteVO> getFavouriteList(Long userId) {
        return recommendMapper.getFavouriteList(userId);
    }

    @Override
    public Song getInfoById(Long songId) {
        Song song = recommendMapper.getSong(songId);
        return song;
    }
}
