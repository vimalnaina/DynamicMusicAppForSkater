package com.capstone.entity;

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
public class Song implements Serializable {
    private Long id;
    private String name;
    private String singer;
    //seconds
    private Integer duration;
    //1 => easy 2 => medium 3 => hard 4 => background
    private Integer difficultyLevel;
    private Long songId;
    private Long createUserId;
    private LocalDateTime createTime;
    private Long imageId;
    private Long audioId;
}
