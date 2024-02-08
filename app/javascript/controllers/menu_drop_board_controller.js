import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="menu-drop-board"

import { useClickOutside } from 'stimulus-use';

export default class extends Controller {

  static targets = ["dropdownboard" ];

  connect() {
    //console.log("Hello World!!!");
    
    useClickOutside(this);
    //useClickOutside(this, { element: this.dropdownboardTarget });
  }

  toggleBoard() {
    // console.log("Hello World!!!");
    //console.log(this.dropdownboardTarget);
    if (this.dropdownboardTarget) this.dropdownboardTarget.classList.toggle("hidden");    
  };

  clickOutside(event) {
    // event.preventDefault();
  
    // this.modal.close();
    let divField ;
    
    if (document.getElementById("dropdown_menu_board") && this.dropdownboardTarget){
        //console.log("this.dropdownboardTarget =", this.dropdownboardTarget);
  
        divField = document.getElementById("dropdown_menu_board");
        if (divField && this.dropdownboardTarget && !divField.classList.contains('hidden')) this.dropdownboardTarget.classList.toggle("hidden");
      };
  }
}
