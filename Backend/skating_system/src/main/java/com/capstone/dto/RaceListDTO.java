package com.capstone.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RaceListDTO implements Serializable {
    private Long songlistId;
    private Long userId;
    private String description;
    private String listName;
    private List<SongUserPair> songUserPairs; // 修改为对象列表
}
