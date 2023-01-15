import { Controller } from "@hotwired/stimulus"
import ApplicationController from "../application_controller";

export default class extends ApplicationController {
  static targets = ['calendarDate', 'dateStatus', 'form', 'tithi', 'month', 'paksh',
    'samvat', 'desc', 'date'];

  connect(){
    this.params = {};
  }

  selectDate(){
    let date;
    let classList = event.target.classList.value;
    const selectedDateTarget = this.calendarDateTargets.find(target => target.classList.value.indexOf("selected")>=0 )
    if(selectedDateTarget != undefined){selectedDateTarget.classList.remove('selected');}

    if(classList.indexOf("current-month") >= 0){
      event.target.classList.add('selected');
      date = event.target.dataset.date;
    }
    this.dateTarget.value = date;
  }

  submitForm(e){
    let date = this.dateTarget.value;
    let tithi = this.tithiTarget.value;
    let month = this.monthTarget.value;
    let paksh = this.pakshTarget.value;
    let samvat = this.samvatTarget.value;
    let desc = this.descTarget.value;
    let isFormNotValidated = false;
    let errors = [];

    date.length == 0 ? errors.push('कृपया पहले कैलेंडर में से दिनांक चुने ') : '';
    tithi.length == 0 ? errors.push('तिथि खाली नहीं हो सकती, कृपया तिथि चुने |') : '';
    month.length == 0 ? errors.push('माह खाली नहीं हो सकता, कृपया माह चुने |') : '';
    paksh.length == 0 ? errors.push('पक्ष खाली नहीं हो सकता, कृपया पक्ष चुने |') : '';
    samvat.length == 0 ? errors.push('संवत् खाली नहीं हो सकता, कृपया पहले संवत् चुने |') : '';
    desc.length == 0 ? errors.push('विवरण खाली नहीं हो सकता, कृपया विवरण चुने |') : '';

    if(errors.length > 0){
      e.preventDefault();
      super.showErrorsByLayout(errors.join('<br>'));
      window.scrollTo(0, 0);
    }
  }

  /* start js block - make ajax requext */
  update_data(requestType, url){
    $.ajax({
      type: requestType,
      url: url,
      data: this.params,
      dataType: 'script',
      success: function(data){
      }
    });
  }
  /* end js block - make ajax requext */
}
