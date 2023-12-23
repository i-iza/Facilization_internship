# Customer Data Form 
The Oracle Customer Dashboard is a web application built using Oracle JET (JavaScript Extension Toolkit) to manage and visualize customer data. 
This application includes features for entering customer information, displaying it in a tabular format, and presenting a pie chart visualization based on the gender distribution.
## Project Structure
The project is structured with separate modules for the customer view and the dashboard view.  

- Customer View Module  
ViewModel: Handles customer data, form validation, and saving customer information.  
Observable Values: Manages all observable values related to customer data and form inputs.  
Gender List: Initializes and manages the list of gender options.  
Date Validation: Ensures valid input for the customer's birthday.  
Save Button Click Event: Handles the event when the user clicks the "Save" button.  
Chart Integration: Integrates with the dashboard to update gender distribution counts.  

- Dashboard View Module  
ViewModel: Manages the data for the pie chart visualization.  
Chart Initialization: Initializes the pie chart with initial data.  
Data Change Event: Subscribes to changes in customer data and updates the chart accordingly.  
Session Storage: Persists gender counts in session storage for a seamless user experience.  

# Components
- Customer View:  
Allows users to input customer information.  
Validates and saves customer data.  
Displays customer information in a tabular format.  
- Dashboard View:  
Presents a pie chart visualization of the gender distribution.  
Dynamically updates based on changes in customer data.  
Provides a visual representation of the gender distribution.  
# Technologies Used
**Oracle JET (JavaScript Extension Toolkit)**  
**Knockout.js**  
**Oracle JET Components** (oj-input-text, oj-input-number, oj-input-date, oj-select-single, oj-table, oj-chart)  
**Session Storage**

## __Getting Started__  
**1.** Clone the Repository.  
**2.** Open in Browser:  
- Open the index.html file in a web browser to launch the Customer Form.
