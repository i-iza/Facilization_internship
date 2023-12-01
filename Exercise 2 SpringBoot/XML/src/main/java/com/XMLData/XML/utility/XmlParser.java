package com.XMLData.XML.utility;

import com.XMLData.XML.model.Client;
import com.XMLData.XML.model.Clients;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.dataformat.xml.XmlMapper;
import lombok.experimental.UtilityClass;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;

@UtilityClass
public class XmlParser {

        public static List<Client> parseXml(InputStream inputStream) throws IOException {
            if (inputStream == null) {
                throw new IllegalArgumentException("Input stream cannot be null");
            }

            try{
            XmlMapper xmlMapper = new XmlMapper();
            Clients clients = xmlMapper.readValue(inputStream, Clients.class);

            return clients.getClientList();
            } catch (JsonProcessingException e){
                e.printStackTrace();
                throw new IOException("Error parsing XML", e);
            }
        }


}

