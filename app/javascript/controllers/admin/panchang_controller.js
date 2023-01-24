import { Controller } from "@hotwired/stimulus"
import ApplicationController from "../application_controller";

export default class extends ApplicationController {
  static targets = ['calendarDate', 'dateStatus', 'form', 'tithi', 'paksh',
    'samvat', 'desc', 'tagLabel',
    'date', 'month', 'title', 'csrfToken', 'mode'
   ];

  connect(){
    this.params = {};
    // const tithiTxt =  this.tithiTarget.value;
    // this.tithiya = tithiTxt.length > 0 ? tithiTxt.split(",") : [];
    this.tithiya = [];
  }

  // displayPurshottamMonth(){
  //   let selectedStatus = event.target.value;
  //   console.log(selectedStatus)
  //   if(selectedStatus == "true"){
  //     this.purshottamMonthBlockTarget.style.display = "block";
  //   } else {
  //     this.purshottamMonthBlockTarget.style.display = "none";
  //     this.purshottamMonthTarget.value = ''
  //   }
  // }

  getTithi(){
    let month_id = this.monthTarget.value;
    let panchang_id = this.monthTarget.dataset.panchang_id;
    let url = "/admin/panchangs/"+panchang_id+"/month/"+month_id+"/get_tithis"
    this.update_data('get', url);
  }

  displayTitle(){
    let title = this.tithiTarget.options[this.tithiTarget.selectedIndex].dataset.title;
    this.titleTarget.value = title;
  }

  selectDate(){
    let date, tdElement;
    let operationMode = this.modeTarget.value;
    console.log(operationMode)
    if(event.target.classList.value.indexOf("date-active") != -1){
      tdElement = event.target.parentElement;
    } else {
      tdElement = event.target;
    }

    if(tdElement.classList.value.indexOf('utsav') >= 0 && operationMode == 'Edit'){
      let tithiId = tdElement.dataset.tithiid;
      date = tdElement.dataset.date;
      window.location.href = `/admin/panchangs/${tithiId}/edit_tithis?date=${date}`;
    }

    let classList = tdElement.classList.value;
    const selectedDateTarget = this.calendarDateTargets.find(target => target.classList.value.indexOf("selected")>=0 )
    if(selectedDateTarget != undefined){selectedDateTarget.classList.remove('selected');}

    if(classList.indexOf("current-month") >= 0){
      tdElement.classList.add('selected');
      date = tdElement.dataset.date;
    }
    this.dateTarget.value = date;
  }

  selectTithi(){
    let tithiyaTxt = '';
    // let tithiTxt = event.target.value;
    let tithiTxt = this.tithiTarget.options[this.tithiTarget.selectedIndex].dataset.tithi;
    let pakshTxt = this.tithiTarget.options[this.tithiTarget.selectedIndex].dataset.paksh;

    if (tithiTxt.length == 0)
      return;

    let diff =  (this.tithiya.length == 1) ? parseInt(this.tithiya[0]) - parseInt(tithiTxt) : undefined;

    if(diff > 1 || diff < -1) {
      super.showErrorsByLayout("एक दिवस के लिए चुनी गई दो तिथियां में अन्तर एक दिवस से अधिक नहीं हो सकता है.");
      window.scrollTo(0, 0);
      this.tithiya = [];
    } else if(this.tithiya.indexOf(tithiTxt) < 0 && this.tithiya.length < 2) {
      this.tithiya.push(tithiTxt)
    } else {
      super.showErrorsByLayout("एक दिवस के लिए दो से ज्यादा तिथियां नहीं चुनी जा सकती है.");
      window.scrollTo(0, 0);
    }

    for(let tithi of this.tithiya){
      tithiyaTxt += tithiyaTxt.length>0 ? "," + tithi : tithi;
    }
    let tags = `<span class="tags"> ${tithiyaTxt}
      <i class="fa-solid fa-xmark tags-cross" data-tags-target="crossTag"
        data-action="click->admin-panchang#removeTag"></i>
    </span>`;

    if(this.tithiya.length > 0){
      this.tithiTarget.value = tithiyaTxt;
      this.tagLabelTarget.innerHTML = tags;
    } else {
      this.tithiTarget.value = '';
      this.tagLabelTarget.innerHTML = '';
    }
  }

  removeTag(){
    event.target.parentElement.remove();
    this.tithiTarget.value = '';
    this.tithiya = [];
  }

  submitForm(e){
    let csrfToken = this.csrfTokenTarget.value;
    let panchangId = this.monthTarget.dataset.panchang_id;
    let monthId = this.monthTarget.value;
    let tithi_id = this.tithiTarget.value;
    let date = this.dateTarget.value;
    let title = this.titleTarget.value;
    let desc = this.descTarget.value;
    let isFormNotValidated = false;
    let errors = [];
    this.tithiya = [];

    tithi_id.length == 0 ? errors.push('तिथि खाली नहीं हो सकती, कृपया तिथि चुने |') : '';
    date.length == 0 ? errors.push('कृपया पहले कैलेंडर में से दिनांक चुने ') : '';

    if(errors.length > 0){
      e.preventDefault();
      $("#successAlert").parent().css("display", "none");
      $("#errorsAlert").parent().css("display", "none");
      super.showErrorsByLayout(errors.join('<br>'));
      window.scrollTo(0, 0);
    } else {
      let url = "/admin/panchangs/"+panchangId+"/tithi/" + tithi_id + "/update";
      this.params = {
        authenticity_token: csrfToken,
        panchang_id: panchangId,
        month_id: monthId,
        date: date,
        title: title,
        desc: desc
      }
      this.update_data('POST', url)
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
