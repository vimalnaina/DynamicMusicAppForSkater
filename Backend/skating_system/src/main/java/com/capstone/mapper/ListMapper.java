package com.capstone.mapper;

import com.capstone.dto.RaceListDTO;
import com.capstone.dto.SongListDTO;
import com.capstone.dto.SongUserPair;
import com.capstone.entity.Song;
import com.capstone.entity.SongList;
import com.capstone.vo.RaceListVO;
import com.capstone.vo.SongListVO;
import org.apache.ibatis.annotations.*;

import java.time.LocalDateTime;
import java.util.List;

@Mapper
public interface ListMapper {

//    @Insert("insert into capstone.songlist(user_id, list_name, description)" +
//            "value" +
//            "(#{userId}, #{listName}, #{description})")
//    @Options(useGeneratedKeys = true, keyColumn = "songlist_id")
    Long insert(SongListDTO songListDTO);

    @Insert("insert into capstone.songlist_song(songlist_id, song_id)" +
            "values" +
            "(#{songListId}, #{songId})")
    void insertEachSong(Long songListId, Long songId);

    List<Song> getSongsInfo(Long songListId);

    @Select("select capstone.songlist.* from songlist where songlist_id = #{songListId}")
    SongList getSongList(Long songListId);

    @Select("select capstone.song.* from song where difficultyLevel = #{level}")
    List<Song> getSongsByLevel(int level);

    List<Song> getSongs(Long songlistId);

    @Select("select songlist.* from songlist where songlist.user_id = #{userId}")
    List<SongList> getSongLists(Long userId);


    void insertRaceList(RaceListDTO raceListDTO);

    @Insert("insert into capstone.songlist_song(songlist_id, song_id, performer_name, performer_id) " +
            "values " +
            "(#{songlistId}, #{songUserPair.songId}, #{songUserPair.userName}, #{songUserPair.userId})")
    void insertEachRaceSong(@Param("songlistId") Long songlistId, @Param("songUserPair") SongUserPair songUserPair);


    List<RaceListVO> getRaceListsByUserId(Long currentId);
}
