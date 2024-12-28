package com.capstone;

import com.capstone.entity.Song;
import com.capstone.service.ListService;
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
public class SongSelectionTests {

    @MockBean
    private ListService listService;

    @Test
    void testSongSelectionByDifficultyBeginner() {
        Song beginnerSong = Song.builder()
                .id(1L)
                .name("Beginner Song")
                .difficultyLevel(1)
                .build();
        Mockito.when(listService.getSongsByLevel(1)).thenReturn(Arrays.asList(beginnerSong));

        List<Song> result = listService.getSongsByLevel(1);
        assertNotNull(result);
        assertFalse(result.isEmpty());
        assertEquals(1, result.get(0).getDifficultyLevel());
        assertEquals("Beginner Song", result.get(0).getName());
    }

    @Test
    void testNoSongsForDifficultyExpert() {
        Mockito.when(listService.getSongsByLevel(3)).thenReturn(Arrays.asList());

        List<Song> result = listService.getSongsByLevel(3);
        assertNotNull(result);
        assertTrue(result.isEmpty());
    }
}
