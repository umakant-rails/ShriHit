import { Controller } from "@hotwired/stimulus"
import ApplicationController from "../application_controller";

export default class extends ApplicationController {
  static targets = ['csrfToken'];

  connect(){}

  rejectTag(){
    var tagId = event.target.dataset.id;
    var url = "/admin/tags/"+tagId+"/reject";
    var requestType = "POST";
    let csrfToken = this.csrfTokenTarget.value;
    let parentType = event.target.dataset.parentType;

    let params = {authenticity_token: csrfToken, parent_type: parentType};
    this.update_data(requestType, url, params);
  }

  approveTag(){
    var tagId = event.target.dataset.id;
    var url = "/admin/tags/"+tagId+"/approve";
    var requestType = "POST";
    let csrfToken = this.csrfTokenTarget.value;
    let parentType = event.target.dataset.parentType;

    let params = {authenticity_token: csrfToken, parent_type: parentType};
    this.update_data(requestType, url, params);
  }

  convertTagToContext(){
    var tagId = event.target.dataset.id;
    var url = "/admin/tags/"+tagId+"/convert_tag_to_context";
    var requestType = "POST";
    let csrfToken = this.csrfTokenTarget.value;
    let parentType = event.target.dataset.parentType;

    let params = {authenticity_token: csrfToken, parent_type: parentType};
    this.update_data(requestType, url, params);
  }
  
  tag_to_context_admin_tag
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
