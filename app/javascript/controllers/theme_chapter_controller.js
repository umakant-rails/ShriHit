import { Controller } from "@hotwired/stimulus"
import ApplicationController from "./application_controller";

// Connects to data-controller="article"
export default class extends ApplicationController {

  static targets = ['theme', 'csrfToken', 'articleType', 'contextName', 'authorName', 
    'contributorName', 'searchTermArticleBtn','clearFiltersBtn', 'languageBtn', 'themeChapter'];

  connect(){
    document.addEventListener("autocomplete.change", this.autocomplete.bind(this));
  }

  isSearchEnable(){
    if(this.hasThemeChapterTarget && this.themeChapterTarget.value.length == 0){
      this.clearFilters();
      super.showErrorsByLayout("कृपया पहले खंड/प्रकरण चुने. खंड/प्रकरण चुनना आवश्यक है.");
    }
  }
  
  searchArticlesByChapter(event){
    let chapterId = event.currentTarget.value;//this.themeChapterTarget.value;
    var searchParams = {
      search_type: 'no_attrs',
      theme_chapter_id: chapterId
    }
    this.getArticles(searchParams);
  }

  toggleSearchOptions(){
    if(this.hasThemeChapterTarget && this.themeChapterTarget.value.length == 0){
      super.showErrorsByLayout("कृपया पहले खंड/प्रकरण चुने. खंड/प्रकरण चुनना आवश्यक है.");
      return;
    }
    let searchBoxStatus = this.articleTypeTarget.disabled;

    if(searchBoxStatus == false){
      this.articleTypeTarget.disabled = true;
      this.contextNameTarget.disabled = true;
      this.authorNameTarget.disabled = true;
      this.contributorNameTarget.disabled = true;
      this.clearFiltersBtnTarget.disabled = true;
      $("#english_article_search_term").prop('disabled', false);
      $("#hindi_article_search_term").prop('disabled', false);
      this.searchTermArticleBtnTarget.disabled = false;
      this.languageBtnTarget.disabled = false;
      this.clearFilters();
    } else {
      this.articleTypeTarget.disabled = false
      this.contextNameTarget.disabled = false;
      this.authorNameTarget.disabled = false;
      this.contributorNameTarget.disabled = false;
      this.clearFiltersBtnTarget.disabled = false;
      $("#english_article_search_term").prop('disabled', true);
      $("#hindi_article_search_term").prop('disabled', true);
      $("#english_article_search_term").val("");
      $("#hindi_article_search_term").val("");
      this.languageBtnTarget.disabled = true;
      this.searchTermArticleBtnTarget.disabled = true;
    }
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
    let vl = event.detail.value;
    //let searchParams = {article_id: vl}
    //this.getArticles(searchParams);
    this.searchArticlesById(vl);
  }

  clearFilters(){
    this.articleTypeTarget.value = '';
    this.contextNameTarget.value = '';
    this.authorNameTarget.value = '';
    this.contributorNameTarget.value = '';
  }

  searchArticlesByAttrs(){
    let article_type = this.articleTypeTarget.value;
    let context_name = this.contextNameTarget.value
    let author_name = this.authorNameTarget.value;
    let chapterId = this.themeChapterTarget.value;
    let contributorName = this.contributorNameTarget.value;
    var searchParams = {
      article_type_id: article_type, 
      context_id: context_name,
      author_id: author_name,
      theme_chapter_id: chapterId,
      contributor_id: contributorName,
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

    let chapterId = this.themeChapterTarget.value;
    if(term == "") {
      location.reload();
    } else if (term.indexOf(":") >= 0){
      console.log(articleId);
      let searchParams = {
        search_type: 'by_id',
        article_id: articleId,
        theme_chapter_id: chapterId
      }
      this.getArticles(searchParams);
    } else {
      var searchParams = {
        term: term,
        theme_chapter_id: chapterId,
        search_in: searchIn,
        search_type: 'by_term',
      }
      this.getArticles(searchParams);
    }
  }

  additionOrDeletionOfArticles(actionType, articleId, themeArticleId){
    if(this.hasThemeChapterTarget && this.themeChapterTarget.value.length == 0){
      super.showErrorsByLayout("कृपया पहले खंड/प्रकरण चुने. खंड/प्रकरण चुनना आवश्यक है.");
      return;
    }

    //Required data to add a article in theme
    let requiredParams = {};
    let searchType = this.languageBtnTarget.value;
    let themeId = this.hasThemeTarget ? this.themeTarget.dataset.themeId : '';
    let themeChapterId = this.hasThemeChapterTarget ? this.themeChapterTarget.value : '';
    let crsfToken = this.hasCsrfTokenTarget ? this.csrfTokenTarget.value : '';

    requiredParams.theme_chapter_id = themeChapterId;
    requiredParams.authenticity_token = crsfToken;

    //Required data to get article with existing filters
    let searchBoxStatus = this.articleTypeTarget.disabled;
    let searchArticleId = (searchType == "हिंदी") ? $("#hindi_serach_text").val() : $("#english_serach_text").val();
    let searchTerm = $("#article_search_term").val();

    if(searchBoxStatus == false){
      requiredParams.article_type_id = this.articleTypeTarget.value;
      requiredParams.context_id = this.contextNameTarget.value;
      requiredParams.author_id = this.authorNameTarget.value;
      requiredParams.contributor_id = this.contributorNameTarget.value;
      requiredParams.search_type = "by_attribute";
    } else if(searchArticleId != '') {
      requiredParams.article_id = searchArticleId;
      requiredParams.search_type = "by_id";
    } else if (searchTerm != '') {
      requiredParams.term = searchTerm;
      requiredParams.search_type = "by_term";
    }

    if(actionType == 'addition'){
      requiredParams.theme_article = { 
        theme_chapter_id: themeChapterId,
        theme_id: themeId, article_id: articleId
      };
      this.addArticleInTheme(themeId, requiredParams);
    } else {
      requiredParams.theme_article_id = themeArticleId;
      this.removeArticleFromTheme(themeId, requiredParams);
    }
  }

  addArticlesInTheme(event){
    let articleId = event.currentTarget.dataset.id;
    this.additionOrDeletionOfArticles('addition', articleId, null);
  }
  removeArticlesFromTheme(event){
    let themeArticleId = event.currentTarget.dataset.id;
    this.additionOrDeletionOfArticles('removal', null, themeArticleId);
  }

  /* start - js requet to get data block */

  addArticleInTheme(themeId, params){
    $.ajax({
      type: "post",
      url: '/themes/'+themeId+'/add_article_in_theme',
      data: params,
      dataType: 'script',
      success: function(data){
      }
    });
  }

  removeArticleFromTheme(themeId, params){
    $.ajax({
      type: "post",
      url: '/themes/'+themeId+'/remove_article_from_theme',
      data: params,
      dataType: 'script',
      success: function(data){
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