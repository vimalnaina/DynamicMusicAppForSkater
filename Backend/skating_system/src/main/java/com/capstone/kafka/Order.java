package com.capstone.kafka;

import io.swagger.models.auth.In;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Order {
    private Integer orderId;
    private Integer productId;
    private Integer productNum;
    private Double orderAmount;
}
