package com.capstone.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.sql.Timestamp;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AddAppointmentDTO implements Serializable {
    private String date;
    private Long userId;
    private Timestamp startTime;
    private Timestamp endTime;
    private Long songlistId;
}
