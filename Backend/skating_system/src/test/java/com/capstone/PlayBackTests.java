package com.capstone;

import com.capstone.entity.Song;
import com.capstone.service.MusicService;
import com.capstone.vo.SongInfoVO;
import com.capstone.vo.SongListVO;

import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;

import static org.junit.jupiter.api.Assertions.*;


//@SpringBootTest
@SpringBootTest(properties = {
        "spring.kafka.bootstrap-servers=localhost:9092",
        "spring.kafka.consumer.enable-auto-commit=false"
})
public class PlayBackTests {

    @MockBean
    private MusicService musicService;

    @Test
    void testGetSongInfoById() {
        SongInfoVO mockSongInfo = SongInfoVO.builder()
                .id(123L)
                .name("Test Song")
                .singer("Test Singer")
                .duration(120)
                .build();

        Mockito.when(musicService.getInfoById(123L)).thenReturn(mockSongInfo);

        SongInfoVO result = musicService.getInfoById(123L);
        assertNotNull(result);
        assertEquals("Test Song", result.getName());
        assertEquals("Test Singer", result.getSinger());
        assertEquals(120, result.getDuration());
    }

    @Test
    void testGetSongListByUserId() {
        SongListVO mockSongList = SongListVO.builder()
                .userId(1L)
                .listName("Test Playlist")
                .build();

        Mockito.when(musicService.getListById(1L)).thenReturn(mockSongList);

        SongListVO result = musicService.getListById(1L);
        assertNotNull(result);
        assertEquals("Test Playlist", result.getListName());
    }
}
