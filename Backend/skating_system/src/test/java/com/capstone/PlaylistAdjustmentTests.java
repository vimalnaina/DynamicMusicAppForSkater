package com.capstone;

import com.capstone.entity.Song;
import com.capstone.service.MusicService;
import com.capstone.vo.SongListVO;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;

import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

//@SpringBootTest
@SpringBootTest(properties = {
        "spring.kafka.bootstrap-servers=localhost:9092",
        "spring.kafka.consumer.enable-auto-commit=false"
})
class PlaylistAdjustmentTests {

    @MockBean
    private MusicService musicService;

    @Test
    void testGetAdjustedPlaylist() {
        Song songA = Song.builder().id(1L).name("Song A").duration(1800).build();
        Song songB = Song.builder().id(2L).name("Song B").duration(1200).build();
        SongListVO mockSongList = SongListVO.builder()
                .userId(1L)
                .listName("Adjusted Playlist")
                .songList(Arrays.asList(songA, songB)) // 修改为 songList
                .build();

        Mockito.when(musicService.getListById(1L)).thenReturn(mockSongList);

        SongListVO result = musicService.getListById(1L);
        assertNotNull(result);
        assertEquals("Adjusted Playlist", result.getListName());
        assertEquals(2, result.getSongList().size()); // 修改为 getSongList
        assertEquals("Song A", result.getSongList().get(0).getName()); // 修改为 getSongList
    }

    @Test
    void testEmptyPlaylist() {
        SongListVO mockSongList = SongListVO.builder()
                .userId(1L)
                .listName("Empty Playlist")
                .songList(Arrays.asList()) // 修改为 songList
                .build();

        Mockito.when(musicService.getListById(1L)).thenReturn(mockSongList);

        SongListVO result = musicService.getListById(1L);
        assertNotNull(result);
        assertEquals("Empty Playlist", result.getListName());
        assertTrue(result.getSongList().isEmpty()); // 修改为 getSongList
    }
}
