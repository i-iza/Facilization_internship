package com.XMLData.XML.controller;

import com.XMLData.XML.model.Client;
import com.XMLData.XML.service.DatabaseService;
import com.XMLData.XML.service.XmlUploadService;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
public class XmlUploadController {

    @Autowired
    private XmlUploadService xmlUploadService;

    @Autowired
    private DatabaseService databaseService;

    @PostMapping("/uploadXml")
    public ResponseEntity<String> uploadXml(@RequestParam("file") MultipartFile file) {
        try {
            //First we read the file and process it, using the utility XmlParser and the service xmlUploadService
            List<Client> clients = xmlUploadService.processXml(file);
            // Save each client to the database
            for (Client client : clients) {
                databaseService.saveClient(client);
            }
            return ResponseEntity.ok("XML file uploaded and processed successfully.");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error occurred while processing the XML file.");
        }
    }
}
