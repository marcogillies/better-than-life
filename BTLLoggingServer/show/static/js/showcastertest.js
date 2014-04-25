var cam1 = 135965;
var cam2 = 131411;
var cam3 = 135967;
var cam4 = 135968;
var cam5 = 135969;
var cam6 = 135970;

var chat1 = 135965;
var chat2 = 135970;

var userVariables = {
	name : "",
	credit : "",
	chat_permission : "false",
	streams_permission : "false",
	currentVid : cam1
}

initializeUserVariables();

function initializeUserVariables() {
	$.post( "http://127.0.0.1:8000/show/upgrade/", function( data ) {
		editUserVariables(data);
	});
} 

function editUserVariables(variablesJson) {
	/*
	console.log("json");
	console.log(variablesJson.name);
	console.log(variablesJson.credit);
	console.log(variablesJson.chat_permission);
	console.log(variablesJson.streams_permission);

	console.log("user permission pre");
	console.log(userVariables.name);
	console.log(userVariables.credit);
	console.log(userVariables.chat_permission);
	console.log(userVariables.streams_permission);
*/
	if (userVariables.name != variablesJson.name) {
		userVariables.name = variablesJson.name;
		changeFeature('x-userName', variablesJson.name);
	}
	if (userVariables.credit != variablesJson.credit) {
		userVariables.credit = variablesJson.credit;
		changeFeature("x-userCredit", variablesJson.credit);
	}
	if (userVariables.chat_permission != variablesJson.chat_permission) {
		userVariables.chat_permission = variablesJson.chat_permission;
		if (variablesJson.chat_permission == true) {
			enableChat();
		} else if (variablesJson == false) {
			//disableChat();
		} else {
			//log error
		}
	}
	if (userVariables.streams_permission != variablesJson.streams_permission) {
		if (variablesJson.chat_permission == true) {
			enableAlignment();
		} else if (variablesJson == false) {
			//disableAlignment();
		} else {
			//log error
		}
	}
/*
	console.log("user permission post");
	console.log(userVariables.name);
	console.log(userVariables.credit);
	console.log(userVariables.chat_permission);
	console.log(userVariables.streams_permission);*/
}

setInterval(function(){
	//get json response
	$.post( "http://127.0.0.1:8000/show/upgrade/", function( data ) {
		console.log("interval");
		editUserVariables(data);
	});
},3000);

function spendCredit(pItem) {
	console.log("spendCredit on " + pItem);
	if (pItem == "alignment") {
		$.post( "http://127.0.0.1:8000/show/upgrade/view_secret/", function( data ) {
			console.log( data );
         	data = data.split(":");
         	$("#creditview").html("user.username credit "+data[0]);
         	if(data[1] == "1"){
         		enableAlignment();
				
			};
		});
	} else if (pItem == "chat") {
		$.post( "http://127.0.0.1:8000/show/upgrade/chat/", function( data ) {
			console.log( data );
         	data = data.split(":");
         	$("#creditview").html("user.username credit "+data[0]);
         	if(data[1] == "1"){
         		enableChat();
			};
		});
	}
}

function enableAlignment() {
	enableFeature("changeVidCamAlignment");
	enableFeature("changeChatAlignment");
	$("#buyAlignment").attr("disabled", "disabled");
	$("#followTommy").attr("disabled", "disabled");
}

function enableChat() {
	hideFeature("iFrameDisabler");
	$("#buyChat").attr("disabled", "disabled");
}

function disableAlignment() {
	disableFeature("changeVidCamAlignment");
	disableFeature("changeChatAlignment");
	$("#buyAlignment").removeAttr("disabled");
	$("#followTommy").removeAttr("disabled");
}

function disableChat() {
	showFeature("iFrameDisabler");
	$("#buyChat").removeAttr("disabled");
}

function changeFeature(feature, variable) {
	console.log("change " + feature + " to " + variable);
	$("#" + feature).html(variable);
}

function disableFeature(feature) {
	console.log("disable" + feature);
	$("#" + feature).attr("disabled","disabled");
}

function enableFeature(feature) {
	console.log("enable" + feature);
	$("#" + feature).removeAttr("disabled");
}

function hideFeature(feature) {
	console.log("hide" + feature);
	$("#" + feature).hide();
}

function showFeature(feature) {
	console.log("show" + feature);
	$("#" + feature).show();
}

function swapVideo(videoId) {
	console.log("swap video to" + videoId);
	var regEx = /\d{6}/;
	$("#videoSwapper").attr('src', $("#videoSwapper").attr('src').replace(regEx, videoId));
}