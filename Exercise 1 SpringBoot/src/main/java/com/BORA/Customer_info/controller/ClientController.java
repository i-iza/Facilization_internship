package com.BORA.Customer_info.controller;

import com.BORA.Customer_info.model.Account;
import com.BORA.Customer_info.model.Client;
import com.BORA.Customer_info.repository.AccountRepo;
import com.BORA.Customer_info.repository.ClientRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@RestController
public class ClientController {

    @Autowired
    private ClientRepo clientRepo;
    @Autowired
    private AccountRepo accountRepo;

    @GetMapping("/getAllClients")
    public ResponseEntity<List<Client>> getAllClients(){
        try{
            List <Client> clientList = new ArrayList<>();
            clientRepo.findAll().forEach(clientList :: add);

            if(clientList.isEmpty()){
                return new ResponseEntity<>(HttpStatus.NO_CONTENT);
            }

            return new ResponseEntity<>(clientList, HttpStatus.OK);
        }catch(Exception ex){
            ex.printStackTrace();
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    @GetMapping("/getClientById/{id}")
    public ResponseEntity<Client> getClientById(@PathVariable Long id){
       Optional<Client> clientData = clientRepo.findById(id);
       if (clientData.isPresent()){
           return new ResponseEntity<>(clientData.get(), HttpStatus.OK);
       }
        return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }

    @PostMapping("/addClient")
    public ResponseEntity<Client> addClient(@RequestBody Client client){
        try {
            Client clientObj = clientRepo.save(client);
            return new ResponseEntity<>(clientObj, HttpStatus.OK);
        }catch(Exception ex){
            ex.printStackTrace();
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    @PostMapping("/updateClientById/{id}")
    public ResponseEntity<Client> updateClientById(@PathVariable Long id, @RequestBody Client newClientData){
        Optional<Client> oldClientData = clientRepo.findById(id);

        if (oldClientData.isPresent()){
            Client updatedClientData  = oldClientData.get();
            updatedClientData.setName(newClientData.getName());
            updatedClientData.setType(newClientData.getType());

            Client clientObj = clientRepo.save(updatedClientData);
            return new ResponseEntity<>(clientObj, HttpStatus.OK);
        }
        return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }

    @DeleteMapping("/deleteClientById/{id}")
    public ResponseEntity<HttpStatus> deleteClientById(@PathVariable Long id){
        try {
            Optional<Client> clientOptional = clientRepo.findById(id);

            if (clientOptional.isPresent()) {
                clientRepo.deleteById(id);
            }
            return new ResponseEntity<>(HttpStatus.OK);
        }catch(Exception ex){
            ex.printStackTrace();
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
