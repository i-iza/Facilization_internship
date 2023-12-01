package com.XMLData.XML.model;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import java.util.List;

@Data
public class Clients {
    //We need this in order to create a list of clients, since that is how they are given in the xml file
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @JsonProperty("clientList")
    private List<Client> clientList;

}
