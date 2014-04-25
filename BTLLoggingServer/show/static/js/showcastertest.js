//Cams
var cam1 = 135965;
var cam2 = 131411;
var cam3 = 135967;
var cam4 = 135968;
var cam5 = 135969;
var cam6 = 135970;

//Chats
var chat1 = 135965;
var chat2 = 135970;

//Features
var buyStreams = "buyStreams";
var buyChat = "buyChat";
var buyAlignment = "buyAlignment";
var changeAlignment = "followTommy";

var chatDisabler = "iFrameDisabler";

var changeVidCam1 = "changeVidCam1";
var changeVidCam2 = "changeVidCam2";
var changeVidCam3 = "changeVidCam3";
var changeVidCam4 = "changeVidCam4";
var changeVidCam5 = "changeVidCam5";
var changeVidCamAlignment = "changeVidCamAlignment";

var changeChatAlignment = "changeChatAlignment";

var userVariables = {
	name : "",
	credit : "",
	chat_permission : false,
	stream_permission : false,
	secret_permission : false,
	currentVid : cam1
}

initializeUserVariables();

function initializeUserVariables() {
	$.get( "http://127.0.0.1:8000/show/status/", function( data ) {
		editUserVariables(data);
	});
} 

setInterval(function(){
	//get json response
	$.get( "http://127.0.0.1:8000/show/status/", function( data ) {
		console.log("interval");
		editUserVariables(data);
	});
},3000);

function editUserVariables(variablesJson) {
	/*
	console.log("json");
	console.log(variablesJson.name);
	console.log(variablesJson.credit);
	console.log(variablesJson.chat_permission);
	console.log(variablesJson.stream_permission);
	console.log(variablesJson.secret_permission);

	console.log("user permission pre");
	console.log(userVariables.name);
	console.log(userVariables.credit);
	console.log(userVariables.chat_permission);
	console.log(userVariables.stream_permission);
	console.log(userVariables.secret_permission);
*/
	if (userVariables.name != variablesJson.name) {
		userVariables.name = variablesJson.name;
		changeFeature('x-userName', variablesJson.name);
	}
	if (userVariables.credit != variablesJson.credit) {
		userVariables.credit = variablesJson.credit;
		changeFeature("x-userCredit", variablesJson.credit);
	}

	//chat
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

	//streams
	if (userVariables.stream_permission != variablesJson.stream_permission) {
		userVariables.stream_permission = variablesJson.stream_permission;
		if (variablesJson.stream_permission == true) {
			enableSelectStreams();
		} else if (variablesJson.stream_permission == false) {
			//disableSelectStreams();
		} else {
			//log error
		}
	}

	//secret
	if (userVariables.secret_permission != variablesJson.secret_permission) {
		userVariables.secret_permission = variablesJson.secret_permission;
		if (variablesJson.secret_permission == true) {
			enableAlignment();
		} else if (variablesJson.secret_permission == false) {
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
	console.log(userVariables.stream_permission);
	console.log(userVariables.secret_permission);
	*/
}


function spendCredit(pItem) {
	console.log("spendCredit on " + pItem);
	if (pItem == "alignment") {
		$.post( "http://127.0.0.1:8000/show/upgrade/secret/", function( data ) {
			console.log( data );
         	enableAlignment();
		});
	} else if (pItem == "streams") {
		$.post( "http://127.0.0.1:8000/show/upgrade/select_stream/", function( data ) {
			console.log( data );
         	//data = data.split(":");
         	enableSelectStreams();
		});
	} else if (pItem == "chat") {
		$.post( "http://127.0.0.1:8000/show/upgrade/chat/", function( data ) {
			console.log( data );
         	//data = data.split(":");
         	enableChat();
		});
	} 
}

function followTommy() {
	enableFeature(buyAlignment);
	disableFeature(changeAlignment);
}

function enableSelectStreams() {
	console.log("enableSelectStreams");
	disableFeature(buyStreams);
	enableFeature(changeVidCam2);
	enableFeature(changeVidCam3);
	enableFeature(changeVidCam4);
	enableFeature(changeVidCam5);
}

function enableAlignment() {
	console.log("enableAlignment");
	enableFeature(changeVidCamAlignment);
	enableFeature(changeChatAlignment);
	disableFeature(buyAlignment);
	disableFeature(changeAlignment);
}

function enableChat() {
	console.log("enableChat");
	hideFeature(chatDisabler);
	disableFeature(buyChat);
}

function disableSelectStreams() {
	console.log("disableSelectStreams");
	disableFeature(changeVidCam2);
	disableFeature(changeVidCam3);
	disableFeature(changeVidCam4);
	disableFeature(changeVidCam5);
	enableFeature(buyStreams);
}

function disableAlignment() {
	console.log("disableAlignment");
	disableFeature(changeVidCamAlignment);
	disableFeature(changeChatAlignment);
	enableFeature(buyAlignment);
	enableFeature(changeAlignment);
}

function disableChat() {
	console.log("disableChat");
	showFeature("iFrameDisabler");
	enableFeature("buyChat");
}

function changeFeature(feature, variable) {
	console.log("change " + feature + " to " + variable);
	$("#" + feature).html(variable);
}

function disableFeature(feature) {
	console.log("disable " + feature);
	$("#" + feature).attr("disabled","disabled");
}

function enableFeature(feature) {
	console.log("enable " + feature);
	$("#" + feature).removeAttr("disabled");
}

function hideFeature(feature) {
	console.log("hide " + feature);
	$("#" + feature).hide();
}

function showFeature(feature) {
	console.log("show " + feature);
	$("#" + feature).show();
}

function swapVideo(videoId) {
	console.log("swap video to " + videoId);
	var regEx = /\d{6}/;
	$("#videoSwapper").attr('src', $("#videoSwapper").attr('src').replace(regEx, videoId));
}