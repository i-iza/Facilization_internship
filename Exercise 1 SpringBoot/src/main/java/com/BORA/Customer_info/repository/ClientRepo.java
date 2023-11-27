package com.BORA.Customer_info.repository;

import com.BORA.Customer_info.model.Client;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface ClientRepo extends JpaRepository<Client, Long> {
    @Query("SELECT c FROM Client c WHERE c.id = :id")
    Client findClientById(Long id);
}
