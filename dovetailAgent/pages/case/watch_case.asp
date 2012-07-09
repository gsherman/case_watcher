<%@ Language=JavaScript %>
<% Response.Buffer = true %>

<!--#include file='../include/inc_constants.asp'-->
<!--#include file='../include/inc_page_init.asp'-->
<!--#include file='../include/inc_utility.asp'-->
<!--#include file="../include/json.asp"-->

<%

var result = new Object();
result.success = true;
result.errorMessage = "";

try {
   var id_number = Request.Form("id_number").Item;
   var objid = Request.Form("objid").Item;
   var userObjid = FCSession.Item("user.id");
   var watch = Request.Form("watch").Item;
   
	 var gen = FCSession.CreateGeneric('label');
		gen.AppendFilter("label", "=", "watch");
		gen.AppendFilter("label2case", "=", objid);
		gen.AppendFilter("label2user", "=", userObjid);
		gen.Query();

		if (gen.Count() == 0 && watch == "true"){
		 gen.AddNew();
		 gen("label") = "watch";
		 gen("label2user") = userObjid;
		 gen("label2case") = objid;
		 gen.BulkName="watch_case.asp";
		 gen.UpdateAll();
	 }
		if (gen.Count() > 0 && watch == "false"){
		 gen.Delete();
		 gen.UpdateAll();
	 }

	 var caseGeneric = FCSession.CreateGeneric("case");
	 caseGeneric.AddForUpdate(objid);
	 caseGeneric("x_change_date") = -999;
	 caseGeneric.Update();
	 	 		
} catch(e) {
   result.success = false;
   result.errorMessage = e.description;
}

Response.Clear();
Response.Write(JSON.stringify(result));
%>