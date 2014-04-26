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

//Items
var itemChat = "chat";
var itemStreams = "select_stream";
var itemAlignment = "secret";

var userVariables = {
	name : "",
	credit : "",
	chat_permission : false,
	stream_permission : false,
	secret_permission : false,
	currentVid : cam1
}

// code to send mouse data:
//$("#mousebox").mousemove(function(event){
//         $("#mousepos").html(event.clientX/$("#mousebox").width() + " " + event.clientY/$("#mousebox").height());
//         var x = event.clientX/$("#mousebox").width();
//         var y = event.clientY/$("#mousebox").height();
//         if(Math.abs(x - oldXPos) > 0.2 || Math.abs(y - oldYPos) > 0.2){
//             oldXPos = x;
//             oldYPos = y;
//             $.post( "http://127.0.0.1:8000/show/mouseMove/"+x+"/"+y+"/",function(data){
//             //$("#error").html(data);
//             });
//         }
// });

initializeUserVariables();

function initializeUserVariables() {
	$.get( "http://127.0.0.1:8000/show/status/", function( data ) {
		editUserVariables(data);
	});
} 

setInterval(function(){
	//get json response
	$.get( "http://127.0.0.1:8000/show/status/", function( data ) {
		//console.log("interval ");
		//console.log(data);
		editUserVariables(data);
	});
},3000);

function editUserVariables(variablesJson) {
	
	// console.log("json");
	// console.log(variablesJson.name);
	// console.log(variablesJson.credit);
	// console.log(variablesJson.chat_permission);
	// console.log(variablesJson.stream_permission);
	// console.log(variablesJson.secret_permission);

	// console.log("user permission pre");
	// console.log(userVariables.name);
	// console.log(userVariables.credit);
	// console.log(userVariables.chat_permission);
	// console.log(userVariables.stream_permission);
	// console.log(userVariables.secret_permission);

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
		} else if (variablesJson.chat_permission == false) {
			disableChat();
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
			disableSelectStreams();
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
			disableAlignment();
		} else {
			//log error
		}
	}

	// console.log("user permission post");
	// console.log(userVariables.name);
	// console.log(userVariables.credit);
	// console.log(userVariables.chat_permission);
	// console.log(userVariables.stream_permission);
	// console.log(userVariables.secret_permission);
	
}


function spendCredit(pItem) {
	console.log("spendCredit on " + pItem);

	$.post( "http://127.0.0.1:8000/show/upgrade/" + pItem + "/", function( data ) {
		console.log("spend credit ");
		console.log(data);
		editUserVariables(data);
	});
	//$.post( "http://127.0.0.1:8000/show/log/", "UPGRADE\n"+pItem, function( data ) {
    //     console.log( data );
    //});
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
	showFeature(chatDisabler);
	enableFeature(buyChat);
	//showFeature("iFrameDisabler");
	//enableFeature("buyChat");
}

function changeFeature(feature, variable) {
	console.log("change " + feature + " to " + variable);
	$("#" + feature).html(variable);
}

function mouseMove(event){
        //$("#mousepos").html(event.clientX/$("#mousebox").width() + " " + event.clientY/$("#mousebox").height());
        console.log(event.clientX/$("#mousebox").width() + " " + event.clientY/$("#mousebox").height());
        var x = event.clientX/$("#videoSwapper").width();
        var y = event.clientY/$("#videoSwapper").height();
        if(Math.abs(x - oldXPos) > 0.2 || Math.abs(y - oldYPos) > 0.2){
            oldXPos = x;
            oldYPos = y;
            $.post( "http://127.0.0.1:8000/show/mouseMove/"+x+"/"+y+"/",function(data){
            //$("#error").html(data);
            	console.log(data);
            });
        }
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
	$.post( "http://127.0.0.1:8000/show/log/", "SWAP_VIDEO\n"+videoId, function( data ) {
         console.log( data );
    });
}