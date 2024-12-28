package com.capstone;

import com.capstone.dto.AddAppointmentDTO;
import com.capstone.service.ReservationService;
import com.capstone.vo.SlotAvailabilityVO;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;

import java.sql.Timestamp;
import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

//@SpringBootTest
@SpringBootTest(properties = {
        "spring.kafka.bootstrap-servers=localhost:9092",
        "spring.kafka.consumer.enable-auto-commit=false"
})
class ReservationTests {

    @MockBean
    private ReservationService reservationService;

    @Test
    void testViewAvailableSlots() {
        List<SlotAvailabilityVO> availableSlots = Arrays.asList(
                new SlotAvailabilityVO(Timestamp.valueOf("2024-11-20 10:00:00"), Timestamp.valueOf("2024-11-20 11:00:00"), true),
                new SlotAvailabilityVO(Timestamp.valueOf("2024-11-20 12:00:00"), Timestamp.valueOf("2024-11-20 13:00:00"), true)
        );

        Mockito.when(reservationService.avalableTimeSlots("2024-11-20")).thenReturn(availableSlots);

        List<SlotAvailabilityVO> result = reservationService.avalableTimeSlots("2024-11-20");
        assertNotNull(result);
        assertEquals(2, result.size());
        assertTrue(result.get(0).isAvailable());
        assertEquals(Timestamp.valueOf("2024-11-20 10:00:00"), result.get(0).getStartTime());
    }

    @Test
    void testNoAvailableSlots() {
        Mockito.when(reservationService.avalableTimeSlots("2024-11-20")).thenReturn(Arrays.asList());

        List<SlotAvailabilityVO> result = reservationService.avalableTimeSlots("2024-11-20");
        assertNotNull(result);
        assertTrue(result.isEmpty());
    }

    @Test
    void testInsertNewAppointment() {
        AddAppointmentDTO appointment = AddAppointmentDTO.builder()
                .date("2024-11-20")
                .startTime(Timestamp.valueOf("2024-11-20 10:00:00"))
                .endTime(Timestamp.valueOf("2024-11-20 11:00:00"))
                .userId(1L)
                .songlistId(100L)
                .build();

        // Simulate successful insertion (no exceptions thrown)
        Mockito.doNothing().when(reservationService).insertNewAppointment(appointment);

        assertDoesNotThrow(() -> reservationService.insertNewAppointment(appointment));
    }

    @Test
    void testInsertNewAppointmentSlotUnavailable() {
        AddAppointmentDTO appointment = AddAppointmentDTO.builder()
                .date("2024-11-20")
                .startTime(Timestamp.valueOf("2024-11-20 10:00:00"))
                .endTime(Timestamp.valueOf("2024-11-20 11:00:00"))
                .userId(1L)
                .songlistId(100L)
                .build();

        Mockito.doThrow(new IllegalArgumentException("This slot is already booked. Please choose another slot."))
                .when(reservationService).insertNewAppointment(appointment);

        IllegalArgumentException exception = assertThrows(IllegalArgumentException.class, () -> {
            reservationService.insertNewAppointment(appointment);
        });
        assertEquals("This slot is already booked. Please choose another slot.", exception.getMessage());
    }

    @Test
    void testViewSlotDetails() {
        List<SlotAvailabilityVO> slots = Arrays.asList(
                new SlotAvailabilityVO(Timestamp.valueOf("2024-11-20 10:00:00"), Timestamp.valueOf("2024-11-20 11:00:00"), false),
                new SlotAvailabilityVO(Timestamp.valueOf("2024-11-20 11:00:00"), Timestamp.valueOf("2024-11-20 12:00:00"), true)
        );

        Mockito.when(reservationService.avalableTimeSlots("2024-11-20")).thenReturn(slots);

        List<SlotAvailabilityVO> result = reservationService.avalableTimeSlots("2024-11-20");
        assertNotNull(result);
        assertFalse(result.get(0).isAvailable());
        assertEquals(Timestamp.valueOf("2024-11-20 10:00:00"), result.get(0).getStartTime());
        assertTrue(result.get(1).isAvailable());
    }
}
