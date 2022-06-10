import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="article"
export default class extends Controller {
  static targets = ["anchorListBlock"];

  connect() {
    this.iconOpenedPreviously = null;
  }

  toggleTab(event){
    let hrefValue = event.currentTarget.dataset.id;
    let iconElement = event.currentTarget.children[1];
    
    if(this.iconOpenedPreviously != null && this.iconOpenedPreviously != iconElement){
      this.iconOpenedPreviously.classList.remove('fa-angle-down');
      this.iconOpenedPreviously.classList.add('fa-angle-right');
      this.iconOpenedPreviously = iconElement;
    } else {
      this.iconOpenedPreviously = iconElement;
    }

    if(iconElement.classList.contains('fa-angle-right')){
      iconElement.classList.remove('fa-angle-right');
      iconElement.classList.add('fa-angle-down');
    } else {
      iconElement.classList.remove('fa-angle-down');
      iconElement.classList.add('fa-angle-right');
    }

    for(let i=0;i<this.anchorListBlockTargets.length;i++){
      if(hrefValue != this.anchorListBlockTargets[i].id){
        this.anchorListBlockTargets[i].classList.remove('show');
      }
    }
  }
}