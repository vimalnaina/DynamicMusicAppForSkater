package com.capstone.service;

import com.capstone.dto.AddAppointmentDTO;
import com.capstone.vo.BoardInfoVO;
import com.capstone.vo.SlotAvailabilityVO;

import java.util.List;

public interface ReservationService {
    List<SlotAvailabilityVO> avalableTimeSlots(String date);
    void insertNewAppointment(AddAppointmentDTO addAppointmentDTO);

    List<BoardInfoVO> boardInfo(String date);
}
