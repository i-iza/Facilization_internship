package com.ExcelFileUpload.service;

import com.ExcelFileUpload.entity.ExcelFile;
import com.ExcelFileUpload.repository.ExcelFileRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import org.apache.poi.EncryptedDocumentException;
import org.apache.poi.ss.usermodel.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

@Service
public class UploadFile {

    @Autowired
    private ExcelFileRepository excelFileRepository;
    @Autowired
    private ObjectMapper objectMapper;

    public ArrayNode processExcelFile(MultipartFile file) throws IOException, EncryptedDocumentException {
        Workbook workbook = WorkbookFactory.create(file.getInputStream());
        ArrayNode arrayNode = objectMapper.createArrayNode();

        for (int count = 0; count < workbook.getNumberOfSheets(); count++) {
            Sheet sheet = workbook.getSheetAt(count);

            Iterator<Row> rowIterator = sheet.iterator();
            Row firstRow = rowIterator.next();
            List<String> columnNames = processFirstRow(firstRow);

            while (rowIterator.hasNext()) {
                Row row = rowIterator.next();
                ObjectNode rowNode = processAndStoreRow(row, columnNames);
                arrayNode.add(rowNode);
            }
        }

        return arrayNode;
    }

    private ObjectNode processAndStoreRow(Row row, List<String> columnNames) {
        ObjectNode jsonNode = objectMapper.createObjectNode();
        Iterator<Cell> cellIterator = row.cellIterator();
        int columnIndex = 0;

        while (cellIterator.hasNext()) {
            Cell cell = cellIterator.next();
            String columnName = (columnIndex < columnNames.size()) ? columnNames.get(columnIndex) : "Column" + columnIndex;
            jsonNode.put(columnName, cell.toString());
            columnIndex++;
        }

        return jsonNode;
    }

    private List<String> processFirstRow(Row row) {
        List<String> columnNames = new ArrayList<>();
        Iterator<Cell> cellIterator = row.cellIterator();

        while (cellIterator.hasNext()) {
            Cell cell = cellIterator.next();
            String columnName = cell.toString();
            columnNames.add(columnName);
        }

        return columnNames;
    }

    public void saveToDatabase(String fileName, String jsonString) {

        // Create ExcelFile entity
        ExcelFile excelFile = new ExcelFile();
        excelFile.setFileName(fileName);
        excelFile.setFileContent(jsonString);

        // Save the entity to the database
        excelFileRepository.save(excelFile);
    }
}