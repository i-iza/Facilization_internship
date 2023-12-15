package com.ExcelFileUpload.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "Izabora_Data_In_Excel_FCUST")
@Data
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ExcelFile {

    @Id
    @Column
    private String fileName;

    @Column
    @Lob
    private String fileContent;

    public void setFileContent(String fileContent) {
        this.fileContent = fileContent;
    }
}

