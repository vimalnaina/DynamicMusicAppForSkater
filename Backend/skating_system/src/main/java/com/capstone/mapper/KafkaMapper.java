package com.capstone.mapper;

import com.capstone.entity.Song;
import com.capstone.entity.SongList;
import com.capstone.entity.User;
import com.capstone.vo.SongListVO;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;

@Mapper
public interface KafkaMapper {
    List<Song> getListById(Long id);

    SongList getListInfo(Long id);

    @Select("select capstone.user.audio from user where id = #{userId}")
    Long getUserAudio(Long userId);

    @Update("update capstone.song set audio_id = #{songAudioId} where song_id = #{songId}" )
    void updateSongAudioId(Long songAudioId, Long songId);

    @Select("select capstone.song.* from song where song_id = #{id}")
    Song getSongById(Long id);

    @Select("select capstone.user.* from user where id = #{id}")
    User getUserById(Long id);

    @Update("update capstone.user set audio = #{userAudioId} where id = #{id}")
    void updateUserAudioId(Long userAudioId, Long id);
}
