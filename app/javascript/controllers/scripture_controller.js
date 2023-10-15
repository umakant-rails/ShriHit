import { Controller } from "@hotwired/stimulus"
import ApplicationController from "./application_controller";

export default class extends ApplicationController {
  static targets = ['next', 'previous', 'page', 'pageParent', 'indexingPage']

  connect(){
  }

  displayPageData(target, pageIndex){
    // this.previousTarget.dataset.page = pageIndex;
    // this.nextTarget.dataset.page = pageIndex;
    // this.pageTargets.map(target => target.classList.add('hide'));
    // target.classList.remove('hide');
    
    var newTarget = this.pageTargets.find( target => target.dataset.page == pageIndex);
    if(newTarget != undefined){
      target.classList.add('hide');
      newTarget.classList.remove('hide');
    }
  }
  next(event){
    // var pageIndex = event.target.dataset.page;
    // pageIndex = parseInt(pageIndex) + 1;
    // var target = this.pageTargets.find( target => target.dataset.page == pageIndex);
    // if (target != undefined) {
    //   this.displayPageData(target, pageIndex);
    // } else {
    //   this.nextTarget.disabled = true;
    // }
    var target = this.pageTargets.find( target => !target.classList.contains('hide'));
    var pageIndex = parseInt(target.dataset.page) + 1;

    this.displayPageData(target, pageIndex);
  }

  previous(event){
    // var pageIndex = event.target.dataset.page;
    // pageIndex = parseInt(pageIndex) - 1;
    // var target = this.pageTargets.find( target => target.dataset.page == pageIndex);
    // if (target != undefined) {
    //   this.displayPageData(target, pageIndex);
    // } else {
    //   this.previousTarget.disabled = true;
    // }
    var target = this.pageTargets.find( target => !target.classList.contains('hide'));
    var pageIndex = parseInt(target.dataset.page) - 1;
    this.displayPageData(target, pageIndex);
  }

  displayPage(event){
    var target = this.pageTargets.find( target => !target.classList.contains('hide'));
    var pageIndex = parseInt(event.target.dataset.index);
    this.pageParentTarget.classList.remove('hide');
    this.indexingPageTarget.classList.add('hide');
    this.displayPageData(target, pageIndex);
  }

  displayPageIndexing(event){
    var isHideIndexingPage = this.indexingPageTarget.classList.contains('hide');
    if(isHideIndexingPage){
      this.pageParentTarget.classList.add('hide');
      this.indexingPageTarget.classList.remove('hide');
    } else {
      this.pageParentTarget.classList.remove('hide');
      this.indexingPageTarget.classList.add('hide');
    }
  }
}
