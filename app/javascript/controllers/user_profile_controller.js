//import { ValidationController } from "stimulus-validation"
import { Controller } from "@hotwired/stimulus"
import ApplicationController from "./application_controller";

export default class extends ApplicationController {
  static targets = ['form', 'mobile', 'pincode', 'errors'];
  //static numberOnlyRegExp = new RegExp("/^\d+$/");

  connect(){
    // document.addEventListener("autocomplete.change", this.autocomplete.bind(this));
  }

  validateMobile(){
    let error;
    let mobileValue = this.mobileTarget.value;
    let numberOnlyRegExp = new RegExp(/^\d{0,10}$/);
    let isValid = mobileValue.match(numberOnlyRegExp);

    if(isValid == null && mobileValue.length<=10){
      error = "Only number is allowed for mobile.";
      this.mobileTarget.value = mobileValue.substr(0, mobileValue.length-1);
      super.showError(this.errorsTarget, error);
    } else if(isValid == null && mobileValue.length>10){
      error = "Only 10 digit allowed to mobile number.";
      this.mobileTarget.value = mobileValue.substr(0, 10);
      super.showError(this.errorsTarget, error);
    }
  }

  validatePincode(){
    let error;
    let pincodeValue = this.pincodeTarget.value;
    let numberOnlyRegExp = new RegExp(/^\d{0,6}$/);
    let isValid = pincodeValue.match(numberOnlyRegExp);

    if(isValid == null && pincodeValue.length<=10){
      error = "Only number is allowed for pincode.";
      this.pincodeTarget.value = pincodeValue.substr(0, pincodeValue.length-1);
      super.showError(this.errorsTarget, error);
    } else if(isValid == null && pincodeValue.length>10){
      error = "Only 6 digit allowed to pincode.";
      this.pincodeTarget.value = pincodeValue.substr(0, 10);
      super.showError(this.errorsTarget, error);
    }
  }

}