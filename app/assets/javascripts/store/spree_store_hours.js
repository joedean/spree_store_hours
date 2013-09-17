//= require store/spree_frontend
if (!window.SpreeStoreHours) {
    window.SpreeStoreHours = {};

    SpreeStoreHours.wday = function() {
        return ["sun","mon","tue","wed","thu","fri","sat"][(new Date()).getDay()];
    }
}

$(function() {
    $("div#store-hours ul li." + SpreeStoreHours.wday()).addClass("today");
});
