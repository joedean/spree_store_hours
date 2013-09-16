//= require store/spree_frontend
$(function() {
  var timezone = "US/Pacific";
  $.getJSON("http://json-time.appspot.com/time.json?tz="+timezone+"&callback=?",
    function(data){
      var wday = data.datetime.substring(0,3).toLowerCase();
      $("div#store-hours ul li."+wday).addClass("today");
    })
});
