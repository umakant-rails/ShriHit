import { Controller } from "@hotwired/stimulus"
import ApplicationController from "./application_controller";

export default class extends ApplicationController {
  static targets = ['next', 'previous', 'page', 'pageParent', 'indexingPage']

  connect(){
  }

  displayPageData(target, pageIndex){
    var newTarget = this.pageTargets.find( target => target.dataset.page == pageIndex);
    if(newTarget != undefined){
      target.classList.add('hide');
      newTarget.classList.remove('hide');
      window.scrollTo(0,0);
    }
  }
  navigationNext(){
    var target = this.pageTargets.find( target => !target.classList.contains('hide'));
    var pageIndex = parseInt(target.dataset.page) + 1;
    this.displayPageData(target, pageIndex);
  }

  navigationPrevious(){
    var target = this.pageTargets.find( target => !target.classList.contains('hide'));
    var pageIndex = parseInt(target.dataset.page) - 1;
    this.displayPageData(target, pageIndex);
  }

  displayPage(event){
    var target = this.pageTargets.find( target => !target.classList.contains('hide'));
    console.log(event.target)
    var pageIndex = parseInt(event.target.dataset.index);
    this.displayPageData(target, pageIndex);
    this.displayPageIndexing();
    // var offset = this.pageParentTarget.getBoundingClientRect();
    // var topp = Math.round(offset.top);

    // var index = event.target.dataset.index;
    // var height = 0;
    // for(let count=0;count<index-1;count++){
    //   height = height + $(`#pad-${count}`).height();
    // }
    // this.pageParentTarget.scrollTop = 132;
    // this.pageParentTarget.scrollTop=height + (16*index);

  }

  displayPageIndexing(event){
    var isHideIndexingPage = this.indexingPageTarget.classList.contains('hide');
    if(isHideIndexingPage){
      this.pageParentTarget.classList.add('hide');
      this.indexingPageTarget.classList.remove('hide');
      this.pageParentTarget.classList.remove('col-md-12');
      this.pageParentTarget.classList.add('col-md-8');
    } else {
      this.pageParentTarget.classList.remove('hide');
      this.indexingPageTarget.classList.add('hide');
      this.pageParentTarget.classList.remove('col-md-8');
      this.pageParentTarget.classList.add('col-md-12');
    }
  }

  navigation(event){
    var mousePosition = event.pageX;
    var offset = this.pageParentTarget.getBoundingClientRect();
    var divLeft = Math.round(offset.left);
    var divRight = Math.round(offset.right);
    var divHalfPosition = divLeft + (divRight-divLeft)/2;
    if(mousePosition < divHalfPosition){
      this.navigationPrevious();
    } else {
      this.navigationNext()
    }
  }
}
