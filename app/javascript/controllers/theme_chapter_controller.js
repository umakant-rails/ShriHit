import { Controller } from "@hotwired/stimulus"
import ApplicationController from "./application_controller";

// Connects to data-controller="article"
export default class extends ApplicationController {

  static targets = ['theme', 'csrfToken', 'articleType', 'contextName', 'authorName', 'searchTermArticleBtn',
  'clearFiltersBtn', 'themeChapter'];

  connect(){
    document.addEventListener("autocomplete.change", this.autocomplete.bind(this));
  }

  isSearchEnable(){
    if(this.hasThemeChapterTarget && this.themeChapterTarget.value.length == 0){
      this.clearFilters();
      super.showErrorsByLayout("कृपया पहले खंड/प्रकरण चुने. खंड/प्रकरण चुनना आवश्यक है.");
    }
  }

  toggleSearchOptions(){
    // let searchBoxStatus = $("#article_search_term").is(':disabled');
    // console.log(this.articleTypeTarget.disabled);
    let searchBoxStatus = this.articleTypeTarget.disabled;

    if(searchBoxStatus == false){
      this.articleTypeTarget.disabled = true;
      this.contextNameTarget.disabled = true;
      this.authorNameTarget.disabled = true;
      this.clearFiltersBtnTarget.disabled = true;
      $("#article_search_term").prop('disabled', false);
      this.searchTermArticleBtnTarget.disabled = false;
      this.clearFilters();
    } else {
      this.articleTypeTarget.disabled = false
      this.contextNameTarget.disabled = false;
      this.authorNameTarget.disabled = false;
      this.clearFiltersBtnTarget.disabled = false;
      $("#article_search_term").prop('disabled', true);
      $("#article_search_term").val("");
      this.searchTermArticleBtnTarget.disabled = true;
    }
  }

  autocomplete(event) {
    let vl = event.detail.value;
    //let searchParams = {article_id: vl}
    //this.getArticles(searchParams);
    this.searchArticlesById(vl);
  }

  clearFilters(){
    this.articleTypeTarget.value = '';
    this.contextNameTarget.value = '';
    this.authorNameTarget.value = '';
  }

  searchArticlesByAttrs(){
    let article_type = this.articleTypeTarget.value;
    let context_name = this.contextNameTarget.value
    let author_name = this.authorNameTarget.value;
    let chapterId = this.themeChapterTarget.value;
    var searchParams = {
      article_type_id: article_type, 
      context_id: context_name,
      author_id: author_name,
      theme_chapter_id: chapterId,
      search_type: 'by_attribute'
    };
    if(this.hasThemeChapterTarget && this.themeChapterTarget.value.length > 0){
      this.getArticles(searchParams);
    }
    if(!this.hasThemeChapterTarget){
      this.getArticles(searchParams);
    }
  }

  clearFiltersAndGetArticles(){
    this.clearFilters();
    let chapterId = this.themeChapterTarget.value;
    var searchParams = {
      search_type: 'no_attrs',
      theme_chapter_id: chapterId
    }
    this.getArticles(searchParams);
  }

  searchArticlesById(articleId){
    let chapterId = this.themeChapterTarget.value;
    var searchParams = {
      search_type: 'by_id',
      article_id: articleId,
      theme_chapter_id: chapterId
    }
    this.getArticles(searchParams);
  }

  searchArticleByTerm(){
    let term = $("#article_search_term").val();
    let chapterId = this.themeChapterTarget.value;
    if(term == "") {
      location.reload();
    } else {
      var searchParams = {
        term: term,
        theme_chapter_id: chapterId,
        search_type: 'by_term',
      }
      this.getArticles(searchParams);
    }
  }

  addArticlesInTheme(event){
    if(this.hasThemeChapterTarget && this.themeChapterTarget.value.length == 0){
      super.showErrorsByLayout("कृपया पहले खंड/प्रकरण चुने. खंड/प्रकरण चुनना आवश्यक है.");
      return;
    }

    //Required data to add a article in theme
    let articleId = event.currentTarget.dataset.id;
    let chapterId = this.themeChapterTarget.value;
    let themeId = this.themeTarget.dataset.themeId;
    let crsfToken = this.csrfTokenTarget.value;
    var requiredParams = {
      theme_article: {
        article_id: articleId,
        theme_chapter_id: chapterId,
        theme_id: themeId
      },
      theme_chapter_id: chapterId,
      authenticity_token: crsfToken
    }

    //Required data to get article with existing filters
    let searchBoxStatus = this.articleTypeTarget.disabled;
    let searchArticleId = $("#serach_text").val();
    let searchTerm = $("#article_search_term").val();

    if(searchBoxStatus == false){
      requiredParams.article_type_id = this.articleTypeTarget.value;
      requiredParams.context_id = this.contextNameTarget.value;
      requiredParams.author_id = this.authorNameTarget.value;
      requiredParams.search_type = "by_attribute";
    } else if(articleId != '') {
      requiredParams.article_id = searchArticleId;
      requiredParams.search_type = "by_id";
    } else if (searchTerm != '') {
      requiredParams.term = searchTerm;
      requiredParams.search_type = "by_term";
    }

    this.addArticleInTheme(themeId, requiredParams);
  }

  /* start - js requet to get data block */

  addArticleInTheme(themeId, params){
    $.ajax({
      type: "post",
      url: '/themes/'+themeId+'/add_article_in_theme',
      data: params,
      dataType: 'script',
      success: function(data){
      }, 
      error: function(error){
      }
    });
  }

  getArticles(searchParams){
    $.ajax({
      type: "get",
      url: '/themes/search_articles',
      data: searchParams,
      dataType: 'script',
      success: function(data){
      }
    }); 
  }

  // searchTerm(){
  //   let term = $("#article_search_term").val();
  //   if(term == "") {
  //     location.reload();
  //   } else {
  //     var searchParams = {search: {term: term}};
  //     $.ajax({
  //       type: "get",
  //       url: '/themes/search_term',
  //       data: searchParams,
  //       dataType: 'script',
  //       success: function(data){
  //       }
  //     });
  //   }
  // }
  /* end - js requet to get data block */

}