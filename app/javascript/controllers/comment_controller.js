import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="article"
export default class extends Controller {
  static targets = ['newComment', 'csrfToken', 'editComment', 'commentTxt', 
    'editButton', 'updateButton','replyButton', 'replyComment'];

  connect() {
    this.displayTextArea = {};
  }


  showTextarea(commentId, action_type){
    if(this.displayTextArea.id)
      $(this.displayTextArea.id).hide();

    if(action_type == 'edit'){

      if(this.displayTextArea.action_type == "edit"){
        $("#edit-btn-" + this.displayTextArea.commentId).removeClass('hide');
        $("#update-btn-" + this.displayTextArea.commentId).addClass('hide');
        $("#comment-" + this.displayTextArea.commentId).show()
      } else {
        // if(this.displayTextArea.id) 
        //   $(this.displayTextArea.id).hide();

        $("#edit-btn-"+commentId).addClass('hide');
        $("#update-btn-"+commentId).removeClass('hide');
      }

      $("#edit-textarea-"+commentId).show();
      $("#comment-"+commentId).hide()
      this.displayTextArea.id = "#edit-textarea-" + commentId;
      this.displayTextArea.commentId = commentId;
      this.displayTextArea.action_type = 'edit';
    } else if(action_type == "reply") {

      if(this.displayTextArea.action_type == "edit"){
        $("#edit-btn-" + this.displayTextArea.commentId).removeClass('hide');
        $("#update-btn-" + this.displayTextArea.commentId).addClass('hide');
        $("#comment-" + this.displayTextArea.commentId).show();
      }

      //$("#reply-textarea-"+commentId).show();
      $("#reply-block-"+commentId).show();
      //this.displayTextArea.id = "#reply-textarea-" + commentId;
      this.displayTextArea.id = "#reply-block-" + commentId;
      this.displayTextArea.commentId = commentId;
      this.displayTextArea.action_type = "reply"
    } 
  }

  cancelNewComment(){
    this.newCommentTarget.value = ''
  }

  openEditCommentBox(){
    let comment = event.target.parentElement.previousElementSibling.textContent.trim();
    let articleId = this.newCommentTarget.dataset.article_id;
    let commentId = event.target.dataset.comment_id;

    this.showTextarea(commentId, 'edit');
    $("#edit-textarea-"+commentId).val(comment);
    // event.target.parentElement.previousElementSibling.classList.add('hide');
    // event.target.parentElement.previousElementSibling.outerHTML += txtArea;
    // event.target.classList.add("hide");
    // event.target.nextElementSibling.classList.remove("hide");
  }

  openReplyCommentBox(){
    let txtArea = ''
    let articleId = this.newCommentTarget.dataset.article_id;
    let commentId = event.target.dataset.comment_id;

    this.showTextarea(commentId, 'reply');

    // event.target.parentElement.previousElementSibling.classList.add('hide');
    // event.target.parentElement.previousElementSibling.outerHTML += txtArea;
    // event.target.classList.add("hide");
    // event.target.nextElementSibling.classList.remove("hide");
  }

  cancelRepliedComment(){
    let commentId = event.target.dataset.comment_id;
    this.showTextarea(commentId, 'cancel_reply');
  }

  submitNewComment(){
    let comment = this.newCommentTarget.value;
    let parentId = event.target.dataset.parent_id;
    let parentName = event.target.dataset.parent_name;
    let csrfToken = this.csrfTokenTarget.value;

    let params = {comment: {}}; 
      params.parent_id = parentId;
      params.parent_name = parentName;
      params.comment.comment = comment;
      params.authenticity_token = csrfToken;
    let url = "/comments";
    let requestType = 'POST';

    if(comment.length > 0){
      this.createData(requestType, url, params);
    }
  }

  submitUpdatedComment(){
    let commentId = event.target.dataset.comment_id;
    let comment = $("#edit-textarea-" + commentId).val();
    let parentId = event.target.dataset.parent_id;
    let parentName = event.target.dataset.parent_name;
    let csrfToken = this.csrfTokenTarget.value;

    $("#edit-btn-" + commentId).removeClass('hide');
    $("#update-btn-" + commentId).addClass('hide');
    //$("#comment-" + commentId).html(comment).show();
    //$("#edit-textarea-"+commentId).hide();

    this.displayTextArea = {};

    let params = {comment: {}}; 
      params.parent_id = parentId;
      params.parent_name = parentName;
      params.comment.comment = comment;
      params.authenticity_token = csrfToken;
    let url = "/comments/"+commentId;
    let requestType = 'PATCH';
    this.createData(requestType, url, params);
    // event.target.parentElement.previousElementSibling.innerHTML = comment;
    // event.target.parentElement.previousElementSibling.classList.remove('hide');
    // event.target.classList.add("hide");
    // event.target.previousElementSibling.classList.remove("hide");
  }

  submitRepliedComment(){
    let commentId = event.target.dataset.comment_id;
    let comment = $("#reply-textarea-" + commentId).val();
    let parentId = event.target.dataset.parent_id;
    let parentName = event.target.dataset.parent_name;
    let depth = event.target.dataset.depth;
    let csrfToken = this.csrfTokenTarget.value;

    let params = {comment: {}}; 
      params.comment.comment = comment;
      params.parent_id = parentId;
      params.parent_name = parentName;
      params.comment.depth = depth;
      params.comment_id_to_append_element = commentId;
      params.authenticity_token = csrfToken;
    let url = "/comments";
    let requestType = 'POST';
    this.createData(requestType, url, params);
  }

  deleteComment(){
    let commentId = event.target.dataset.comment_id;
    let csrfToken = this.csrfTokenTarget.value;
    let params = {authenticity_token: csrfToken};

    let url = "/comments/"+commentId;
    let requestType = 'DELETE';
    this.createData(requestType, url, params);
  }

  /* start js block - make ajax requext */
  createData(requestType, url, params){
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