function fnPostNew_CUSTOM() {
	appendData();
	debugs('FCZ Start', gAction);
	var prevgAction = gAction;
	gAction = 'REFERENCE_POPULATE';
	fcjRequestDOM = buildUBSXml();
	debugs('FCZ', fcjRequestDOM);
	fcjResponseDOM = fnPost(fcjRequestDOM, servletURL, functionId);
	debugs('FCZ req', fcjRequestDOM);
	debugs('FCZ resp', fcjResponseDOM);
	if (!fnProcessResponse()){
      console.log("Something went wrong.");
		return true;
	}
	debugs('FCZ final', fcjResponseDOM);
	gAction = prevgAction;
};


function fnPreSave_CUSTOM() {
	appendData();
	debugs('FCZ Start', gAction);
	var prevgAction = gAction;
	gAction = 'CHECK_CONDITIONS';
	fcjRequestDOM = buildUBSXml();
	debugs('FCZ', fcjRequestDOM);
	fcjResponseDOM = fnPost(fcjRequestDOM, servletURL, functionId);
	debugs('FCZ req', fcjRequestDOM);
	debugs('FCZ resp', fcjResponseDOM);
	if (!fnProcessResponse()){
     console.log("Something went wrong.");
		return true;
	}
	debugs('FCZ final', fcjResponseDOM);
	gAction = prevgAction;
};


var previous_reference;

function fnPreCopy_CUSTOM(){
 
	previous_reference=document.getElementById('BLK_MAIN__REFER').value;
    return true;
}

function  fnPostCopy_CUSTOM(){
    document.getElementById('BLK_MAIN__REFER').value = previous_reference + "C";
	return true;
}
