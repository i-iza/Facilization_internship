# Excel File Upload and Data Visualization Project
The Excel File Upload and Data Visualization project is a web application developed using Spring Boot on the backend and Oracle JET on the frontend. 
This application provides functionalities to upload Excel files, process the data, and visualize it in tabular form. It accepts any Excel structure, as it stores 
the file in JSON format in the database and constructs the tables in frontend dynamically.
The frontend allows users to select and preview uploaded files, while the backend handles file upload, processing, and data retrieval.
# Project Structure

### Frontend (Oracle JET)
The frontend is developed using Oracle JET and includes a user interface for file selection, preview, and data visualization.  
**CustomerViewModel:**  
- Manages file selection, upload, and data preview.  
- Utilizes Oracle JET components for file selection, table display, and modals.  
- Communicates with the backend for file upload and data retrieval.

### Backend (Spring Boot)
The backend is implemented in Spring Boot, providing RESTful endpoints for file upload, data retrieval, and file deletion.  
- **UploadFileController:**  
Handles file upload, reads Excel content, and saves data to the database.  
Provides endpoints for fetching file content and deleting files.  

- **ExcelFileRepository:**  
Interface for database operations related to Excel files.  

- **UploadFileService:**  
Implements file upload and processing logic.  

- **CorsConfig:**  
Configuration for Cross-Origin Resource Sharing (CORS).  

- **JacksonConfig:**  
Configuration for Jackson ObjectMapper.  

- **ExcelFile:**  
Entity representing an Excel file with its name and content.
# Getting Started  
### **1.** Clone the Repository.  
### **2.** Backend Setup:  
Open the Spring Boot project in your preferred IDE.  
Configure database properties in application.properties.  
Run the Spring Boot application.  
### **3.** Frontend Setup:  
Open the Oracle JET project in your preferred code editor.  
Ensure that Oracle JET is installed.  
Run the Oracle JET application.  
### **4.** Access the Application:
Open the application in a web browser.
Use the provided functionalities to upload files and visualize data.
