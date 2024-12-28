package com.capstone.controller;

import com.capstone.dto.AddAppointmentDTO;
import com.capstone.result.Result;
import com.capstone.service.ReservationService;
import com.capstone.vo.BoardInfoVO;
import com.capstone.vo.SlotAvailabilityVO;
import io.swagger.annotations.Api;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Arrays;
import java.util.List;

@RestController
@RequestMapping("/reservation")
@Api("skating area reservation model")
public class ReservationController {
    @Autowired
    private ReservationService reservationService;

    @GetMapping("/available/{date}")
    public Result<List<SlotAvailabilityVO>> getAvailableTimeSlots(@PathVariable String date){
        List<SlotAvailabilityVO> avaliable = reservationService.avalableTimeSlots(date);
        return Result.success(avaliable);
    }

    @PostMapping("/addAppointment")
    public Result addNewAppointment(@RequestBody AddAppointmentDTO addAppointmentDTO){
        reservationService.insertNewAppointment(addAppointmentDTO);
        return Result.success("booking successfully");
    }

    @GetMapping("/today/{date}")
    public Result<List<BoardInfoVO>> getBoardInfo(@PathVariable String date){
        List<BoardInfoVO> boardInfoVOS = reservationService.boardInfo(date);
        return Result.success(boardInfoVOS);
    }
}
