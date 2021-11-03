//= require jquery3
//= require_tree .

$(document).ready(function(){
  // Swithch betweeen llight and dark modes
  $("#darkmode").click(function(){
    $("body").addClass("dark");
    document.cookie = "css=sammode"
  });
  $("#lightmode").click(function(){
    $("body").removeClass("dark");
    document.cookie = "css=mogmode"
  });
  // hide hubs when clicked
  $("#hidehubs").click(function(){
    $(".hub").toggle();
    document.cookie = "hidehubs=true"
  });
});
