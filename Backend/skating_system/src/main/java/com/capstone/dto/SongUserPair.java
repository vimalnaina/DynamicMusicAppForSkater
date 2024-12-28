package com.capstone.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SongUserPair {
    private Long songId; // 歌曲ID
    private Long userId; // 对应的用户ID
    private String userName;
}
