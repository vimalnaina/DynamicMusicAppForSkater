package com.capstone.mapper;

import com.capstone.dto.AddAppointmentDTO;
import com.capstone.entity.Reservation;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface ReservationMapper {

    List<Reservation> getBookedTimeSlots(String date);

    @Select("select capstone.song.name from capstone.song where id = #{id}")
    String getSongNameById(Long id);

    @Insert("INSERT INTO reservation (user_id, songlist_id, date, start_time, end_time)" +
            "VALUES" +
            " (#{userId}, #{songlistId}, #{date}, #{startTime}, #{endTime});")
    void insert(AddAppointmentDTO addAppointmentDTO);

    List<Reservation> getReservationsByDate(String date);
}
