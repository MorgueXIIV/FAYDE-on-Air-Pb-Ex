//= require jquery3
//= require_tree .

$(document).ready(function(){
  $("#darkmode").click(function(){
    $("body").addClass("dark");
    document.cookie = "css=sammode"
  });
  $("#lightmode").click(function(){
    $("body").removeClass("dark");
    document.cookie = "css=mogmode"
  });
});
