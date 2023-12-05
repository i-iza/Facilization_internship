package com.XMLData.XML.repository;

import com.XMLData.XML.model.Client;
import org.springframework.data.jpa.repository.JpaRepository;


public interface ClientRepository extends JpaRepository<Client, Long> {
    boolean existsByName(String name);

}
