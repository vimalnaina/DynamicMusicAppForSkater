package com.capstone.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.sql.Time;
import java.sql.Timestamp;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Reservation implements Serializable {
    private Long id;
    private Long userId;
    private String date;
    private Timestamp startTime;
    private Timestamp endTime;
    private Long songlistId;
}
