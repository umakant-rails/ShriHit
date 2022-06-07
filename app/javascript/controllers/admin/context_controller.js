import { Controller } from "@hotwired/stimulus"
import ApplicationController from "../application_controller";

export default class extends ApplicationController {
  static targets = ['contextForApproval', 'contextApprovedBtn', 'contextRejectBtn', 'contextMergeBtn', 
  'contextMergeIn', 'newContextName', 'saveContextBtn'];
  
  connect(){
    this.params = {};
  }

  setContextIndexInPopup(){
    let index = event.target.dataset.index;
    let page = event.target.dataset.page;
    this.saveContextBtnTarget.dataset.index = index;
    this.saveContextBtnTarget.dataset.page = page;
    this.newContextNameTarget.value = "";
  }

  approveContext(){
    let index = event.target.dataset.index;
    let page = event.target.dataset.page;
    this.params = {};this.params.page = page;
    let contextId = this.contextForApprovalTargets[index].dataset.vl;;
    let url = "/admin/contexts/"+contextId+"/approve";
    this.update_data("get", url, this.params);
  }
  
  rejectContext(){
    let index = event.target.dataset.index;
    let page = event.target.dataset.page;
    this.params = {};this.params.page = page;
    let contextId = this.contextForApprovalTargets[index].dataset.vl;;
    let url = "/admin/contexts/"+contextId+"/reject";
    this.update_data("get", url, this.params)
  }

  mergeContext(){
    let index = event.target.dataset.index;
    let page = event.target.dataset.page;
    let contextId = this.contextForApprovalTargets[index].dataset.vl;
    let contextMergeIn = this.contextMergeInTargets[index].value;
    let url = "/admin/contexts/"+contextId+"/merge";
    let crsfToken = this.csrfTokenTarget.value;

    if(contextMergeIn == ''){
      super.showErrorsByLayout("कृपया विलय करने के लिए पहले सम्बंधित प्रसंग चुने.");
    }
    this.params = {};this.params.page = page;
    this.params.context_merge_in = contextMergeIn;
    this.params.authenticity_token = crsfToken;
    this.update_data("post", url, this.params);
  }

  updateContext(){
    let index = event.target.dataset.index;
    let page = event.target.dataset.page;
    let contextId = this.contextForApprovalTargets[index].dataset.vl;
    let newContextName = this.newContextNameTarget.value;
    let crsfToken = this.csrfTokenTarget.value;
    let url = "/admin/contexts/"+contextId;

    this.params = {};this.params.page = page;
    this.params.updated_name = newContextName;
    this.params.authenticity_token = crsfToken;
    this.update_data("patch", url, this.params);
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