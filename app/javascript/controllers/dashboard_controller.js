import { Controller } from "@hotwired/stimulus"
import ApplicationController from "./application_controller";

// Connects to data-controller="article"
export default class extends ApplicationController {
  static targets = ['contextForApproval', 'contextApprovedBtn', 'contextRejectBtn', 'contextMergeBtn', 
  'contextMergeIn', 'newContextName', 'saveContextBtn', 'authorForApproval','authorApproved', 'authorReject', 
  'authorMerge', 'authorMergeIn', 'csrfToken', 'newAuthorName', 'saveAuthorBtn'];
  
  connect(){
    this.params = {};
  }

  setContextIndexInPopup(){
    var index = event.target.dataset.index;
    this.saveContextBtnTarget.dataset.index = index;
    this.newContextNameTarget.value = "";
  }
  approveContext(){
    var index = event.target.dataset.index;
    let contextId = this.contextForApprovalTargets[index].dataset.vl;;
    let url = "/admin/contexts/"+contextId+"/approve";
    this.update_data("get", url, this.params);
  }
  rejectContext(){
    var index = event.target.dataset.index;
    let contextId = this.contextForApprovalTargets[index].dataset.vl;;
    let url = "/admin/contexts/"+contextId+"/reject";
    this.update_data("get", url, this.params)
  }

  mergeContext(){
    let index = event.target.dataset.index;
    let contextId = this.contextForApprovalTargets[index].dataset.vl;
    let contextMergeIn = this.contextMergeInTargets[index].value;
    let url = "/admin/contexts/"+contextId+"/merge";
    let crsfToken = this.csrfTokenTarget.value;

    if(contextMergeIn == ''){
      super.showErrorsByLayout("कृपया विलय करने के लिए पहले सम्बंधित प्रसंग चुने.");
    }
    this.params = {};
    this.params.context_merge_in = contextMergeIn;
    this.params.authenticity_token = crsfToken;
    this.update_data("post", url, this.params);
  }

  updateContext(){
    let index = event.target.dataset.index;
    let contextId = this.contextForApprovalTargets[index].dataset.vl;
    let newContextName = this.newContextNameTarget.value;
    let crsfToken = this.csrfTokenTarget.value;
    let url = "/admin/contexts/"+contextId;

    this.params = {};
    this.params.updated_name = newContextName;
    this.params.authenticity_token = crsfToken;
    this.update_data("put", url, this.params);
  }

  setAuthorIndexInPopup(){
    var index = event.target.dataset.index;
    this.saveAuthorBtnTarget.dataset.index = index;
    this.newAuthorNameTarget.value = "";
  }
  approveAuthor(){
    let index = event.target.dataset.index;
    let authorId = this.authorForApprovalTargets[index].dataset.vl;;
    let url = "/admin/authors/"+authorId+"/approve";
    this.update_data("get", url, this.params);
  }
  rejectAuthor(){
    let index = event.target.dataset.index;
    let authorId = this.authorForApprovalTargets[index].dataset.vl;;
    let url = "/admin/authors/"+authorId+"/reject";
    this.update_data("get", url, this.params);
  }
  mergeAuthor(){
    let index = event.target.dataset.index;
    let authorId = this.authorForApprovalTargets[index].dataset.vl;;
    let authorMergeIn = this.authorMergeInTargets[index].value;
    let crsfToken = this.csrfTokenTarget.value;
    let url = "/admin/authors/"+authorId+"/merge";

    if(authorMergeIn == ''){
      super.showErrorsByLayout("कृपया विलय करने के लिए पहले सम्बंधित लेखक चुने.");
    }
    this.params = {};
    this.params.author_merge_in = authorMergeIn;
    this.params.authenticity_token = crsfToken;
    this.update_data("post", url, this.params);
  }

  updateAuthor(){
    let index = event.target.dataset.index;
    let authorId = this.authorForApprovalTargets[index].dataset.vl;;
    let newAuthorName = this.newAuthorNameTarget.value;
    let crsfToken = this.csrfTokenTarget.value;
    let url = "/admin/authors/"+authorId;

    this.params = {};
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