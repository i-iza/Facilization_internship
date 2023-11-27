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

            if (accountDTOList.isEmpty()) {
                return new ResponseEntity<>(HttpStatus.NO_CONTENT);
            }

            return new ResponseEntity<>(accountDTOList, HttpStatus.OK);
        } catch (Exception ex) {
            ex.printStackTrace();
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    @GetMapping("/getAccountById/{accountId}")
    public ResponseEntity<AccountDTO> getAccountById(@PathVariable Long accountId){
        Optional<Account> accountData = accountRepo.findById(accountId);
        if (accountData.isPresent()){
            Account account = accountData.get();

            // Check if the client is not null before accessing its ID
            Long clientId = (account.getClient() != null) ? account.getClient().getId() : null;

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
                Client clientOptional = clientRepo.findByIdTest(id);
                account.setClient(clientOptional);
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

            Account accountObj = accountRepo.save(updatedAccountData);
            return new ResponseEntity<>(accountObj, HttpStatus.OK);
        }
        return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }


    @DeleteMapping("/deleteAccountById/{accountId}")
    public ResponseEntity<HttpStatus> deleteAccountById(@PathVariable Long accountId) {
        try {
            Optional<Account> accountOptional = accountRepo.findById(accountId);

            if (accountOptional.isPresent()) {
                Account account = accountOptional.get();

                Client client = account.getClient();
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