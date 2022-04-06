import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="article"
export default class extends Controller {
  static targets = ['form', 'content', 'articleTypeId', 'errors',
    'contextSelect', 'contextInput', 'writerSelect', 'writerInput'];

  connect() {
  }

  toggleWriter(){
    let writerValue = this.writerSelectTarget.value;
    if(writerValue == 'NA' && !this.writerSelectTarget.hidden){
      this.writerSelectTarget.hidden = true;
      this.writerInputTarget.hidden = false;
    } else {
      this.writerSelectTarget.hidden = false;
      this.writerInputTarget.hidden = true;
    }
  }
  toggleContext(){
    let contextValue = this.contextSelectTarget.value;
    if(contextValue == 'NA' && !this.contextSelectTarget.hidden) {
      this.contextSelectTarget.hidden = true;
      this.contextInputTarget.hidden = false;
    } else {
      this.contextSelectTarget.hidden = false;
      this.contextInputTarget.hidden = true;
    }
  }
  // submitForm(event) {
  //   if(!this.validateForm){
  //     //this.errorsTarget.innerHTML(errorContainer);
  //     event.preventDefault();
  //   }
  // }

  // get submitForm(){
  //   let isValid = true;
  //   let errorContainer = [];
  //   let content = this.contentTarget.value;
  //   let articleType = this.articleTypeIdTarget.value;

  //   if(content == undefined || content.length <= 0){ 
  //     isValid = false ;
  //     errorContainer.push("Article Type cann't be blank.")
  //   }
  //   if(articleType == undefined || articleType.length <= 0){ 
  //     isValid = false ;
  //     errorContainer.push("Article content cann't be blank.")
  //   }
  //   //return isValid;
  //   if(errorContainer.length > 0){
  //     this.errorsTarget.innerHTML(errorContainer);
  //     event.preventDefault();
  //   }
  // }
}