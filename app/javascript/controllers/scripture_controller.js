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
    var pageIndex = parseInt(event.target.dataset.index);
    this.pageParentTarget.classList.remove('hide');
    // this.indexingPageTarget.classList.add('hide');
    this.displayPageData(target, pageIndex);
  }

  displayPageIndexing(event){
    var isHideIndexingPage = this.indexingPageTarget.classList.contains('hide');
    if(isHideIndexingPage){
      // this.pageParentTarget.classList.add('hide');
      this.indexingPageTarget.classList.remove('hide');
      this.pageParentTarget.classList.remove('col-md-12');
      this.pageParentTarget.classList.add('col-md-8');
    } else {
      // this.pageParentTarget.classList.remove('hide');
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
