package com.capstone.service.Impl;

import com.capstone.dto.AddAppointmentDTO;
import com.capstone.entity.Reservation;
import com.capstone.mapper.ReservationMapper;
import com.capstone.mapper.UserMapper;
import com.capstone.service.KafkaService;
import com.capstone.service.MusicService;
import com.capstone.service.ReservationService;
import com.capstone.vo.BoardInfoVO;
import com.capstone.vo.SlotAvailabilityVO;
import com.capstone.vo.SongListVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

@Service
public class ReservationServiceImpl implements ReservationService {

    @Autowired
    private ReservationMapper reservationMapper;

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private KafkaService kafkaService;


    public List<SlotAvailabilityVO> avalableTimeSlots(String date){
        // 查询指定日期的所有预约记录
        List<Reservation> reservations = reservationMapper.getReservationsByDate(date);

        // 默认可预约时间段：10:00 - 16:00
        Timestamp dayStart = Timestamp.valueOf(date + " 10:00:00");
        Timestamp dayEnd = Timestamp.valueOf(date + " 16:00:00");

        List<SlotAvailabilityVO> availableSlots = new ArrayList<>();

        // 遍历预约记录并计算空闲时间段
        Timestamp currentStart = dayStart;
        for (Reservation reservation : reservations) {
            // 预约开始时间
            Timestamp reservedStart = reservation.getStartTime();
            // 预约结束时间
            Timestamp reservedEnd = reservation.getEndTime();

            // 如果当前起始时间小于预约开始时间，则记录一个可用时间段
            if (currentStart.before(reservedStart)) {
                availableSlots.add(new SlotAvailabilityVO(currentStart, reservedStart, true));
            }
            // 添加已占用时间段
            availableSlots.add(new SlotAvailabilityVO(reservedStart, reservedEnd, false));

            // 更新当前起始时间为本次预约结束时间
            currentStart = reservedEnd.after(currentStart) ? reservedEnd : currentStart;
        }

        // 如果当前起始时间小于当天结束时间，则记录最后一个可用时间段
        if (currentStart.before(dayEnd)) {
            availableSlots.add(new SlotAvailabilityVO(currentStart, dayEnd, true));
        }

        return availableSlots;
    }

    @Override
    public void insertNewAppointment(AddAppointmentDTO addAppointmentDTO) {
        reservationMapper.insert(addAppointmentDTO);
    }

    @Override
    public List<BoardInfoVO> boardInfo(String date) {
        List<BoardInfoVO> boardInfoVOS = new ArrayList<>();
        List<Reservation> reservations = reservationMapper.getReservationsByDate(date);
        for(Reservation reservation : reservations){
            BoardInfoVO boardInfoVO = new BoardInfoVO();
            boardInfoVO.setDate(date);
            boardInfoVO.setUserId(reservation.getUserId());
            boardInfoVO.setStartTime(reservation.getStartTime());
            boardInfoVO.setEndTime(reservation.getEndTime());
            String userName = userMapper.getUsernameById(reservation.getUserId());
            boardInfoVO.setUserName(userName);
            SongListVO songListVO = kafkaService.getByListId(reservation.getSonglistId());
            boardInfoVO.setSongListVO(songListVO);
            boardInfoVOS.add(boardInfoVO);
        }

        return boardInfoVOS;
    }
}
