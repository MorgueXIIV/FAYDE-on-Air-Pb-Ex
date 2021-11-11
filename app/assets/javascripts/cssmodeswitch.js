//= require jquery3
//= require_tree .
//= require cookies.min

$(document).ready(function(){
	csscookie=docCookies.getItem("css")
	hubsHidden = docCookies.getItem("hidehubs")

	showHubButtonText="Show Hubs and Details"
	hideHubButtonText="Show Dialogue Only"

	if (csscookie=="sammode") {
		$("#darkmode").hide()
	}
	if (csscookie=="mogmode") {
		$("#lightmode").hide()
	}
		$("#hidehubs").empty()
	if (hubsHidden =="true"){
		$("#hidehubs").append(showHubButtonText)
		$(".hub").hide()
		$(".incid").hide()
		$(".details").hide()
	} else {
		$("#hidehubs").append(hideHubButtonText)
	}


  // Swithch betweeen llight and dark modes
  $("#darkmode").click(function(){
		$("body").addClass("dark");
		document.cookie = "css=sammode"
		$("#darkmode").hide()
		$("#lightmode").show()
	});
	$("#lightmode").click(function(){
		$("body").removeClass("dark");
		document.cookie = "css=mogmode"

		$("#darkmode").show()
		$("#lightmode").hide()
  });
  // hide hubs when clicked



	$("#hidehubs").click(function(){
		hubsHidden = docCookies.getItem("hidehubs")
		$("#hidehubs").empty()

		if (hubsHidden=="true") {
			document.cookie = "hidehubs=false"
			$("#hidehubs").append("hideHubButtonText")
		} else {
			document.cookie = "hidehubs=true"
			$("#hidehubs").append(showHubButtonText)
		}
		$(".hub").toggle()
		$(".incid").toggle()
		$(".details").toggle()

	});

$("#actor2").change(function(){
	  	var selecteditem = $( "#actor2" ).val();
	    $("#actor1").val(selecteditem);
});


$("#actor1").keyup(function() {
    var valbox = $( this ).val();
		$("#actor2 > option").each(function() {
			var valopt = $( this ).text();
			var idx= valopt.toLowerCase().search(valbox.toLowerCase());
			if (idx>=0){
				$(this).prop('selected', true);
				return false;
			};
		});
});
});
