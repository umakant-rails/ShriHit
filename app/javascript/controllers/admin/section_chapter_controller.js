import { Controller } from "@hotwired/stimulus"
import ApplicationController from "../application_controller";

export default class extends ApplicationController {
  static targets = ['section'];
  
  connect(){
    this.params = {};
  }

  getSections(){
    // this.params = {};
    let scriptureId = event.target.value;
    this.params.scripture_id = scriptureId;
    this.get_data('get', '/admin/chapters/get_sections', this.params)
  }


  /* start js block - make ajax requext */
  get_data(requestType, url, params){
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