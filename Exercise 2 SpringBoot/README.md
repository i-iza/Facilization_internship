# XMLData Processing 
This project is a Spring Boot application designed to process XML data containing client information. 
It includes functionality to upload an XML file, parse its contents using the `XmlUploadService`, and save the extracted `Client` entities to a database (Oracle) using the `DatabaseService`.
## Features
**1.** ClientRepository: JPA repository for managing Client entities.
Includes a method to check if a client with a specific name already exists.  

**2.** XmlParser: Utility class providing a static method to parse XML input streams.
Uses Jackson's XmlMapper for deserialization.  

**3.** XmlUploadService: Service class responsible for processing XML files.
Converts MultipartFile to an InputStream. Uses XmlParser to parse the XML content into a list of Client entities.  

**4.** DatabaseService: Service class responsible for saving Client entities to the database.
Checks for duplicate entries based on the client's name before saving.  

**5.** Client: JPA Entity representing client information with fields for id, name, email, and type.  

**6.** Clients: POJO representing a list of clients, used for deserializing the XML file.  

**7.** XmlUploadController: RESTful controller handling XML file uploads and processing.  

## __Achievements__  
- Successfully created an efficient solution for parsing and saving XML data into a database within the deadline.
  
## __Getting Started__  
**1.** Clone the repository.  
**2.** Configure your database settings in application.properties.  
**3.** Build and execute the project using Maven on your preferred IDE.  
