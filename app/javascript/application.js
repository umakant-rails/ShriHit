import Rails from '@rails/ujs';
import $ from 'jquery';
window.$ = $;
import "popper";
import "bootstrap";
import "controllers";
import "tinymce";
import "chartkick"
import "Chart.bundle"

Rails.start();

$(".js-sidebar-toggle").on('click', function(){
  if($("#sidebar").hasClass("collapsed")){
    $("#sidebar").removeClass("collapsed");
  } else {
    $("#sidebar").addClass("collapsed");
  }
})