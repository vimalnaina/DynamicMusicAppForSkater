package com.capstone.mapper;

import com.capstone.entity.Song;
import com.capstone.entity.SongList;
import com.capstone.vo.SongByteVO;
import com.capstone.vo.SongInfoVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface MusicMapper {
    void uploadMusic(Song song);

//    @Select("select name,file from capstone.song where id = #{id}")
//    SongByteVO getById(Long id);

    @Select("select id, name, singer, difficultyLevel, duration, create_time, create_userId, audio_id from capstone.song where id = #{id}")
    SongInfoVO getInfoById(Long id);

    List<Song> getSongsByUserId(Long userId);

    SongList getListInfoByUserId(Long userId);
}
