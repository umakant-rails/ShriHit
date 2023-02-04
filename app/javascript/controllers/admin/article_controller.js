import { Controller } from "@hotwired/stimulus"
import ApplicationController from "../application_controller";

export default class extends ApplicationController {
  static targets = ['articleForApproval', 'csrfToken'];

  connect(){
    this.params = {};
  }

  articleActions(){
    let index = event.target.dataset.index;
    let page = event.target.dataset.page;
    let csrfToken = this.csrfTokenTarget.value;
    let actionName = event.target.dataset.actionName;
    let articlesCategory = event.target.dataset.parentType;
    let articleId = this.articleForApprovalTargets[index].dataset.vl;
    let url = "/admin/articles/"+articleId+"/" + actionName;
    this.params.articles_category = articlesCategory;
    this.params.authenticity_token = csrfToken;
    this.update_data("post", url);
  }

  // rejectArticle(){
  //   console.log('reject');
  //   let index = event.target.dataset.index;
  //   let page = event.target.dataset.page;
  //   this.params = {};this.params.page = page;
  //   let articleId = this.contextForApprovalTargets[index].dataset.vl;;
  //   let url = "/admin/contexts/"+articleId+"/reject";
  //   this.update_data("get", url, this.params)
  // }

  /* start js block - make ajax requext */
  update_data(requestType, url){
    $.ajax({
      type: requestType,
      url: url,
      data: this.params,
      dataType: 'script',
      success: function(data){
      }
    });
  }
  /* end js block - make ajax requext */
}
