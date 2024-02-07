import { Controller } from "@hotwired/stimulus"
//import _ from "lodash !!!!"

export default class extends Controller {

    static targets = [ "dropdownable" ];
                  

    // toggle function will be here 
  connect() {
    //this.element.textContent = "Hello World!!!"

        // Add click event listener to close the field when clicking outside the textarea
        // document.addEventListener("click", (event)=> {
        //   console.log("event.target=", event.target);
        //  if (event.target.contains(divField)) {
        //      if (inputField) inputField.remove();
        //      let bluredField = document.getElementById("bluredField");
        //      if (bluredField) bluredField.remove();
   
        //      this.originalNameTarget.querySelector("a").style.visibility = "visible";
        //      this.originalNameTarget.style.borderStyle = "solid";
        //      this.originalNameTarget.style.backgroundColor="#ffffff";
        //    }
        //  });
        //console.log("Hello World!!!");
  };

  dropdownHide() {
    //console.log(this.dropdownableTarget);
    this.dropdownableTarget.classList.toggle("hidden");    
 };


  handleClick() {
    // this.element.textContent = "Clicked!"
    //this.element.textContent = _.intersection([2, 1], [2, 3]);
  };
}
