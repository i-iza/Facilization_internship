/**
 * @license
 * Copyright (c) 2014, 2023, Oracle and/or its affiliates.
 * Licensed under The Universal Permissive License (UPL), Version 1.0
 * as shown at https://oss.oracle.com/licenses/upl/
 * @ignore
 */
/*
 * Your customer ViewModel code goes here
 */
define(['knockout',
'ojs/ojarraydataprovider',
'ojs/ojbufferingdataprovider',
'ojs/ojconverterutils-i18n',
'sharedService',
'ojs/ojinputtext', 
"ojs/ojinputnumber", 
'ojs/ojformlayout', 
'ojs/ojdatetimepicker',
'ojs/ojselectsingle',
'ojs/ojbutton',
'ojs/ojtable'],
 function(ko, ArrayDataProvider, BufferingDataProvider, ojconverterutils_i18n_1, sharedService) { 

    class CustomerViewModel{
      constructor() {

        this._initAllObservables();
        this._initAllIDs();
        this._initAllLabels();
        this._initGenderList();

        
        this.dataprovider = new BufferingDataProvider(new ArrayDataProvider(this.customerDataObservableArray));

        this._validBirthday();

        this.onInputBirthdayValueChanged = this._onInputBirthdayValueChanged.bind(this);
        
        this.onSaveButtonClick = this._onSaveButtonClick.bind(this);
      }
    } 

    /************************************************************
         * @function _initAllIDs
         * @description Initializes all IDs
         */
 
    CustomerViewModel.prototype._initAllIDs = function () {
      this.inputNameID = "input-name"
      this.inputSurnameID = "input-surname"
      this.inputBirthdayID = "input-birthday"
      this.inputGenderID = "input-gender"
      this.inputBirthplaceID = "input-birthplace"
      this.inputAgeID = "input-age"
    };

    /**************************************************************
         * @function _initAllLabels
         * @description Initializes all labels
         */

    CustomerViewModel.prototype._initAllLabels = function () {
      this.inputNameLbl = "Name"
      this.inputSurnameLbl = "Surname"
      this.inputBirthdayLbl = "Birthday"
      this.inputGenderLbl = "Gender"
      this.inputBirthplaceLbl = "Birthplace"
      this.inputAgeLbl = "Age"
      this.saveButtonLbl = "Save"
    };


    /****************************************************************
     * @function _initAllObservables
     * @description Initializes all observable values
     */

    CustomerViewModel.prototype._initAllObservables = function () {
      const storedData = sessionStorage.getItem('tableData');
      this.customerDataArray = storedData ? JSON.parse(storedData) : [];
      this.customerDataObservableArray = ko.observableArray(this.customerDataArray);

      this.inputNameValue = ko.observable(null);
      this.inputSurnameValue = ko.observable(null);
      this.inputBirthdayValue = ko.observable(null);
      this.inputGenderValue = ko.observable(null);
      this.inputBirthplaceValue = ko.observable(null);
      this.inputAgeValue = ko.observable(null);
    };

    /****************************************************************
         * @function _initGenderList
         * @description Initializes variables
         */

    CustomerViewModel.prototype._initGenderList = function () {
      this.genderList = new ArrayDataProvider ([
        {
          value : 'Male',
          label : 'Male',
        }, 
        {
          value : 'Female',
          label : 'Female',
        }, 
        {
          value : 'Not Specified',
          label : 'Not Specified',
        } 
      ], {
        keyAttributes: 'value',
      });

    };

    /*******************************************************************
         * @function _getAge
         * @description Calculate age based on birthday
         * @param {ISOString} dateString ISOString from birthday input
         * @returns {Number}
         */

    CustomerViewModel.prototype._getAge = function (dateString) {
      const today = new Date();
      const birthDate = new Date(dateString);
      let age = today.getFullYear() - birthDate.getFullYear();
      const m = today.getMonth() - birthDate.getMonth();
      if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())){
        age --;
      }
      return age;
    };

    /********************************************************************
         * @function _onInputBirthdayValueChanged
         * @description Pass the age from the _getAge function to the Age field
         */

    CustomerViewModel.prototype._onInputBirthdayValueChanged = function (event) {
      const value = event.detail.value;
      if(value){
        this.inputAgeValue(this._getAge(value));
      }

    };

    /************************************************************
         * @function _validBirthday
         * @description Validates the Birthday 
         */
 
    CustomerViewModel.prototype._validBirthday = function () {
      const maxDate = new Date();
        maxDate.setFullYear(maxDate.getFullYear() - 18);
        this.max = ojconverterutils_i18n_1.IntlConverterUtils.dateToLocalIsoDateString(maxDate);


        const minDate = new Date();
        minDate.setFullYear(minDate.getFullYear() - 120);
        this.min = ojconverterutils_i18n_1.IntlConverterUtils.dateToLocalIsoDateString(minDate);
    };

    /********************************************************************
         * @function _onSaveButtonClick
         * @description Save the account
         */
    CustomerViewModel.prototype._onSaveButtonClick = function() {
      const newCustomerData = {
        name: this.inputNameValue(),
        surname: this.inputSurnameValue(),
        birthday: this.inputBirthdayValue(),
        gender: this.inputGenderValue(),
        birthplace: this.inputBirthplaceValue(),
        age: this.inputAgeValue(),
      };

      sharedService.publish('dataChangeEvent', newCustomerData);

      this.customerDataObservableArray.push(newCustomerData);
      
      sessionStorage.setItem('tableData', JSON.stringify(this.customerDataObservableArray()));
    };

    document.addEventListener("DOMContentLoaded", function() {
      const viewModel = new CustomerViewModel();

      ko.applyBindings(viewModel, document.getElementById('tableContainer'));
    });

  return CustomerViewModel;
}
);
