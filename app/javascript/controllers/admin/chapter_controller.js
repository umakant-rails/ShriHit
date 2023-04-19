import { Controller } from "@hotwired/stimulus"
import ApplicationController from "../application_controller";

export default class extends ApplicationController {
  static targets = ['actionType', 'scripture', 'section', 'chapter', 'csrfToken'];
  
  connect(){
    this.params = {};
  }

  updateCheckboxStatus(event){
    if(event.target.children.length != 0){
      if(event.target.children[0].checked == false){
        event.target.children[0].checked = true;
      } else{
        event.target.children[0].checked = false;
      }
    }
  }

  getSections(){
    this.params = {};
    let scriptureId = event.target.value;
    let actionType = this.actionTypeTarget.value;
    let url = "/admin/chapters/get_sections";

    this.params.action_type = actionType;
    this.params.scripture_id = scriptureId;
    this.get_data('get', url, this.params)
  }

  getSectionChapters(){
    this.params = {};
    let url = "/admin/chapters/get_section_chapters"
    let sectionId = this.sectionTarget.value;

    this.params.section_id = sectionId;
    if(sectionId == ''){ return; }

    this.get_data('get', url, this.params);
  }

  addChaptersInSection(){
    this.params = {};

    let chapter_arry = [];
    let url = '/admin/chapters/add_chapters_in_section';
    let csrfToken = this.csrfTokenTarget.value;
    let sectionId = this.sectionTarget.value;
    let scriptureId = this.scriptureTarget.value;
    for(let chapter of this.chapterTargets){
      chapter.checked ? chapter_arry.push(chapter.value) : null;
    }

    this.params.section_id = sectionId;
    this.params.authenticity_token = csrfToken;
    this.params.chapters = chapter_arry;
    this.params.scripture_id = scriptureId;
    
    if(sectionId == ''){
      super.showErrorsByLayout("सेक्शन अनिवार्य फील्ड है, कृपया पहले सेक्शन को चुने.");
      window.scrollTo({ top: 0, behavior: 'smooth' });
      return;
    } else if (chapter_arry == ''){
      super.showErrorsByLayout("अध्याय अनिवार्य फील्ड है, अध्याय की सूची मे से अध्याय को चुने");
      window.scrollTo({ top: 0, behavior: 'smooth' });
      return;
    }

    this.get_data('POST', url, this.params)
  }

  removeChaptersFromSection(){
    this.params = {};

    let chapter_arry = [];
    let csrfToken = this.csrfTokenTarget.value;
    let sectionId = this.sectionTarget.value;
    for(let chapter of this.chapterTargets){
      chapter.checked ? null : chapter_arry.push(chapter.value);
    }

    this.params.section_id = sectionId;
    this.params.authenticity_token = csrfToken;
    this.params.chapters = chapter_arry;
    
    let url = '/admin/chapters/remove_chapters_from_section';
    this.get_data('POST', url, this.params)
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