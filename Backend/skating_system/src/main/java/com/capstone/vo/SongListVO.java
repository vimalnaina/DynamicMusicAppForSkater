package com.capstone.vo;

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
public class SongListVO implements Serializable {
    private Long songlistId;
    private List<Song> songList;
    private Long userId;
    private String listName;
    private String description;
    private LocalDateTime createTime;
}
