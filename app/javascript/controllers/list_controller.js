import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="list"

const SINGLE_CLICK_TIMEOUT = 300;

export default class extends Controller {

  static targets = ["name"];

  connect() {

    // console.log("Connected_list");
    this.clickCount= 0;
    this.singleClickTimer = null;
    this.originalNameTarget = null;
  }

  handleClick(event){
    console.log("Clicked");
    event.preventDefault();
   
     this.originalNameTarget = this.nameTarget;
     console.log("this.nameTarget = ",this.originalNameTarget);
     let listName = this.originalNameTarget.querySelector("a").innerText;
     console.log("listName = ",listName);
     let inputField = this.createInputField(listName);
     console.log("inputField = ",inputField);
     console.log("this.element.replaceChild = ", this.element);
     this.element.replaceChild(inputField, this.nameTarget);
     inputField.focus();
   }

   createInputField(value){
    let inputField = document.createElement("input");
    inputField.type="text";
    inputField.value = value;
    inputField.style.width="100%";
    inputField.style.boxSizing = "border-box"; // Include padding and border in element's total width
    inputField.style.height = "inherit"; // Set height to inherit from the parent
    inputField.style.lineHeight = "inherit";
    inputField.addEventListener("blur", this.submit.bind(this));
    inputField.addEventListener("keyup", (event) => {
      if (event.key === "Enter") {event.target.blur(); }
    });
  
    return inputField;
  }

  submit(event){
    let inputField = event.target;
    let { listId } = this.element.dataset;
    console.log("listId = ", listId);
    let listName = inputField.value;
    
    fetch(`/lists/${listId}`, {
      method: "PATCH", 
      headers: {
        "Content-Type": "application/json",
        Accept:  "application/json",
        "X-CSRF-Token": this.getMetaValue("csrf-token")
      },
      body: JSON.stringify({ list: {name: listName} }),
      credentials: "same-origin",
    })
      .then((response) => response.json())
      .then(({ status, name }) =>{
        if(status === "ok") {
          this.originalNameTarget.querySelector("a").innerText = name;
          this.element.replaceChild(this.originalNameTarget, inputField);
        } else { // Handle error ...
        };
    })
       .catch((error) => {
      //Handle catch errors
       console.error("Error:", error);
    });  
  }
  
  // <meta name="csrf-token" content="W3sp3zCCIcb8Uzgndi8l1PG1qoj0QqC64ezlYhhdkMviZ_LZZ-rkNUyKk7pSn3sc6DoKRkfg4zjgQNbA1AIciA">
   getMetaValue(name){
    const element = document.head.querySelector(`meta[name="${name}"]`);
    return element.getAttribute("content");
  }
}
