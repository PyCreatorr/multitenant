import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="turbomodal"
export default class extends Controller {
  connect() {

    //console.log("hello from turbomodal");
  }

  static targets = [ "blurable" ];


//   close() {
//     console.log(this.hideableTarget);
//     this.hideableTarget.classList.toggle("hidden");    
//  };
submitEnd(e){
    //console.log(e.detail.success);
    if (e.detail.success) this.hideModal();

  }

  hideModal(){
    // this.element.remove();
    const modal = document.getElementById("modal");
    modal.innerHTML="";

  }

  close(e){
    // Prevent default action -> refresh the page
    e.preventDefault();

    const modal = document.getElementById("modal");
    modal.innerHTML="";

    //Remove the src attribute from the modal
    modal.removeAttribute("src");

    //Remove attribute complete
    modal.removeAttribute("complete");
  }

  blurMe() {
    console.log(this.blurableTarget);
     this.blurableTarget.classList.toggle("body-blur-filter");    
 };


}
