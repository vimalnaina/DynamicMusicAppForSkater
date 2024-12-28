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
public class BoardInfoVO implements Serializable {
    private String date;
    private Timestamp startTime;
    private Timestamp endTime;
    private Long userId;
    private String userName;
    private SongListVO songListVO;

}
