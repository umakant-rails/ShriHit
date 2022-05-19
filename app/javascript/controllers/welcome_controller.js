import { Controller } from "@hotwired/stimulus";
import { Autocomplete } from "stimulus-autocomplete";

export default class extends Controller {
  static targets = ['languageBtn'];

  connect() {
    document.addEventListener("autocomplete.change", this.autocomplete.bind(this));
  }

  selectLang(){
    let vl = event.currentTarget.dataset.vl;
    this.languageBtnTarget.value = vl;
    if(this.languageBtnTarget.value == "हिंदी") {
      $("#english_search_block").hide();
      $("#hindi_search_block").show();  
    } else {
      $("#hindi_search_block").hide();
      $("#english_search_block").show();
    }
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
    let term;
    let searchIn;
    let searchParams;
    let searchType = this.languageBtnTarget.value;
    let articleId = (searchType == "हिंदी")? $("#hindi_serach_text").val() : $("#english_serach_text").val();
    if(articleId != "" && articleId != undefined){
      searchParams = {article_id: articleId, search_type: "by_id"};
    } else {
      if(this.languageBtnTarget.value == "हिंदी"){
        term = $("#hindi_search_term").val();
        searchIn = "hindi";
      } else{
        term = $("#english_search_term").val();
        searchIn = "english";
      }
      searchParams = {term: term, search_in: searchIn, search_type: "by_term"};
    }

    if(term == "") {
      location.reload();
    } else {

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
