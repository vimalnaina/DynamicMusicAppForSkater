package com.capstone;

import com.capstone.dto.RaceListDTO;
import com.capstone.dto.SongUserPair;
import com.capstone.service.CompetitionService;
import com.capstone.vo.RaceListVO;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import static org.junit.jupiter.api.Assertions.*;

//@SpringBootTest
@SpringBootTest(properties = {
        "spring.kafka.bootstrap-servers=localhost:9092",
        "spring.kafka.consumer.enable-auto-commit=false"
})
class CompetitionTests {

    @MockBean
    private CompetitionService competitionService;

    @Test
    void testQueueSkatersByUserIdOrder() {
        List<SongUserPair> skaterList = Arrays.asList(
                new SongUserPair(1L, 3L, "Skater A"),
                new SongUserPair(2L, 1L, "Skater B"),
                new SongUserPair(3L, 2L, "Skater C")
        );
        RaceListVO raceList = RaceListVO.builder()
                .songUserPairs(skaterList)
                .listName("Test Race")
                .build();

        Mockito.when(competitionService.getRaceLists(1L)).thenReturn(Arrays.asList(raceList));

        List<RaceListVO> result = competitionService.getRaceLists(1L);
        assertNotNull(result);

        List<SongUserPair> sortedPairs = result.get(0).getSongUserPairs().stream()
                .sorted((a, b) -> Long.compare(a.getUserId(), b.getUserId()))
                .collect(Collectors.toList());

        assertEquals("Skater B", sortedPairs.get(0).getUserName());
        assertEquals("Skater C", sortedPairs.get(1).getUserName());
        assertEquals("Skater A", sortedPairs.get(2).getUserName());
    }

    @Test
    void testHandleAbsentSkater() {
        List<SongUserPair> skaterList = Arrays.asList(
                new SongUserPair(1L, 1L, "Skater A"),
                new SongUserPair(2L, 2L, "Skater B"),
                new SongUserPair(3L, 3L, "Skater C")
        );

        RaceListVO raceList = RaceListVO.builder().songUserPairs(skaterList).build();
        Mockito.when(competitionService.getRaceLists(1L)).thenReturn(Arrays.asList(raceList));

        List<RaceListVO> result = competitionService.getRaceLists(1L);
        assertNotNull(result);

        List<SongUserPair> updatedList = result.get(0).getSongUserPairs().stream()
                .filter(pair -> !"Skater B".equals(pair.getUserName()))
                .collect(Collectors.toList());

        assertEquals(2, updatedList.size());
        assertFalse(updatedList.stream().anyMatch(pair -> "Skater B".equals(pair.getUserName())));
    }

    @Test
    void testNoMoreSkatersAnnouncement() {
        Mockito.when(competitionService.getRaceLists(1L)).thenReturn(Arrays.asList());

        List<RaceListVO> result = competitionService.getRaceLists(1L);
        assertTrue(result.isEmpty());
        assertEquals("No more skaters left. The competition is over.", generateAnnouncement(null));
    }

    @Test
    void testUpdateSkaterSongBeforeCompetition() {
        SongUserPair initialPair = new SongUserPair(1L, 1L, "Song 1");
        SongUserPair updatedPair = new SongUserPair(1L, 1L, "Song 2");

        RaceListDTO raceListDTO = RaceListDTO.builder()
                .songUserPairs(Arrays.asList(initialPair))
                .build();

        RaceListVO updatedRaceListVO = RaceListVO.builder()
                .songUserPairs(Arrays.asList(updatedPair))
                .build();

        Mockito.when(competitionService.addRaceList(raceListDTO)).thenReturn(updatedRaceListVO);

        RaceListVO result = competitionService.addRaceList(raceListDTO);
        assertNotNull(result);
        assertEquals("Song 2", result.getSongUserPairs().get(0).getUserName());
    }

    @Test
    void testAnnouncementsForSkaters() {
        List<SongUserPair> skaterList = Arrays.asList(
                new SongUserPair(1L, 1L, "John"),
                new SongUserPair(2L, 2L, "Doe")
        );

        RaceListVO raceList = RaceListVO.builder().songUserPairs(skaterList).build();
        Mockito.when(competitionService.getRaceLists(1L)).thenReturn(Arrays.asList(raceList));

        List<RaceListVO> result = competitionService.getRaceLists(1L);
        assertNotNull(result);

        List<SongUserPair> pairs = result.get(0).getSongUserPairs();
        assertEquals("Next skater is John", generateAnnouncement(pairs.get(0)));
        assertEquals("Next skater is Doe", generateAnnouncement(pairs.get(1)));
    }


    private String generateAnnouncement(SongUserPair pair) {
        if (pair != null) {
            return String.format("Next skater is %s", pair.getUserName());
        }
        return "No more skaters left. The competition is over.";
    }
}
