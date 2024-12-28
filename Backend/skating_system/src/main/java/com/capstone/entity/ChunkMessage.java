package com.capstone.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

/**
 * separate a file data of song so that can be transfer by kafka producer.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ChunkMessage implements Serializable {
    private Long id;
    private int chunkIndex;
    private int totalChunks;
    private byte[] data;
    // 1 => userAnnouncement 2 => songAnnouncement 3 => song data
    private int type;
}
