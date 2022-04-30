import { Controller } from "@hotwired/stimulus";
import { Autocomplete } from "stimulus-autocomplete";

export default class extends Controller {
  static targets = [];

  connect() {
    document.addEventListener("autocomplete.change", this.autocomplete.bind(this));
  }

  autocomplete(event) {
    let vl = event.detail.value;
    console.log(event.detail.value);
    $.ajax({
      type: "get",
      url: '/search_article/'+vl,
      dataType: 'script',
      success: function(data){
      }
    }); 
  }

  searchTerm(){
    let term = $("#search_term").val();

    if(term == "") {
      location.reload();
    } else {
      var searchParams = {search: {term: term}};
      $.ajax({
        type: "get",
        url: '/search_term',
        data: searchParams,
        dataType: 'script',
        success: function(data){
        }
      });
    }
  }

}
