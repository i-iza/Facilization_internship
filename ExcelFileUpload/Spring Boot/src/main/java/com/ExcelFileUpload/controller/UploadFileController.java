package com.ExcelFileUpload.controller;

import com.ExcelFileUpload.entity.ExcelFile;
import com.ExcelFileUpload.repository.ExcelFileRepository;
import com.ExcelFileUpload.service.UploadFile;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import org.apache.poi.EncryptedDocumentException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Optional;


@RestController
public class UploadFileController {

    @Autowired
    private UploadFile uploadFile;

    @Autowired
    private ExcelFileRepository excelFileRepository;
    @Autowired
    private ObjectMapper objectMapper;

    @CrossOrigin(origins = "http://localhost:8000", allowedHeaders = "*", allowCredentials = "true")
    @PostMapping("/uploadLineByLine")
    public ResponseEntity<String> handleFileReading(@RequestParam("file") MultipartFile file) {
        try {
            Optional<ExcelFile> excelFileOptional = excelFileRepository.findByFileName(file.getOriginalFilename());

            if (excelFileOptional.isPresent()) {
                return ResponseEntity.status(HttpStatus.CONFLICT).body("Primary key violation: File with the same name already exists.");
            }
            ExcelFile excelFile;
            ArrayNode arrayNode = uploadFile.processExcelFile(file);

            // Convert the ArrayNode to JSON string
            String jsonString = arrayNode.toString();

            // Save the JSON string to the database
            uploadFile.saveToDatabase(file.getOriginalFilename(), jsonString);

            return ResponseEntity.ok("File uploaded successfully!");
        } catch (IOException | EncryptedDocumentException e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Failed to upload file");
        }
    }

    @CrossOrigin(origins = "http://localhost:8000", allowedHeaders = "*", allowCredentials = "true")
    @GetMapping("/getFile")
    public ResponseEntity<String> getFile(@RequestParam("filename") String filename) {
        try {
            // Fetch data from the database based on the filename
            Optional<ExcelFile> excelFileOptional = excelFileRepository.findByFileName(filename);


            if (excelFileOptional.isPresent()) {
                ExcelFile excelFile = excelFileOptional.get();

                // Create an ObjectNode for the specific file content
                ObjectNode jsonNode = objectMapper.createObjectNode();
                jsonNode.put("fileName", excelFile.getFileName());
                jsonNode.put("fileContent", excelFile.getFileContent());

                // Convert the ObjectNode to JSON string
                String jsonString = jsonNode.toString();

                return ResponseEntity.ok(jsonString);
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("File not found");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Failed to fetch data");
        }
    }
    @CrossOrigin(origins = "http://localhost:8000", allowedHeaders = "*", allowCredentials = "true")
    @DeleteMapping("/deleteFile")
    public ResponseEntity<String> deleteFile(@RequestParam("filename") String filename) {
        try {
            Optional<ExcelFile> excelFileOptional = excelFileRepository.findByFileName(filename);

            if (excelFileOptional.isPresent()) {

                excelFileRepository.delete(excelFileOptional.get());
                return ResponseEntity.ok("File deleted successfully!");
            } else {

                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("File not found");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Failed to delete file");
        }
    }

}
