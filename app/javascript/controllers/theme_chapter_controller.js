import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="article"
export default class extends Controller {
  static targets = ['articleType', 'contextName', 'authorName', 'searchTermArticleBtn'];

  connect(){
    document.addEventListener("autocomplete.change", this.autocomplete.bind(this));
  }

  toggleSearchOptions(){
    let searchBoxStatus = $("#article_search_term").is(':disabled');

    if(searchBoxStatus == true){
      this.articleTypeTarget.disabled = true;
      this.contextNameTarget.disabled = true;
      this.authorNameTarget.disabled = true;
      $("#article_search_term").prop('disabled', false);
      this.searchTermArticleBtnTarget.disabled = false;
    } else {
      this.articleTypeTarget.disabled = false
      this.contextNameTarget.disabled = false;
      this.authorNameTarget.disabled = false;
      $("#article_search_term").prop('disabled', true);
      this.searchTermArticleBtnTarget.disabled = true;
    }
  }

  autocomplete(event) {
    let vl = event.detail.value;
    $.ajax({
      type: "get",
      url: '/themes/search_article/'+vl,
      dataType: 'script',
      success: function(data){
      }
    }); 
  }

  searchTerm(){
    let term = $("#article_search_term").val();

    if(term == "") {
      location.reload();
    } else {
      var searchParams = {search: {term: term}};
      $.ajax({
        type: "get",
        url: '/themes/search_term',
        data: searchParams,
        dataType: 'script',
        success: function(data){
        }
      });
    }
  }

}