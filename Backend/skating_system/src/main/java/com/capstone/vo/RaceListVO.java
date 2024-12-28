package com.capstone.vo;

import com.capstone.dto.SongUserPair;
import com.capstone.entity.Song;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RaceListVO implements Serializable {
    private Long songlistId;
    private List<SongUserPair> songUserPairs;
    private Long userId;
    private String listName;
    private String description;
    private LocalDateTime createTime;
}
