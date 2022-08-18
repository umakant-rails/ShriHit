import { Controller } from "@hotwired/stimulus"
import ApplicationController from "./application_controller";

export default class extends ApplicationController {
  static targets = ['tagSelectInput', 'tagList', 'articleTags', 'newTag', 'newTagBlock']

  connect(){
    this.tagsArray = this.tagSelectInputTarget.dataset.tags.split(",");
    this.selectedTagList = (this.articleTagsTarget.value.length > 0) ? this.articleTagsTarget.value.split(",") : [];
  }

  showTagsDataList(){
    var datalist = "<option value=''>Select Tag</option>";
    var tagArray = this.tagsArray;
    for(let i=0; i<tagArray.length; i++){
      if(this.selectedTagList.indexOf(tagArray[i].trim()) == -1 ){
        datalist += "<option data-action='click->tagging#selectTag'>" + tagArray[i] + "</option>";
      }
    }
    datalist = datalist + "<option value='new'>नया टैग टाइप करे </option>";
    this.tagSelectInputTarget.innerHTML = datalist;
  }

  addTagInHtml(){
    var tagsHtmlContent = '';
    for(const tag of this.selectedTagList){
      let html_content = `<span class='tags'>  ${tag}
        <i class='fa-solid fa-xmark tags-cross' data-tags-target='crossTag' 
          data-action='click->tagging#removeTag'></i>
        </span>`;
      tagsHtmlContent = tagsHtmlContent + html_content;
    }
    this.articleTagsTarget.value = this.selectedTagList.join(",");
    this.tagListTarget.innerHTML = tagsHtmlContent;
  }

  selectTag(){
    var valueTxt = this.tagSelectInputTarget.value.trim();
    if(valueTxt == "new"){
      this.tagSelectInputTarget.style.display = "none";
      this.newTagBlockTarget.style.display = "block";
    } else if( valueTxt.length > 0 ){
      this.selectedTagList.push(valueTxt);
    }
    setTimeout(()=> {this.tagSelectInputTarget.value = ""}, 300);
    this.addTagInHtml()
    this.showTagsDataList();
  }

  createTagFromInput(){
    if(event.keyCode == 188){
      var valueTxt = this.newTagTarget.value;
      valueTxt = valueTxt.substring(0, valueTxt.indexOf(",")-1).trim();
      if(this.selectedTagList.indexOf(valueTxt) > -1){
        super.showErrorsByLayout("यह टैग लिस्ट में पहले से उपलब्ध है");
      } else if(this.tagsArray.indexOf(valueTxt) > -1){
        super.showErrorsByLayout("ययह टैग सूची में पूर्व से उपलब्ध है कृपया इसको सूची से चुने !"); 
      } else if (valueTxt,length > 2){
        this.selectedTagList.push(valueTxt);
        this.addTagInHtml();
      }
      event.target.value = "";
    }
  }
  createTagByInput(){
    var valueTxt = this.newTagTarget.value.trim();
    if(valueTxt.indexOf(",") > 0){
      valueTxt = valueTxt.substring(0, valueTxt.indexOf(",")).trim();
      this.createTag(valueTxt);
    } 
  }
  createTagByButton(){
    var valueTxt = this.newTagTarget.value.trim();
    this.createTag(valueTxt);
  }
  createTag(valueTxt){
    //var valueTxt = this.newTagTarget.value.trim();
    if(this.selectedTagList.indexOf(valueTxt) > -1){
      super.showErrorsByLayout("यह टैग लिस्ट में पहले से उपलब्ध है");
    } else if(this.tagsArray.indexOf(valueTxt) > -1){
      super.showErrorsByLayout("ययह टैग सूची में पूर्व से उपलब्ध है कृपया इसको सूची से चुने !"); 
    } else if(valueTxt.length > 2) {
      this.selectedTagList.push(valueTxt);
      this.addTagInHtml();
      this.newTagTarget.value = "";
    }
  }

  removeTag(){
    var valueTxt = event.target.parentElement.textContent.trim();
    var ind = this.selectedTagList.indexOf(valueTxt);
    if(ind > -1){this.selectedTagList.splice(ind, 1)}
    this.addTagInHtml();
  }

  showtagList(){
    this.tagSelectInputTarget.style.display = "block";
    this.newTagBlockTarget.style.display = "none";
  }
}
