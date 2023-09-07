import { Controller } from "@hotwired/stimulus"
import ApplicationController from "../application_controller";

export default class extends ApplicationController {
  static targets = ['scripture', 'csrfToken', 'articleType', 'contextName', 'authorName', 
    'searchTermArticleBtn','clearFiltersBtn', 'languageBtn', 'chapter', 'searchBtnFirst', 
    'searchBtnSecond', 'scripture', 'indexingStatus'];

  connect(){
    document.addEventListener("autocomplete.change", this.autocomplete.bind(this));
  }

  isSearchEnable(){
    if(this.hasChapterTarget && this.chapterTarget.value.length == 0){
      this.clearFilters();
      super.showErrorsByLayout("कृपया पहले अध्याय चुने. अध्याय चुनना आवश्यक है.");
    }
  }
  
  searchArticlesByChapter(event){
    let chapterId = event.currentTarget.value;//this.ChapterTarget.value;
    var searchParams = {
      search_type: 'no_attrs',
      chapter_id: chapterId
    }
    this.getArticles(searchParams);
  }

  toggleSearchOptions(){
    if(this.hasChapterTarget && this.chapterTarget.value.length == 0){
      super.showErrorsByLayout("कृपया पहले अध्याय चुने. अध्याय चुनना आवश्यक है.");
      return;
    }
    let searchBoxStatus = event.target.dataset.togglevalue;

    if(searchBoxStatus == "second"){
      this.articleTypeTarget.disabled = true;
      this.contextNameTarget.disabled = true;
      this.authorNameTarget.disabled = true;
      // this.contributorNameTarget.disabled = true;
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
    } else {
      this.articleTypeTarget.disabled = false
      this.contextNameTarget.disabled = false;
      this.authorNameTarget.disabled = false;
      // this.contributorNameTarget.disabled = false;
      this.clearFiltersBtnTarget.disabled = false;
      $("#english_article_search_term").prop('disabled', true);
      $("#hindi_article_search_term").prop('disabled', true);
      $("#english_article_search_term").val("");
      $("#hindi_article_search_term").val("");
      this.languageBtnTarget.disabled = true;
      this.searchTermArticleBtnTarget.disabled = true;

      this.searchBtnFirstTarget.classList.remove('btn-secondary');
      this.searchBtnFirstTarget.classList.add('btn-primary');
      this.searchBtnSecondTarget.classList.remove('btn-primary');
      this.searchBtnSecondTarget.classList.add('btn-secondary'); 
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
    // this.contributorNameTarget.value = '';
  }

  searchArticlesByAttrs(){
    let article_type = this.articleTypeTarget.value;
    let context_name = this.contextNameTarget.value
    let author_name = this.authorNameTarget.value;
    let chapterId = this.chapterTarget.value;
    // let contributorName = this.contributorNameTarget.value;
    var searchParams = {
      article_type_id: article_type, 
      context_id: context_name,
      author_id: author_name,
      chapter_id: chapterId,
      // contributor_id: contributorName,
      search_type: 'by_attribute'
    };
    if(this.hasChapterTarget && this.chapterTarget.value.length > 0){
      this.getArticles(searchParams);
    }
    if(!this.hasChapterTarget){
      this.getArticles(searchParams);
    }
  }

  clearFiltersAndGetArticles(){
    this.clearFilters();
    let chapterId = this.chapterTarget.value;
    var searchParams = {
      search_type: 'no_attrs',
      chapter_id: chapterId
    }
    this.getArticles(searchParams);
  }

  searchArticlesById(articleId){
    let chapterId = this.chapterTarget.value;
    var searchParams = {
      search_type: 'by_id',
      article_id: articleId,
      chapter_id: chapterId
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

    let chapterId = this.chapterTarget.value;
    if(term == "") {
      location.reload();
    } else if (term.indexOf(":") >= 0){
      console.log(articleId);
      let searchParams = {
        search_type: 'by_id',
        article_id: articleId,
        chapter_id: chapterId
      }
      this.getArticles(searchParams);
    } else {
      var searchParams = {
        term: term,
        chapter_id: chapterId,
        search_in: searchIn,
        search_type: 'by_term',
      }
      this.getArticles(searchParams);
    }
  }

  articlesAdditionDeletion(event){
    if(this.hasChapterTarget && this.chapterTarget.value.length == 0){
      super.showErrorsByLayout("कृपया पहले अध्याय चुने. अध्याय चुनना आवश्यक है.");
      return;
    }

    //Required data to add a article in theme
    let requiredParams = {};
    let searchType = this.languageBtnTarget.value;
    let scriptureId = this.hasScriptureTarget ? this.scriptureTarget.dataset.scriptureId : '';
    let chapterId = this.hasChapterTarget ? this.chapterTarget.value : '';
    let crsfToken = this.hasCsrfTokenTarget ? this.csrfTokenTarget.value : '';

    requiredParams.chapter_id = chapterId;
    requiredParams.authenticity_token = crsfToken;

    //Required data to get article with existing filters
    let searchBoxStatus = this.articleTypeTarget.disabled;
    let searchArticleId = (searchType == "हिंदी") ? $("#hindi_serach_text").val() : $("#english_serach_text").val();
    let searchTerm = (searchType == "हिंदी") ? $("#hindi_article_search_term").val() : $("#english_article_search_term").val();

    if(searchBoxStatus == false){
      requiredParams.article_type_id = this.articleTypeTarget.value;
      requiredParams.context_id = this.contextNameTarget.value;
      requiredParams.author_id = this.authorNameTarget.value;
      // requiredParams.contributor_id = this.contributorNameTarget.value;
      requiredParams.search_type = "by_attribute";
    } else if(searchArticleId != '') {
      requiredParams.article_id = searchArticleId;
      requiredParams.search_type = "by_id";
    } else if (searchTerm != '') {
      requiredParams.term = searchTerm;
      requiredParams.search_type = "by_term";
    }

    let articleId = event.currentTarget.dataset.id;
    let actionType = event.currentTarget.dataset.actionName;

    if(actionType == 'addition'){
      requiredParams.cs_article = { 
        chapter_id: chapterId,
        scripture_id: scriptureId, article_id: articleId
      };
      var url = `/admin/compiled_scriptures/${scriptureId}/add_article`;
      this.additionDeletionOfArticleFromScripture('POST', url, requiredParams);
    } else {
      requiredParams.cs_article_id = articleId;
      var url = `/admin/compiled_scriptures/${scriptureId}/remove_article`;
      this.additionDeletionOfArticleFromScripture('POST', url, requiredParams);
    }
  }

  getChapterArticles(){
    this.params = {};
    let chapterId = this.chapterTarget.value;
    let scriptureId = this.chapterTarget.dataset.csScriptureId;
    let url = `/admin/compiled_scriptures/${scriptureId}/get_chapter_articles`;
    this.params.chapter_id = chapterId;
    
    this.get_data('GET', url, this.params);
  }


  /*start - block of code where a indivisual article index update */

  getIndexedArticles(){
    this.params = {};
    let chapterId = this.chapterTarget.value;
    let scriptureId = this.scriptureTarget.dataset.scriptureId;
    var requested_data_type = undefined;
    this.params.chapter_id = chapterId;

    if(chapterId.length == 0){
      super.showErrorsByLayout("कृपया पहले अध्याय चुने. अध्याय चुनना आवश्यक है.");
      return;
    }

    this.params.action_type = event.target.textContent.trim();

    this.indexingStatusTargets.forEach(function(element){
      if(element.classList.contains('btn-primary')){
        requested_data_type = element.textContent.trim();
      }
    });
    this.params.requested_data_type = requested_data_type;

    this.get_data('GET', `/admin/compiled_scriptures/${scriptureId}/get_indexed_articles`, this.params);
  }

  updateArticleIndex(){
    this.params = {};
    
    let chapterId = this.chapterTarget.value;
    let scriptureId = this.scriptureTarget.dataset.scriptureId;
    let articleIndex = event.target.parentElement.children[0].value;
    let articleId = event.target.dataset.articleid;
    let csrfToken = this.csrfTokenTarget.value;

    let requested_data_type = undefined;
    let url = `/admin/compiled_scriptures/${scriptureId}/update_article_index`;

    this.params.authenticity_token = csrfToken;
    this.params.article_id = articleId;
    this.params.article_index = articleIndex;
    this.params.chapter_id = chapterId;
    this.indexingStatusTargets.forEach(function(element){
      if(element.classList.contains('btn-primary')){
        requested_data_type = element.textContent.trim();
      }
    });
    this.params.requested_data_type = requested_data_type;

    this.get_data('POST', url, this.params).then(data => {
      super.showsuccessMsgByLayout("रचना का अनुक्रम सफलतापूर्वक अद्यतित कर दिया गया है.");
      window.scrollTo({ top: 0, behavior: 'smooth' });
    });
  }
  /*start - block of code where a indivisual article index update */


  /* start - js requet to get data block */
  additionDeletionOfArticleFromScripture(method, url, params){
    $.ajax({
      type: method,
      url: url,
      data: params,
      dataType: 'script',
      success: function(data){
      }
    });
  }

  get_data(method, url, params){
    return $.ajax({
      type: method,
      url: url,
      data: params,
      dataType: 'script',
      success: function(data){
      }
    });
  }

  getArticles(searchParams){
    $.ajax({
      type: "get",
      url: '/admin/compiled_scriptures/search_articles',
      data: searchParams,
      dataType: 'script',
      success: function(data){
      }
    }); 
  }

}
