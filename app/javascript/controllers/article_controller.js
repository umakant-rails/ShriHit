import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="article"
export default class extends Controller {
  connect() {
    this.element.textContent = "Hello World!"
  }
}