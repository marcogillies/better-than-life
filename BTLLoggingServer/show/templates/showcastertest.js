var cam1 = 135965;
var cam2 = 135966;
var cam3 = 135967;
var cam4 = 135968;
var cam5 = 135969;
var cam6 = 135970;

setInterval(function(){
	console.log("pingDb")
},3000);

function spendCredit(pItem) {
	if (pItem = "alignment") {
		enableFeature("changeVidCamAlignment");
	} else if (pItem = "chat") {
		hideFeature("iFrameDisabler");
	}
}

function disableFeature(feature) {
	console.log("disable" + feature);
	$("#" + feature).attr("disabled","disabled");
}

function enableFeature(feature) {
	console.log("disable" + feature);
	$("#" + feature).removeAttr("disabled");
}

function hideFeature(feature) {
	console.log("disable" + feature);
	$("#" + feature).hide();
}

function showFeature(feature) {
	console.log("disable" + feature);
	$("#" + feature).show();
}

function swapVideo(videoId) {
	console.log($("#videoSwapper").attr('src'));
	var regEx = /\d{6}/;
	$("#videoSwapper").attr('src', $("#videoSwapper").attr('src').replace(regEx, videoId));
	console.log($("#videoSwapper").attr('src'));
}