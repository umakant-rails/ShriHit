// application_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect(){
  }

  showErrorByElement(element, error) {
    element.parentElement.style.display = 'block';
    element.innerHTML = error;
  }

  showErrorsByLayout(msg){
    let element = $("#errorsAlert")[0];
    // this.element.getElementsByClassName('counter-count')[0];
    element.parentElement.style.display = 'block';
    element.innerHTML = msg;
  }

  showsuccessMsgByLayout(msg){
    let element = $("#successAlert")[0];
    element.parentElement.style.display = 'block';
    element.innerHTML = msg;
  }
}