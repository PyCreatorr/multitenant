import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dialog"
export default class extends Controller {
  static targets = ["dialog"];

  connect() {
    //this.element.textContent = "Hello World!!!"
    console.log("Connected!");
    //this.open();

    // onClick: this.open.bind(this);
  };
  toggle() {
    console.log("Open!");
    //this.element.textContent = "Hello World!!!"
    //this.dialogTarget.show();
    this.dialogTarget.showModal();
  }

  close(){
    this.dialogTarget.close("animalNotChosen");
  }
}
