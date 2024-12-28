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
public class SongList implements Serializable {
    private Long songlistId;
    private Long userId;
    private String listName;
    private String description;
    private LocalDateTime createTime;

}
