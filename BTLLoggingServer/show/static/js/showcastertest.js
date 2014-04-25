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
		$.post( "http://127.0.0.1:8000/show/upgrade/", function( data ) {
			console.log( data );
         	data = data.split(":");
         	$("#creditview").html("user.username credit "+data[0]);
         	if(data[1] == "1"){
				enableFeature("changeVidCamAlignment");
			};
		});
	} else if (pItem = "chat") {
		hideFeature("iFrameDisabler");
	}
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