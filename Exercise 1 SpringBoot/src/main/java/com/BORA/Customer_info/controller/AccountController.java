package com.BORA.Customer_info.controller;

import com.BORA.Customer_info.DTO.AccountDTO;
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
public class AccountController {

    @Autowired
    private AccountRepo accountRepo;
    @Autowired
    private ClientRepo clientRepo;

    @GetMapping("/getAllAccounts")
    public ResponseEntity<List<AccountDTO>> getAllAccounts(){
        try {
            List<AccountDTO> accountDTOList = new ArrayList<>();
            List<Account> accountList = accountRepo.findAll();
            //Loop through all accounts and then save them as a list of DTOs
            //So they show nicely on the screen
            for (Account account : accountList) {
                AccountDTO accountDTO = new AccountDTO();
                accountDTO.setAccountId(account.getAccountId());
                accountDTO.setIBAN(account.getIBAN());
                accountDTO.setCcy(account.getCcy());

                // Check if the client is not null before accessing its ID
                if (account.getClient() != null) {
                    accountDTO.setClientId(account.getClient().getId());
                }

                accountDTOList.add(accountDTO);
            }
            //If there are no accounts, then a response is returned to the user
            if (accountDTOList.isEmpty()) {
                return new ResponseEntity<>(HttpStatus.NO_CONTENT);
            }
            //If everything is OK
            return new ResponseEntity<>(accountDTOList, HttpStatus.OK);
        } catch (Exception ex) {
            ex.printStackTrace();
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    @GetMapping("/getAccountById/{accountId}")
    public ResponseEntity<AccountDTO> getAccountById(@PathVariable Long accountId){
        //Throughout the project I have used Optional<> in order to avoid errors raised when there is no data to show
        Optional<Account> accountData = accountRepo.findById(accountId);
        if (accountData.isPresent()){
            Account account = accountData.get();

            // Check if the client is not null before accessing its ID
            Long clientId = (account.getClient() != null) ? account.getClient().getId() : null;
            //Transferring the data from the account found by accountId to the AccountDTO
            AccountDTO accountDTO = new AccountDTO();
            accountDTO.setAccountId(account.getAccountId());
            accountDTO.setIBAN(account.getIBAN());
            accountDTO.setCcy(account.getCcy());
            accountDTO.setClientId(clientId);

            return new ResponseEntity<>(accountDTO, HttpStatus.OK);
        }
        return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }

    @PostMapping("/addAccount/{id}")
    public ResponseEntity<Object> addAccount(@PathVariable Long id, @RequestBody Account account ){
            try {
                Client clientOptional = clientRepo.findClientById(id);
                //Search for the client passed by id then save it to the dedicated field in the account that will be added
                account.setClient(clientOptional);
                //Everything else is added in the request body, so we just need to save the account
                Account savedAccount = accountRepo.save(account);
                return new ResponseEntity<>(savedAccount, HttpStatus.CREATED);
            }catch(Exception ex){
                ex.printStackTrace();
                return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
            }
    }

    @PostMapping("/updateAccountById/{accountId}")
    public ResponseEntity<Account> updateAccountById(@PathVariable Long accountId, @RequestBody Account newAccountData){
        Optional<Account> oldAccountData = accountRepo.findById(accountId);

        if (oldAccountData.isPresent()){
            Account updatedAccountData  = oldAccountData.get();
            updatedAccountData.setIBAN(newAccountData.getIBAN());
            updatedAccountData.setCcy(newAccountData.getCcy());
            //If it is needed to change the client, we can also do that with some more code
            Account accountObj = accountRepo.save(updatedAccountData);
            return new ResponseEntity<>(accountObj, HttpStatus.OK);
        }
        return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }


    @DeleteMapping("/deleteAccountById/{accountId}")
    public ResponseEntity<HttpStatus> deleteAccountById(@PathVariable Long accountId) {
        try {
            Optional<Account> accountOptional = accountRepo.findById(accountId);
            //Check if the account exists
            if (accountOptional.isPresent()) {
                Account account = accountOptional.get();

                Client client = account.getClient();
                //When deleting an account, make sure to also remove it from the client list of accounts
                if (client != null) {
                    client.getAccount().remove(account);
                    clientRepo.save(client);
                }
                accountRepo.deleteById(accountId);
            }
            return new ResponseEntity<>(HttpStatus.OK);
        }catch(Exception ex){
            ex.printStackTrace();
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}