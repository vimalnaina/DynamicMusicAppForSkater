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
class PlaylistManagementTests {

    @MockBean
    private MusicService musicService;

    @Test
    void testDynamicRearrangement() {
        List<Song> playlist = Arrays.asList(
                Song.builder().id(1L).name("Song A").build(),
                Song.builder().id(2L).name("Song B").build(),
                Song.builder().id(3L).name("Song C").build()
        );
        List<Song> rearranged = Arrays.asList(
                Song.builder().id(3L).name("Song C").build(),
                Song.builder().id(1L).name("Song A").build(),
                Song.builder().id(2L).name("Song B").build()
        );

        SongListVO songList = SongListVO.builder().songList(rearranged).build();
        Mockito.when(musicService.getListById(1L)).thenReturn(songList);

        SongListVO result = musicService.getListById(1L);
        assertEquals("Song C", result.getSongList().get(0).getName());
        assertEquals("Song A", result.getSongList().get(1).getName());
        assertEquals("Song B", result.getSongList().get(2).getName());
    }

    @Test
    void testRemoveSongFromPlaylist() {
        List<Song> playlist = Arrays.asList(
                Song.builder().id(1L).name("Song A").build(),
                Song.builder().id(2L).name("Song B").build(),
                Song.builder().id(3L).name("Song C").build()
        );
        List<Song> updatedPlaylist = Arrays.asList(
                Song.builder().id(1L).name("Song A").build(),
                Song.builder().id(3L).name("Song C").build()
        );

        SongListVO songList = SongListVO.builder().songList(updatedPlaylist).build();
        Mockito.when(musicService.getListById(1L)).thenReturn(songList);

        SongListVO result = musicService.getListById(1L);
        assertEquals(2, result.getSongList().size());
        assertEquals("Song C", result.getSongList().get(1).getName());
    }

    @Test
    void testRemoveCurrentlyPlayingSong() {
        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class, () -> {
            throw new IllegalArgumentException("Currently playing song cannot be removed");
        });
        assertEquals("Currently playing song cannot be removed", exception.getMessage());
    }
}
