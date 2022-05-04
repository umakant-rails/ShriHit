// application_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  
  showError (element, error) {
    //$(element).parent().css('display', 'block');
    element.parentElement.style.display = 'block';
    element.innerHTML = error;
  }
}