/***************************************************************************************************************************
**  This source is part of the FLEXCUBE Software Product. 
**  Copyright (c) 2008 ,2023, Oracle and/or its affiliates.
**  All rights reserved.
**  
**  No part of this work may be reproduced, stored in a retrieval system, 
**  adopted or transmitted in any form or by any means, electronic, mechanical, photographic, 
**  graphic, optic recording or otherwise, translated in any language or computer language, 
**  without the prior written permission of Oracle and/or its affiliates.
**  
**  Oracle Financial Services Software Limited.
**  Oracle Park, Off Western Express Highway,
**  Goregaon (East),
**  Mumbai - 400 063,
**  India.
**  
**  Written by         : 
**  Date of creation   : 
**  File Name          : STDBOR35_SYS.js
**  Purpose            : 
**  Called From        : 
**  
**  CHANGE LOG
**  Last Modified By   : 
**  Last modified on   : 
**  Full Version       : 
**  Reason             : 
****************************************************************************************************************************/

//***** Code for criteria Search *****
var criteriaSearch  = 'N';
//----------------------------------------------------------------------------------------------------------------------
//***** FCJ XML FOR THE SCREEN *****
//----------------------------------------------------------------------------------------------------------------------
var fieldNameArray = {"BLK_MAIN":"CUSTOMER_CATEGORY~CUSTOMER_TYPE~MAKER~MAKERSTAMP~CHECKER~CHECKERSTAMP~MODNO~TXNSTAT~AUTHSTAT~ONCEAUTH","BLK_DETAIL":"CUSTOMER_CATEGORY~CUSTOMER_TYPE~FIELD_DESCRIPTION~MANDATORY_VALIDATIONS"};

var multipleEntryPageSize = {"BLK_DETAIL" :"15" };

var multipleEntrySVBlocks = "";

var tabMEBlks = {"CVS_CUSTOMER_VALIDATION_PARAMETERIZATION__TAB_MAIN":"BLK_DETAIL"};

var msgxml=""; 
msgxml += '    <FLD>'; 
msgxml += '      <FN PARENT="" RELATION_TYPE="1" TYPE="BLK_MAIN">CUSTOMER_CATEGORY~CUSTOMER_TYPE~MAKER~MAKERSTAMP~CHECKER~CHECKERSTAMP~MODNO~TXNSTAT~AUTHSTAT~ONCEAUTH</FN>'; 
msgxml += '      <FN PARENT="BLK_MAIN" RELATION_TYPE="N" TYPE="BLK_DETAIL">CUSTOMER_CATEGORY~CUSTOMER_TYPE~FIELD_DESCRIPTION~MANDATORY_VALIDATIONS</FN>'; 
msgxml += '    </FLD>'; 

var strScreenName = "CVS_CUSTOMER_VALIDATION_PARAMETERIZATION";
var qryReqd = "Y";
var txnBranchFld = "" ;
var originSystem = "";
//----------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------
//***** FCJ XML FOR SUMMARY SCREEN *****
//----------------------------------------------------------------------------------------------------------------------
var msgxml_sum=""; 
msgxml_sum += '    <FLD>'; 
msgxml_sum += '      <FN PARENT="" RELATION_TYPE="1" TYPE="BLK_MAIN">AUTHSTAT~TXNSTAT~CUSTOMER_CATEGORY~CUSTOMER_TYPE</FN>'; 
msgxml_sum += '    </FLD>'; 

var detailFuncId = "STDBOR35";
var defaultWhereClause = "";
var defaultOrderByClause ="";
var multiBrnWhereClause ="";
var g_SummaryType ="S";
var g_SummaryBtnCount =0;
var g_SummaryBlock ="BLK_MAIN";
//----------------------------------------------------------------------------------------------------------------------
//***** CODE FOR DATABINDING *****
//----------------------------------------------------------------------------------------------------------------------
 var relationArray = {"BLK_MAIN" : "","BLK_DETAIL" : "BLK_MAIN~N"}; 

 var dataSrcLocationArray = new Array("BLK_MAIN","BLK_DETAIL"); 
 // Array of all Data Sources used in the screen 
//----------------------------------------------------------------------------------------------------------------------
//***** CODE FOR QUERY MODE *****
//----------------------------------------------------------------------------------------------------------------------
var detailRequired = true ;
var intCurrentQueryResultIndex = 0;
var intCurrentQueryRecordCount = 0;

var queryFields = new Array();    //Values should be set inside STDBOR35.js, in "BlockName__FieldName" format
var pkFields    = new Array();    //Values should be set inside STDBOR35.js, in "BlockName__FieldName" format
queryFields[0] = "BLK_MAIN__CUSTOMER_TYPE";
pkFields[0] = "BLK_MAIN__CUSTOMER_TYPE";
queryFields[1] = "BLK_MAIN__CUSTOMER_CATEGORY";
pkFields[1] = "BLK_MAIN__CUSTOMER_CATEGORY";
//----------------------------------------------------------------------------------------------------------------------
//***** CODE FOR AMENDABLE/SUBSYSTEM Fields *****
//----------------------------------------------------------------------------------------------------------------------
//***** Fields Amendable while Modification *****
var modifyAmendArr = {"BLK_DETAIL":["CUSTOMER_CATEGORY","CUSTOMER_TYPE","FIELD_DESCRIPTION","MANDATORY_VALIDATIONS"],"BLK_MAIN":["CUSTOMER_CATEGORY","CUSTOMER_TYPE"]};
var closeAmendArr = new Array(); 
//***** Fields Amendable while Reopen *****
var reopenAmendArr = {"BLK_DETAIL":["CUSTOMER_CATEGORY","CUSTOMER_TYPE","FIELD_DESCRIPTION","MANDATORY_VALIDATIONS"],"BLK_MAIN":["CUSTOMER_CATEGORY","CUSTOMER_TYPE"]};
var reverseAmendArr = new Array(); 
var deleteAmendArr = new Array(); 
var rolloverAmendArr = new Array(); 
var confirmAmendArr = new Array(); 
var liquidateAmendArr = new Array(); 
//***** Fields Amendable while Query *****
var queryAmendArr = {"BLK_DETAIL":["CUSTOMER_CATEGORY","CUSTOMER_TYPE","FIELD_DESCRIPTION","MANDATORY_VALIDATIONS"],"BLK_MAIN":["CUSTOMER_CATEGORY","CUSTOMER_TYPE"]};
//***** Fields Amendable while Authorize *****
var authorizeAmenArr = {"BLK_DETAIL":["CUSTOMER_CATEGORY","CUSTOMER_TYPE","FIELD_DESCRIPTION","MANDATORY_VALIDATIONS"],"BLK_MAIN":["CUSTOMER_CATEGORY","CUSTOMER_TYPE"]};
//----------------------------------------------------------------------------------------------------------------------

var subsysArr    = new Array(); 

//----------------------------------------------------------------------------------------------------------------------

//***** CODE FOR LOVs *****
//----------------------------------------------------------------------------------------------------------------------
var lovInfoFlds = {"BLK_MAIN__CUSTOMER_CATEGORY__LOV_CUSTOMER_CATEGORY":["BLK_MAIN__CUSTOMER_CATEGORY~","","N",""]};
var offlineLovInfoFlds = {};
//----------------------------------------------------------------------------------------------------------------------
//***** SCRIPT FOR TABS *****
//----------------------------------------------------------------------------------------------------------------------
var strHeaderTabId = 'TAB_HEADER';
var strFooterTabId = 'TAB_FOOTER';
var strCurrentTabId = 'TAB_MAIN';
//--------------------------------------------
//----------------------------------------------------------------------------------------------------------------------
//***** SCRIPT FOR MULTIPLE ENTRY BLOCKS *****
//----------------------------------------------------------------------------------------------------------------------
var multipleEntryIDs = new Array("BLK_DETAIL");
var multipleEntryArray = new Array();
var multipleEntryCells = new Array();
//----------------------------------------------------------------------------------------------------------------------
//***** SCRIPT FOR MULTIPLE ENTRY VIEW SINGLE ENTRY BLOCKS *****
//----------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------
//***** SCRIPT FOR ATTACHED CALLFORMS *****
 //----------------------------------------------------------------------------------------------------------------------

 var CallFormArray= new Array(); 

 var CallFormRelat=new Array(); 

 var CallRelatType= new Array(); 


 var ArrFuncOrigin=new Array();
 var ArrPrntFunc=new Array();
 var ArrPrntOrigin=new Array();
 var ArrRoutingType=new Array();


 // Code for Loading Cluster/Custom js File Starts
 var ArrClusterModified=new Array();
 var ArrCustomModified=new Array();
 // Code for Loading Cluster/Custom js File ends

ArrFuncOrigin["STDBOR35"]="CUSTOM";
ArrPrntFunc["STDBOR35"]="";
ArrPrntOrigin["STDBOR35"]="";
ArrRoutingType["STDBOR35"]="X";


 // Code for Loading Cluster/Custom js File Starts
ArrClusterModified["STDBOR35"]="N";
ArrCustomModified["STDBOR35"]="Y";

 // Code for Loading Cluster/Custom js File ends


 /* Code For OBIEE functionalities */ 
var obScrArgName  = new Array(); 
var obScrArgSource  = new Array(); 
//***** CODE FOR SCREEN ARGS *****
//----------------------------------------------------------------------------------------------------------------------
var scrArgName = {};
var scrArgSource = {};
var scrArgVals = {};
var scrArgDest = {};
//***** CODE FOR SUB-SYSTEM DEPENDENT  FIELDS   *****
//----------------------------------------------------------------------------------------------------------------------
var dpndntOnFlds = {};
var dpndntOnSrvs = {};
//***** CODE FOR TAB DEPENDENT  FIELDS   *****
//----------------------------------------------------------------------------------------------------------------------
//***** CODE FOR CALLFORM TABS *****
//----------------------------------------------------------------------------------------------------------------------
var callformTabArray = new Array(); 
//***** CODE FOR ACTION STAGE DETAILS *****
//----------------------------------------------------------------------------------------------------------------------
var actStageArry = {"QUERY":"2","NEW":"2","MODIFY":"2","AUTHORIZE":"1","DELETE":"1","CLOSE":"1","REOPEN":"1","REVERSE":"1","ROLLOVER":"1","CONFIRM":"1","LIQUIDATE":"1","SUMMARYQUERY":"2"};
//***** CODE FOR IMAGE FLDSET *****
//----------------------------------------------------------------------------------------------------------------------