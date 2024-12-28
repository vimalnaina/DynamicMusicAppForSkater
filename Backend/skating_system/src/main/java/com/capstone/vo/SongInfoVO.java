package com.capstone.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SongInfoVO implements Serializable {
    private Long id;
    private String name;
    private int duration;
    private String singer;
    private LocalDateTime createTime;
    private Long createUserId;
}
