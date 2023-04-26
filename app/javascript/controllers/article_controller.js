import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="article"
export default class extends Controller {
  static targets = ['form', 'content', 'articleTypeId', 'errors',
    'contextSelect', 'contextInput', 'authorSelect', 'authorInput'];

  connect() {
  }

  toggleAuthor(){
    // let authorValue = this.authorSelectTarget.value;
    // if(authorValue == 'NA' && !this.authorSelectTarget.hidden){
    //   this.authorSelectTarget.hidden = true;
    //   this.authorInputTarget.hidden = false;
    // } else {
    //   this.authorSelectTarget.hidden = false;
    //   this.authorInputTarget.hidden = true;
    // }
  }
  toggleContext(){
    // let contextValue = this.contextSelectTarget.value;
    // if(contextValue == 'NA' && !this.contextSelectTarget.hidden) {
    //   this.contextSelectTarget.hidden = true;
    //   this.contextInputTarget.hidden = false;
    // } else {
    //   this.contextSelectTarget.hidden = false;
    //   this.contextInputTarget.hidden = true;
    // }
  }

  setBhajanContext(event){
    let selectedArticleType = event.target.options[event.target.selectedIndex].text;;
    if(selectedArticleType != "भजन") {
      this.contextSelectTarget.selectedIndex = 0;
    } else {
      let options = this.contextSelectTarget.options;
      for(let i=0; i<options.length; i++){
        if(options[i].text.trim() == "विविध"){
          //this.contextSelectTarget.value = options[i].value;
          this.contextSelectTarget.selectedIndex = i;
        }
      }
    }
  }

  setHindiTitle(){
    let txt = tinymce.get("article_content").getContent({format: 'text'});
      if(txt.length >  5 ){
      let indx = txt.indexOf("\n")
      event.target.value = txt.substring(0, indx);
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