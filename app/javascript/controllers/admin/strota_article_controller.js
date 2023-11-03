import { Controller } from "@hotwired/stimulus"
import ApplicationController from "../application_controller";

export default class extends ApplicationController {
  static targets = ['articleType', 'articleIndex', 'csrfToken'];

  connect(){
    this.params = {};
  }

  selectStrotum(){
    let strotumId = event.target.value;
    window.location.href = '/admin/strota?id='+strotumId;
  }

  updateArticleIndex(){
    this.params = {};

    let strotumId = event.target.dataset.strotumid;
    let strotaArticleId = event.target.dataset.articleid;
    let articleIndex = event.target.parentElement.children[0].value;
    let csrfToken = this.csrfTokenTarget.value;
    let url = '/admin/strota/'+strotumId+'/strota_articles/'+strotaArticleId+'/update_article_index';
    this.params.index = articleIndex;
    this.params.authenticity_token = csrfToken;

    if(strotaArticleId == ''){ return; }
    this.get_data('POST', url, this.params)
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