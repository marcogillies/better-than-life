var cam1 = 135965;
var cam2 = 131411;
var cam3 = 135967;
var cam4 = 135968;
var cam5 = 135969;
var cam6 = 135970;

var chat1 = 135965;
var chat2 = 135970;

setInterval(function(){
	refreshPageVariables();
},3000);

function spendCredit(pItem) {
	console.log("spendCredit on " + pItem);
	if (pItem == "alignment") {
		$.post( "http://127.0.0.1:8000/show/upgrade/", function( data ) {
			console.log( data );
         	data = data.split(":");
         	$("#creditview").html("user.username credit "+data[0]);
         	if(data[1] == "1"){
				enableFeature("changeVidCamAlignment");
				enableFeature("changeChatAlignment");
				$("#buyAlignment").attr("disabled", "disabled");
			};
		});
	} else if (pItem == "chat") {
		$.post( "http://127.0.0.1:8000/show/upgrade/", function( data ) {
			console.log( data );
         	data = data.split(":");
         	$("#creditview").html("user.username credit "+data[0]);
         	if(data[1] == "1"){
				hideFeature("iFrameDisabler");
				$("#buyChat").attr("disabled", "disabled");
			};
		});
	}
}

function refreshPageVariables() {
	console.log("pingDb")
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