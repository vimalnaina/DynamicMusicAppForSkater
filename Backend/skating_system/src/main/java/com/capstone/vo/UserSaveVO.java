package com.capstone.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserSaveVO implements Serializable {
    private Long id;
    private String userName;
    private String token;
    private int type;
    private Long audio;
    private byte[] userAudioData;
}
