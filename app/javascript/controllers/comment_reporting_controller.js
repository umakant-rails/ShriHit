import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="article"
export default class extends Controller {
  static targets = ['reportType', 'csrfToken', 'reportTxt', 'submitBtn'];

  connect() {
    this.displayTextArea = {};
  }

  toggleTextBox(){
    let labelOfTxtBox = event.target.parentElement.textContent.trim();
    if(labelOfTxtBox == "Others."){
      this.reportTypeTarget.value = labelOfTxtBox;
      this.reportTxtTarget.disabled = false;
    } else {
      this.reportTypeTarget.value = labelOfTxtBox;  
      this.reportTxtTarget.disabled = true;
    }
  }

  setParameters(){
    this.submitBtnTarget.dataset.article_id = event.target.dataset.article_id;
    this.submitBtnTarget.dataset.comment_id = event.target.dataset.comment_id;
  }

  submitCommentReport(){
    let commentReport = this.reportTypeTarget.value.trim();
    if(commentReport == "Others."){
      commentReport = this.reportTxtTarget.value;
    }
    let articleId = event.target.dataset.article_id;
    let commentId = event.target.dataset.comment_id;
    let csrfToken = this.csrfTokenTarget.value;

    let params = {comment_reporting: {}};
        params.comment_reporting.report_msg = commentReport;
        params.comment_reporting.article_id = articleId;
        params.comment_reporting.comment_id = commentId;
        params.authenticity_token = csrfToken;
    let url = "/comment_reportings";
    let requestType = "POST";

    this.reportAboutComment(url, requestType, params);
  }

  markAsRead(){
    let commentId = event.target.parentElement.dataset.comment_id;
    let csrfToken = this.csrfTokenTarget.value;

    $.ajax({
      type: 'POST',
      url: '/comment_reportings/'+commentId+'/mark_as_read',
      data: {authenticity_token: csrfToken},
      dataType: 'script',
      success: function(data){
      }
    });
  }

  /* start ajax block to make js request */
  reportAboutComment(url, requestType, params){
    $.ajax({
      type: requestType,
      url: url,
      data: params,
      dataType: 'script',
      success: function(data){
      }
    });
  }
  /* end ajax block to make js request */
}