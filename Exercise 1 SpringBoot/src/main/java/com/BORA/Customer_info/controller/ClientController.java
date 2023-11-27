package com.BORA.Customer_info.controller;

import com.BORA.Customer_info.DTO.ClientDTO;
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
    public ResponseEntity<List<ClientDTO>> getAllClients(){
        try{
            List <Client> clientList = new ArrayList<>();
            clientRepo.findAll().forEach(clientList :: add);

            if(clientList.isEmpty()){
                return new ResponseEntity<>(HttpStatus.NO_CONTENT);
            }
            //A DTO is used so the get call returns the results nicely on the screen, without the accounts lists
            List<ClientDTO> clientDTOList = new ArrayList<>();

            for (Client client : clientList) {
                ClientDTO clientDTO = new ClientDTO();
                clientDTO.setId(client.getId());
                clientDTO.setName(client.getName());
                clientDTO.setType(client.getType());
                clientDTOList.add(clientDTO);
            }
            return new ResponseEntity<>(clientDTOList, HttpStatus.OK);
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

            //The account field is updated when we add an account

            Client clientObj = clientRepo.save(updatedClientData);
            return new ResponseEntity<>(clientObj, HttpStatus.OK);
        }
        return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }

    @DeleteMapping("/deleteClientById/{id}")
    public ResponseEntity<HttpStatus> deleteClientById(@PathVariable Long id){
        try {
            Optional<Client> clientOptional = clientRepo.findById(id);
            //When deleting a client, all the accounts associated with it will be deleted automatically
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
