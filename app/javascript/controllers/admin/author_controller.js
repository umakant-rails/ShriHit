import { Controller } from "@hotwired/stimulus"
import ApplicationController from "../application_controller";

export default class extends ApplicationController {
  static targets = ['authorForApproval','authorApproved', 'authorReject', 
  'authorMerge', 'authorMergeIn', 'csrfToken', 'newAuthorName', 'saveAuthorBtn'];
  
  connect(){
    this.params = {};
  }

  setAuthorIndexInPopup(){
    let index = event.target.dataset.index;
    let page = event.target.dataset.page;
    this.saveAuthorBtnTarget.dataset.index = index;
    this.saveAuthorBtnTarget.dataset.page = page;
    this.newAuthorNameTarget.value = "";
  }
  approveAuthor(){
    let index = event.target.dataset.index;
    let page = event.target.dataset.page;
    let authorId = this.authorForApprovalTargets[index].dataset.vl;
    let url = "/admin/authors/"+authorId+"/approve";

    this.params = {};this.params.page = page;
    this.update_data("get", url, this.params);
  }
  rejectAuthor(){
    let index = event.target.dataset.index;
    let page = event.target.dataset.page;
    let authorId = this.authorForApprovalTargets[index].dataset.vl;
    let url = "/admin/authors/"+authorId+"/reject";

    this.params = {};this.params.page = page;
    this.update_data("get", url, this.params);
  }
  mergeAuthor(){
    let index = event.target.dataset.index;
    let page = event.target.dataset.page;
    let authorId = this.authorForApprovalTargets[index].dataset.vl;;
    let authorMergeIn = this.authorMergeInTargets[index].value;
    let crsfToken = this.csrfTokenTarget.value;
    let url = "/admin/authors/"+authorId+"/merge";

    if(authorMergeIn == ''){
      super.showErrorsByLayout("कृपया विलय करने के लिए पहले सम्बंधित लेखक चुने.");
    }
    this.params = {};this.params.page = page;
    this.params.author_merge_in = authorMergeIn;
    this.params.authenticity_token = crsfToken;
    this.update_data("post", url, this.params);
  }

  updateAuthor(){
    let index = event.target.dataset.index;
    let page = event.target.dataset.page;
    let authorId = this.authorForApprovalTargets[index].dataset.vl;;
    let newAuthorName = this.newAuthorNameTarget.value;
    let crsfToken = this.csrfTokenTarget.value;
    let url = "/admin/authors/"+authorId;

    this.params = {};this.params.page = page;
    this.params.updated_name = newAuthorName;
    this.params.authenticity_token = crsfToken;
    this.update_data("put", url, this.params);
  }

  /* start js block - make ajax requext */
  update_data(requestType, url, params){
    $.ajax({
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