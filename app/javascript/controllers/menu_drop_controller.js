// Connects to data-controller="menu"

import { Controller } from "@hotwired/stimulus"
//import _ from "lodash!"

import { useClickOutside } from 'stimulus-use';

export default class extends Controller {

    static targets = ["dropdownmobile", "toggleUser", "dropdownMobileSub" ];                  

    // toggle function will be here 
    // "toggleable", 
  connect() {
    //this.element.textContent = "Hello World!!!"
    //console.log("Hello World!!!");
    
      useClickOutside(this);
    //useClickOutside(this, { element: this.dropdownmobileTarget  });
    
  };

  toggleUser() {
    //console.log("Hello World!!!");

    if (this.toggleUserTarget) {
      console.log(this.toggleUserTarget);
      if (this.toggleUserTarget) this.toggleUserTarget.classList.toggle("hidden");

    }
 };

 toggleMobile() {
  // console.log("Hello World!!!");
  if (this.dropdownmobileTarget) {
    console.log("this.dropdownmobileTarget = ",this.dropdownmobileTarget);
    if (this.dropdownmobileTarget) this.dropdownmobileTarget.classList.toggle("hidden");    
    };
  };

  toggleMobileSub() {
    // console.log("Hello World!!!");
    if (this.dropdownMobileSubTarget) {
      console.log("this.dropdownMobileSubTarget = ",this.dropdownMobileSubTarget);
      if (this.dropdownMobileSubTarget) this.dropdownMobileSubTarget.classList.toggle("hidden");    
      };
    };

// toggleBoard() {
//   // console.log("Hello World!!!");
//   console.log(this.dropdownboardTarget);
//   if (this.dropdownboardTarget) this.dropdownboardTarget.classList.toggle("hidden");    
// };

  clickOutside(event) {
  // event.preventDefault();

  // this.modal.close();
  let divField;

  if (this){
    //console.log("this=", this);
    divField = document.getElementById("dropdown_menu_user");
    if (divField && this.toggleUserTarget && !divField.classList.contains('hidden')) this.toggleUserTarget.classList.toggle("hidden");
}
  
if (document.getElementById("dropdown_menu_mobile") && this.dropdownmobileTarget){
   //console.log(this.dropdownmobileTarget);
     //console.log("this.dropdownmobileTarget)=", this.dropdownmobileTarget);
     divField = document.getElementById("dropdown_menu_mobile");
    if (divField && this.dropdownmobileTarget && !divField.classList.contains('hidden')) this.dropdownmobileTarget.classList.toggle("hidden");
 };

  

}


  handleClick() {
    // this.element.textContent = "Clicked!"
   // this.element.textContent = _.intersection([2, 1], [2, 3]);

  //  let divField = document.getElementById("dropdown_menu_user");

  //  document.addEventListener("click", (event)=> {
  //    console.log("event.target=", event.target);
  //   if (!event.target.contains(divField)) {
  //    this.toggleUserTarget.classList.toggle("hidden");         
  //     }
  //   });
  };


}
