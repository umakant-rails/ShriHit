import { Controller } from "@hotwired/stimulus"
import ApplicationController from "./application_controller";

//https://codepen.io/smashingmag/pen/XWXBOjy

// Connects to data-controller="article"
export default class extends ApplicationController {

  static targets = ['articleType', 'contextName', 'authorName', 'searchTermArticleBtn',
  'clearFiltersBtn', 'languageBtn', 'searchBtnFirst', 'searchBtnSecond'];

  connect(){
    document.addEventListener("autocomplete.change", this.autocomplete.bind(this));
  }

  firstSearchOption(){
    this.articleTypeTarget.disabled = false
    this.contextNameTarget.disabled = false;
    this.authorNameTarget.disabled = false;
    this.clearFiltersBtnTarget.disabled = false;
    $("#english_article_search_term").prop('disabled', true);
    $("#hindi_article_search_term").prop('disabled', true);
    // $("#english_article_search_term").val("");
    // $("#hindi_article_search_term").val("");
    this.languageBtnTarget.disabled = true;
    this.searchTermArticleBtnTarget.disabled = true;
    this.clearFilters();
    this.searchBtnFirstTarget.classList.remove('btn-secondary');
    this.searchBtnFirstTarget.classList.add('btn-primary');
    this.searchBtnSecondTarget.classList.remove('btn-primary');
    this.searchBtnSecondTarget.classList.add('btn-secondary');
  }

  secondSearchOption(){
    this.articleTypeTarget.disabled = true;
    this.contextNameTarget.disabled = true;
    this.authorNameTarget.disabled = true;
    this.clearFiltersBtnTarget.disabled = true;
    $("#english_article_search_term").prop('disabled', false);
    $("#hindi_article_search_term").prop('disabled', false);
    this.searchTermArticleBtnTarget.disabled = false;
    this.languageBtnTarget.disabled = false;
    this.clearFilters();

    this.searchBtnFirstTarget.classList.add('btn-secondary');
    this.searchBtnFirstTarget.classList.remove('btn-primary');
    this.searchBtnSecondTarget.classList.add('btn-primary');
    this.searchBtnSecondTarget.classList.remove('btn-secondary');
  }

  selectSearchLang(){
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
    let articleId = event.detail.value;
    //let searchParams = {article_id: vl}
    //this.getArticles(searchParams);
    this.searchArticlesById(articleId);
  }

  clearFilters(){
    this.articleTypeTarget.value = '';
    this.contextNameTarget.value = '';
    this.authorNameTarget.value = '';
    $("#english_article_search_term").val("");
    $("#hindi_article_search_term").val("");
  }

  searchArticlesByAttrs(){
    let articleType = this.articleTypeTarget.value;
    let contextName = this.contextNameTarget.value
    let authorName = this.authorNameTarget.value;
    var searchParams = {
      article_type_id: articleType, 
      context_id: contextName,
      author_id: authorName,
      search_type: 'by_attribute'
    };
    this.getArticles(searchParams);
  }

  clearFiltersAndGetArticles(){
    this.clearFilters();
    var searchParams = {
      search_type: 'no_attrs',
    }
    this.getArticles(searchParams);
  }

  searchArticlesById(articleId){
    var searchParams = {
      search_type: 'by_id',
      article_id: articleId
    }
    this.getArticles(searchParams);
  }

  searchArticleByTerm(){
    let term, searchIn, articleId;
    if(this.languageBtnTarget.value == "हिंदी"){
      term = $("#hindi_article_search_term").val();
      articleId = $("#hindi_serach_text").val();
      searchIn = "hindi";
    } else {
      term = $("#english_article_search_term").val();
      articleId = $("#english_serach_text").val();
      searchIn = "english";
    }
    if(term == "") {
      location.reload();
    } else if (term.indexOf(":") >= 0){
      let searchParams = {
        search_type: 'by_id',
        article_id: articleId
      }
      this.getArticles(searchParams);
    } else {
      var searchParams = {
        term: term,
        search_in: searchIn,
        search_type: 'by_term',
      }
      this.getArticles(searchParams);
    }
  }

  /* start - js requet to get data block */

  getArticles(searchParams){
    $.ajax({
      type: "get",
      //url: '/themes/search_articles',
      url: '/pb/articles/search',
      data: searchParams,
      dataType: 'script',
      success: function(data){
      }
    }); 
  }

}