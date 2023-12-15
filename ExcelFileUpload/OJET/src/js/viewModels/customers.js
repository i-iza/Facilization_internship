define([
  "knockout",
  "ojs/ojfilepickerutils",
  "ojs/ojarraydataprovider",
  "ojs/ojbufferingdataprovider",
  "ojs/ojfilepicker",
  "ojs/ojbutton",
  "ojs/ojinputtext",
  "ojs/ojtable"
],
function(ko, FilePickerUtils, ArrayDataProvider, BufferingDataProvider) {
  class CustomerViewModel {
    constructor() {
      this.fileNames = ko.observable();
      this.value = ko.observable("");
      this.selectedFiles = ko.observableArray();
      this.uploadedFiles = new Set(); // Set to store uploaded files

      this.selectFiles = this.selectFiles.bind(this);
      this.confirmAction = this.confirmAction.bind(this);
      this.handleInput = this.handleInput.bind(this);

      this.columns = ko.observableArray([]);
      this.dataObservableArray = ko.observableArray([]);

      this.dataprovider = new BufferingDataProvider(new ArrayDataProvider(this.dataObservableArray));
    }

    // *****************************************************************************************
    selectFiles() {
      const viewModel = this;

      FilePickerUtils.pickFiles(function (files) {
        viewModel.handleFileSelection(files);
      }, {
        accept: [],
        capture: "none",
        selectionMode: "single",
      });
    }

    // *****************************************************************************************
    handleFileSelection(files) {
      const fileList = Array.from(files);
      const viewModel = this;

      // Filter out files that have already been uploaded
      const newFiles = fileList.filter(file => !viewModel.uploadedFiles.has(file.name));

      if (newFiles.length === 0) {
        console.warn('No new files selected.');
        return;
      }

      viewModel.fileNames(newFiles.map((file) => {
        return file.name;
      }));

      const filePromises = newFiles.map((file) => {
        return viewModel.readContentAsync(file);
      });

      Promise.all(filePromises)
        .then((contents) => {
          // Update selectedFiles with name and file object
          viewModel.selectedFiles(newFiles.map((file, index) => {
            return {
              name: file.name,
              file: newFiles[index],
              content: contents[index],
            };
          }));
        })
        .catch((error) => {
          console.error('Error reading file content:', error);
        });
    }

    // *****************************************************************************************
    readContentAsync(file) {
      return new Promise((resolve, reject) => {
        const reader = new FileReader();

        reader.onload = (event) => {
          resolve(event.target.result);
        };

        reader.onerror = (error) => {
          reject(error);
        };

        reader.readAsArrayBuffer(file);
      });
    }

    // *****************************************************************************************
    confirmAction() {
      // Trigger the file upload when the button is clicked
      this.uploadFile()
        .then(() => {
          return true;
        })
        .catch(() => {
          return false;
        });
    }

    // *****************************************************************************************
    uploadFile() {
      return new Promise((resolve, reject) => {
        const viewModel = this;
    
        if (viewModel.selectedFiles().length > 0) {
          const file = viewModel.selectedFiles()[0];
    
          // Check if the file has already been uploaded
          if (viewModel.uploadedFiles.has(file.name)) {
            console.warn('File has already been uploaded:', file.name);
            const modalDialog = document.getElementById('modalDialog1');
            if (modalDialog) {
              modalDialog.open();
            }
            reject(new Error('File has already been uploaded'));
            return;
          }
    
          const formData = new FormData();
    
          // Append the entire file to FormData
          formData.append('file', file.file);
    
          fetch('http://localhost:8080/uploadLineByLine', {
            method: 'POST',
            body: formData,
            credentials: 'include',
          })
          .then(response => {
            if (response.status === 409) { 
              const modalDialog = document.getElementById('modalDialog4');
              if (modalDialog) {
                modalDialog.open();
              }
              throw new Error('Primary key violation'); 
            } else {
              // If the response is not a primary key violation, proceed
              return response;
            }
          })
          .then(data => {
            viewModel.uploadedFiles.add(file.name);
            const modalDialog = document.getElementById('modalDialog2');
            if (modalDialog) {
              modalDialog.open();
            }
            resolve(data);
          })
          .catch(error => {
            if (error.message === 'Primary key violation') {
              reject(error);
            } else {
              console.error('File upload failed:', error.message);
              reject(error);
            }
          });
        }
      });
    }
  
    // *****************************************************************************************
    async handleInput() {
      try {
        const inputFileName = this.value();
    
        if (inputFileName.length === 0) {
          this.dataObservableArray([]);
          return;
        }
    
        const dataInJson = await this.findFile(inputFileName);
    
        this.createColumnsFromJson(dataInJson.fileContent);
    
        // Clear existing data in the observable array
        this.dataObservableArray([]);
    
        // Add new data to the underlying ArrayDataProvider
        this.dataObservableArray.push(...dataInJson.fileContent);
      } catch (error) {
        console.error('Error fetching file:', error);
      }
    }
    
    // *****************************************************************************************
    async findFile(inputFileName) {
      try {
        const response = await fetch(`http://localhost:8080/getFile?filename=${inputFileName}`);
        
        if (response.ok) {
          const data = await response.json();
          data.fileContent = JSON.parse(data.fileContent);
          return data;
        } else if (response.status === 404) {
          console.log('File not found');
          this.dataObservableArray([]);
          const modalDialog = document.getElementById('modalDialog3');
          if (modalDialog) {
            modalDialog.open();
          }
          throw new Error('File not found');
        } else {
          console.error('Failed to fetch file:', response.statusText);
          throw new Error('Failed to fetch file');
        }
      } catch (error) {
        console.error('Error:', error.message);
        throw error;
      }
    }

    // *****************************************************************************************
    createColumnsFromJson(dataInJson) {
      // Clear existing columns
      this.columns([]);
    
      if (!Array.isArray(dataInJson) || dataInJson.length === 0) {
        console.error('No data or empty array to create columns.');
        return;
      }
    
      // Extract keys from the first object in the array
      const firstObject = dataInJson[0];
    
      const keys = Object.keys(firstObject);
    
      // Create columns from keys
      keys.forEach(key => {
        const column = {
          headerText: key,
          field: key,
          resizable: "enabled",
          id: key.toLowerCase(),
        };
        this.columns.push(column);
      });
    
      return keys;
    }

    // *****************************************************************************************
    closeDialog1() {
      const modalDialog1 = document.getElementById('modalDialog1');
      if (modalDialog1) {
        modalDialog1.close();
      }
    }

    // *****************************************************************************************
    closeDialog2() {
      const modalDialog2 = document.getElementById('modalDialog2');
      if (modalDialog2) {
        modalDialog2.close();
      }
    }
  
    // *****************************************************************************************
    closeDialog3() {
      const modalDialog3 = document.getElementById('modalDialog3');
      if (modalDialog3) {
        modalDialog3.close();
      }
    }

    // *****************************************************************************************
    closeDialog4() {
      const modalDialog4 = document.getElementById('modalDialog4');
      if (modalDialog4) {
        modalDialog4.close();
      }
    }
  }
    
  document.addEventListener("DOMContentLoaded", function() {
    const customerViewModel = new CustomerViewModel();
    ko.applyBindings(customerViewModel, document.getElementById('parentContainer'));
  });

  return CustomerViewModel;
});
