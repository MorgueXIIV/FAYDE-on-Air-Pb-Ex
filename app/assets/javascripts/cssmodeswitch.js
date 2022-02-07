//= require jquery3
//= require_tree .
//= require cookies.min

$(document).on('ready turbolinks:load', function(){
	csscookie=docCookies.getItem("css")
	hubsHidden = docCookies.getItem("hidehubs")

	showHubButtonText="Show <br /> Details"
	hideHubButtonText="Hide <br /> Details"

	if (csscookie=="sammode") {
		$("#lightmode").show()
		$("#darkmode").hide()
	}
	if (csscookie=="mogmode") {
		$("#lightmode").hide()
		$("#darkmode").show()

	}
		$("#hidehubs").empty()
	if (hubsHidden =="true"){
		$("#hidehubs").append(showHubButtonText)
		$(".hub, .incid, .details, .hub td").addClass("hidden");
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
			$("#hidehubs").append(hideHubButtonText)
		} else {
			document.cookie = "hidehubs=true"
			$("#hidehubs").append(showHubButtonText)
		}
		$(".hub, .incid, .details, .hub td").toggleClass("hidden");

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
