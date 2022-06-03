import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="article"
export default class extends Controller {
  static targets = ['form', 'errors', 'sampradayaSelect', 'sampradayaInput'];

  connect() {
    tinymce.init({
      selector: '.tinymce',
      height: 500,
      menubar: false,
      plugins: [
        'advlist autolink lists link image charmap print preview anchor',
        'searchreplace visualblocks code fullscreen',
        'insertdatetime media table paste code help wordcount'
      ],
       toolbar: 'undo redo | formatselect | ' +
        ' bold italic backcolor | alignleft aligncenter ' +
        ' alignright alignjustify | bullist numlist outdent indent | ' +
        ' removeformat | help'
    });
  }

  toggleSampradaya(){
    let sampradayaValue = this.sampradayaSelectTarget.value;
    if(sampradayaValue == '' && !this.sampradayaSelectTarget.hidden){
      this.sampradayaSelectTarget.hidden = true;
      this.sampradayaInputTarget.hidden = false;
    } else {
      this.sampradayaSelectTarget.hidden = false;
      this.sampradayaInputTarget.hidden = true;
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