import { Controller } from "@hotwired/stimulus"
import ApplicationController from "../application_controller";

export default class extends ApplicationController {
  static targets = ['scriptureId',  'chapterId', 'articleTypeId', 'articleIndex', 
    'content', 'interpretation', 'contentEng', 'interpretationEng', 'csrfToken', 'form',
    'articleIndex'];

  connect(){
    this.params = {};
  }

  getChapters(){
    this.params = {};
    let scriptureId = event.target.value;
    this.params.scripture_id = scriptureId;
    this.get_data('get', '/admin/scripture_articles/get_chapters', this.params)
  }

  getIndex(){
    this.params = {};
    let chapterId = event.target.value;
    this.params.chapter_id = chapterId;
    if(chapterId == ''){ return; }
    this.get_data('get', '/admin/scripture_articles/get_index', this.params)
  }

  formSubmit(event){
    event.preventDefault();
    this.params = {};
    var form_attrs = {};

    let csrfToken = this.csrfTokenTarget.value;
    let contentEditorText = tinyMCE.get('scripture_article_content').getContent();
    let interpretationEditorText = tinyMCE.get('scripture_article_interpretation').getContent();
    let contentEngEditorText = tinyMCE.get('scripture_article_content_eng').getContent();
    let interpretationEngEditorText = tinyMCE.get('scripture_article_interpretation_eng').getContent();

    form_attrs.scripture_id = this.scriptureIdTarget.value;

    form_attrs.chapter_id = this.chapterIdTarget.value;
    form_attrs.article_type_id = this.articleTypeIdTarget.value;
    form_attrs.index = this.articleIndexTarget.value;
    form_attrs.content = contentEditorText;
    form_attrs.interpretation = interpretationEditorText;
    form_attrs.content_eng = contentEngEditorText;
    form_attrs.interpretation_eng = interpretationEngEditorText;

    let chapterEnabled = !this.chapterIdTarget.disabled;
    if(chapterEnabled && this.chapterIdTarget.value == ""){
      super.showErrorsByLayout('कृपया पहले अध्याय को सेलेक्ट करे');
      window.scrollTo({ top: 0, behavior: 'smooth' });
      return;
    }

    if(form_attrs.scripture_id == ''){
      super.showErrorsByLayout("रसिक ग्रन्थ/वाणी नाम अनिवार्य फील्ड है, यह खाली नहीं हो सकता है");
      window.scrollTo({ top: 0, behavior: 'smooth' });
      return;
    } else if (form_attrs.article_type_id == ''){
      super.showErrorsByLayout("रचना प्रकार अनिवार्य फील्ड है, यह खाली नहीं हो सकता है");
      window.scrollTo({ top: 0, behavior: 'smooth' });
      return;
    } else if (contentEditorText == ''){
      super.showErrorsByLayout("रचना अनिवार्य फील्ड है, यह खाली नहीं हो सकता है");
      window.scrollTo({ top: 0, behavior: 'smooth' });
      return;
    }

    this.params.authenticity_token = csrfToken;
    this.params.scripture_article = form_attrs;
    var operation_type = event.target.dataset.operation;
    
    if(operation_type == 'edit') {
      this.formTarget.submit();
    } else {
      this.get_data('POST', '/admin/scripture_articles', this.params).then(data => {
        super.showsuccessMsgByLayout("रचना को सफलतापूर्वक बना दिया गया है.");
        window.scrollTo({ top: 0, behavior: 'smooth' });
      });
    }

  }

  getChaptersOrArticles(){
    this.params = {};
    let id = event.target.value;
    let dataType = event.target.dataset.datatype;
    if(dataType == 'chapters') {
      this.params.scripture_id = id;
    } else {
      this.params.chapter_id = id;
    }

    if(id != ''){
      this.get_data('GET', '/admin/scripture_articles/get_chapter_articles', this.params);
    } else {
      $("#article-list").html("<center>अभी कोई डाटा उपलब्ध नहीं है<center><div class='dropdown-divider'></div>");
    }
  }

  updateArticleIndex(){
    this.params = {};
    let articleIndex = event.target.parentElement.children[0].value;
    let articleId = event.target.dataset.articleid;
    let csrfToken = this.csrfTokenTarget.value;
    let url = '/admin/scripture_articles/update_article_index';

    this.params.authenticity_token = csrfToken;
    this.params.article_id = articleId;
    this.params.article_index = articleIndex;
    this.get_data('POST', url, this.params).then(data => {
      super.showsuccessMsgByLayout("रचना का अनुक्रम सफलतापूर्वक अद्यतित कर दिया गया है.");
      window.scrollTo({ top: 0, behavior: 'smooth' });
    });
  }

  /* start js block - make ajax requext */
  get_data(requestType, url, params){
    return $.ajax({
      type: requestType,
      url: url,
      data: params,
      dataType: 'script',
      success: function(data){
      }
    });
  }
  /* end js block - make ajax requext */
}