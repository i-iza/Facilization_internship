package com.BORA.Customer_info.model;

import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "Account_table")
@JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class, property = "iban")
@NoArgsConstructor
@AllArgsConstructor
@Setter
@Getter
@ToString

public class Account {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long accountId;
    private String IBAN;
    private String Ccy;

    // Establish the many-to-one relationship from Account to Client
    @ManyToOne
    @JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class, property = "id")
    @JoinColumn(name = "id") //A column "id" is created in the "Account_table" as a foreign key
    private Client client;
}
