package com.BORA.Customer_info.DTO;

import lombok.Data;

@Data
public class AccountDTO {
    private Long accountId;
    private String IBAN;
    private String Ccy;
    private Long clientId;
}
