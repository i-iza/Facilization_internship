function fn_Izabora_populate()
{
	
	appendData();
	debugs('FCZ Start', gAction);
	var prevgAction=gAction;
	gAction='IZABORA_POPULATE';
	fcjRequestDOM=buildUBSXml();
	debugs('FCZ', fcjRequestDOM);
	fcjResponseDOM=fnPost(fcjRequestDOM, servletURL,functionId);
	debugs('FCZ req', fcjRequestDOM);
	debugs('FCZ resp', fcjResponseDOM);

	if(!fnProcessResponse()){
	return true;
	}
	debugs('FCZ final', fcjResponseDOM);

	gAction=prevgAction;

}