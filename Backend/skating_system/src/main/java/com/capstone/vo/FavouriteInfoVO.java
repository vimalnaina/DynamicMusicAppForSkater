package com.capstone.vo;

import com.capstone.entity.Song;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FavouriteInfoVO implements Serializable {
    private Song song;
    private int count;
}
