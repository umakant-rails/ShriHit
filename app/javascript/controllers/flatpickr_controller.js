import Flatpickr from "stimulus-flatpickr";

export default class extends Flatpickr {
  connect() {
    //define locale and global flatpickr settings for all datepickers
    this.config = {
      altInput: true,
      showMonths: 1
    };
    super.connect();
  }
}