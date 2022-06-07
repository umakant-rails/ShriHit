import { Controller } from "@hotwired/stimulus"
import ApplicationController from "../application_controller";

export default class extends ApplicationController {
  static targets = ['articleForApproval'];
  
  connect(){
    this.params = {};
  }

  approveOrApproveArticle(){
    console.log(event.target.dataset.actionName);
    let index = event.target.dataset.index;
    let page = event.target.dataset.page;
    let actionName = event.target.dataset.actionName;
    let articleId = this.articleForApprovalTargets[index].dataset.vl;
    let url = "/admin/articles/"+articleId+"/" + actionName;
    this.update_data("get", url);
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
      data: {},
      dataType: 'script',
      success: function(data){
      }
    });
  }
  /* end js block - make ajax requext */
}