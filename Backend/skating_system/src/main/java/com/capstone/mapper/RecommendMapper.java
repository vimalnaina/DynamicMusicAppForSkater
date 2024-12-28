package com.capstone.mapper;

import com.capstone.entity.Song;
import com.capstone.vo.FavouriteVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface RecommendMapper {

    int isExist(@Param("userId") Long userId, @Param("songId") Long songId);

    void insertRecord(@Param("userId") Long userId, @Param("songId") Long songId);

    void updateCount(@Param("userId") Long userId, @Param("songId") Long songId);

    List<FavouriteVO> getFavouriteList(Long userId);

    @Select("select capstone.song.* FROM capstone.song where capstone.song.id = #{songId}")
    Song getSong(Long songId);
}
