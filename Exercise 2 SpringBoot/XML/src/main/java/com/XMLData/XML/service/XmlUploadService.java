package com.XMLData.XML.service;

import com.XMLData.XML.model.Client;
import com.XMLData.XML.utility.XmlParser;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;

@Service
public class XmlUploadService {

    public List<Client> processXml(MultipartFile file) {
        try {
            // Convert MultipartFile to InputStream
            InputStream inputStream = file.getInputStream();

            // Use XmlParser to parse the XML
            return XmlParser.parseXml(inputStream);
        } catch (IOException e) {
            e.printStackTrace();
            throw new RuntimeException("Error occurred while processing the XML file.", e);
        }
    }


}
