package com.XMLData.XML.service;

import com.XMLData.XML.model.Client;
import com.XMLData.XML.repository.ClientRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class DatabaseService {
    //This service is needed to save the clients into the repository and check for duplicate entries
    @Autowired
    private ClientRepository clientRepository;

    public void saveClient(Client client) {
        // Check if the name already exists in the database
        if (clientRepository.existsByName(client.getName())) {
            System.out.println("Duplicate name found: " + client.getName());
        } else {
            clientRepository.save(client);
        }
    }
}
