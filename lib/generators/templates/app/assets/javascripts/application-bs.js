//= require jquery-ui
//= require turbolinks
//= require jquery-1.7
//= require a-wysihtml5-0.3.0.min
//= require bootstrap-colorpicker
//= require moment
//= require moment/fr
//= require bootstrap-datetimepicker
//= require bootstrap-datetimepicker-for-gallifrey-scaffold
//= require bootstrap-wysihtml5
//= require jquery.jstree
//= require tagit.js
//= require chardinjs
//= require jquery-barcode
//= require gallifrey_scaffold
//= require fixed_menu
//= require angular
//= require crop
//= require finecrop

function initPage(){



    datetimepicker_init();
    bs_init();
    modify_dom_init();
}
$(function() {
    initPage();
    function startSpinner(){
      $('.loader').show();
    }
    function stopSpinner(){
      $('.loader').hide();
    }
    document.addEventListener("turbolinks:request-start", startSpinner);
    document.addEventListener("turbolinks:request-end", stopSpinner);
    document.addEventListener("turbolinks:render", stopSpinner);
});
$(window).bind('turbolinks:render', function() {
    initPage();
});