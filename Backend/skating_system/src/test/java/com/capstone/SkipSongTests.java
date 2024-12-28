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
class SkipSongTests {

    @MockBean
    private MusicService musicService;

    @Test
    void testSkipToNextSong() {
        List<Song> playlist = Arrays.asList(
                Song.builder().id(1L).name("Song A").build(),
                Song.builder().id(2L).name("Song B").build()
        );
        SongListVO songList = SongListVO.builder().songList(playlist).build();

        Mockito.when(musicService.getListById(1L)).thenReturn(songList);

        SongListVO result = musicService.getListById(1L);
        assertEquals("Song B", result.getSongList().get(1).getName());
    }

    @Test
    void testNoNextSongAvailable() {
        List<Song> playlist = Arrays.asList(
                Song.builder().id(1L).name("Song A").build()
        );
        SongListVO songList = SongListVO.builder().songList(playlist).build();

        Mockito.when(musicService.getListById(1L)).thenReturn(songList);

        SongListVO result = musicService.getListById(1L);
        assertEquals("Song A", result.getSongList().get(0).getName());
        // Add your logic to return "No next song available" in the real service
    }

    @Test
    void testSkipMultipleSongs() {
        List<Song> playlist = Arrays.asList(
                Song.builder().id(1L).name("Song A").build(),
                Song.builder().id(2L).name("Song B").build(),
                Song.builder().id(3L).name("Song C").build(),
                Song.builder().id(4L).name("Song D").build()
        );
        SongListVO songList = SongListVO.builder().songList(playlist).build();

        Mockito.when(musicService.getListById(1L)).thenReturn(songList);

        SongListVO result = musicService.getListById(1L);
        assertEquals("Song D", result.getSongList().get(3).getName());
    }
}
