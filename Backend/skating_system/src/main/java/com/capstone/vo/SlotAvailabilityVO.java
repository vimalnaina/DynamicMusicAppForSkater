package com.capstone.vo;

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
public class SlotAvailabilityVO implements Serializable {
    private Timestamp startTime;
    private Timestamp endTime;
    private boolean available;

}
