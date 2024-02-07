// Connects to data-controller="menu"

import { Controller } from "@hotwired/stimulus"
//import _ from "lodash!"

import { useClickOutside } from 'stimulus-use';

export default class extends Controller {

    static targets = [ "toggleable" ];                  

    // toggle function will be here 
  connect() {
    //this.element.textContent = "Hello World!!!"
    console.log("Hello World!!!");
    
    //  useClickOutside(this);
    useClickOutside(this, { element: this.contentTarget });
    
  };

  toggle() {
    console.log("Hello World!!!");

    console.log(this.toggleableTarget);
    this.toggleableTarget.classList.toggle("hidden");    
 };


  handleClick() {
    // this.element.textContent = "Clicked!"
   // this.element.textContent = _.intersection([2, 1], [2, 3]);

  //  let divField = document.getElementById("dropdown_menu_user");

  //  document.addEventListener("click", (event)=> {
  //    console.log("event.target=", event.target);
  //   if (!event.target.contains(divField)) {
  //    this.toggleableTarget.classList.toggle("hidden");         
  //     }
  //   });
  };

  clickOutside(event) {
    // event.preventDefault();
    // console.log("event.target=", event.target);
    // this.modal.close();
    let divField = document.getElementById("dropdown_menu_user");
    if (!divField.classList.contains('hidden')) 
    this.toggleableTarget.classList.toggle("hidden");
    //this.close();
  }
}
