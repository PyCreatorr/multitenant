import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="listtask"

import { get, post, put, patch, destroy } from '@rails/request.js';



export default class extends Controller {

  static targets = ["tname", "listsSelect", "tasksSelect"];

  connect() {

    console.log("Connected_task");
    this.originalNameTarget = null;

  }

  handleTaskClick(event){
    console.log("Clicked");
    event.preventDefault();
  

    // Optionally, trigger the function on page load to handle pre-filled content
     //window.addEventListener('input', this.autoResizeTextarea());

    const icon_edit = document.getElementById("icon_edit");
    //icon_edit.innerHTML="";
   
     this.originalNameTarget = this.tnameTarget;
     console.log("this.nameTarget = ",this.originalNameTarget);
     let taskName = this.originalNameTarget.querySelector("a").innerText;
     console.log("taskName = ",taskName);
     let inputField = this.createInputField(taskName);
     console.log("inputField = ",inputField);
     console.log("this.element.replaceChild = ", this.element);


     //this.element.replaceChild(inputField, this.tnameTarget);
     this.element.append(inputField, this.tnameTarget);



    // Attach the autoResizeTextarea function to the input event of the textarea
    let textareaClicked = document.getElementById('resizableTextarea');
    console.log("textareaClicked= ", textareaClicked);
    if (textareaClicked) {
      textareaClicked.addEventListener('input', this.autoResizeTextarea(textareaClicked));
    }


     inputField.focus();
   }

    // Function to auto-resize the textarea
    autoResizeTextarea(el) {
      //const textarea = document.getElementById('resizableTextarea');
      if (el){
        el.style.height = 'auto'; // Reset the height to auto to allow it to shrink
        el.style.height = (el.scrollHeight) + 'px'; // Set the height to the scrollHeight
      console.log("el.scrollHeight =", el.scrollHeight);
      }
    }


   createInputField(value){
    //let inputField = document.createElement("input");
    let inputField = document.createElement("textarea");
    inputField.id = "resizableTextarea";
    // inputField.type="text";
    //inputField.minRows="2";
    inputField.value = value;
    //inputField.style.width="244px"; 
    // inputField.style.zIndex="100000"; 
    inputField.style.position="absolute"; 
    inputField.style.height = 'auto';
    inputField.style.wordBreak= "break-all";
    inputField.style.resize="both";
    inputField.style.overflow="hidden";
    // inputField.style.marginRight="5px";    
    inputField.style.boxSizing = "border-box"; // Include padding and border in element's total width
    //inputField.style.height = "inherit"; // Set height to inherit from the parent
    // inputField.style.lineHeight = "24px";
    //inputField.style.width = "inherit";
    //inputField.style.height="42px"; 

    inputField.classList.add('textarea_style');

    inputField.addEventListener("blur", this.submit.bind(this));
    inputField.addEventListener("keyup", (event) => {
      if (event.key === "Enter") {event.target.blur();}
    });
    inputField.addEventListener("input", () => {
      this.autoResizeTextarea(inputField);
    });


    let divField = document.createElement("div");
    divField.classList.add('blur-overlay');
    divField.id="bluredField";

    // Add click event listener to close the field when clicking outside the textarea
    document.addEventListener("click", (event)=> {
      console.log("event.target=", event.target);
      if (event.target.contains(divField)) {
          if (inputField) inputField.remove();
          let bluredField = document.getElementById("bluredField");
          if (bluredField) bluredField.remove();
        }
      });

    //inputField.append("<div class='blur-overlay'>ggg</div>");

    let container = document.createElement("div");

    container.appendChild(inputField);
    container.appendChild(divField);

    return container;
  }

  submit(event){
    let inputField = event.target;
    let { taskId } = this.element.dataset;
    console.log("this.element.dataset = ", this.element);

    console.log("taskId = ", taskId);
    let taskName = inputField.value;   

    
    fetch(`/tasks/${taskId}`, {
      method: "PATCH", 
      headers: {
        "Content-Type": "application/json",
        Accept:  "application/json",
        "X-CSRF-Token": this.getMetaValue("csrf-token")
      },
      body: JSON.stringify({ task: {name: taskName} }),
      credentials: "same-origin",
    })
      .then((response) => response.json())
      .then(({ status, name }) =>{
        if(status === "ok") {
          this.originalNameTarget.querySelector("a").innerText = name;

          let bluredField = document.getElementById("bluredField");
          console.log("bluredField=", bluredField);
          if (bluredField) bluredField.remove();
          if (inputField) inputField.remove();

          //this.element.replaceChild(this.originalNameTarget, inputField);
        } else { // Handle error ...
        };
    })
       .catch((error) => {
      //Handle catch errors
       console.error("Error:", error);
    });  
  }

  changeBoard(event){
    console.log("selected board!");

    let selected_board = event.target.selectedOptions[0].value;
    let target = this.listsSelectTarget.id;
    let tasksTarget = this.tasksSelectTarget.id;

    // let targetList = this.listsSelectTarget.id;

    console.log("target = ", target);
    console.log("tasksTarget = ", tasksTarget);

    console.log("selected_board = ", selected_board);

    let selected_list = event.target.selectedOptions[0].value;

    // let button_submit = document.getElementById("submit_button");

    // console.log("button_submit = ", button_submit);

    get( `/selected_board?selected_board=${selected_board}&target=${target}&tasks_target=${tasksTarget}`,{
      // body: JSON.stringify({
      //   list_id: sortableListId,
      //   row_order_position: event.newDraggableIndex      
      // }),
      responseKind: "turbo-stream",
      contentType: "application/json"
      //responseKind: "html"
    });


  }

  changeList(event){
    console.log("selected list!");

    let selected_list = event.target.selectedOptions[0].value;
    let target = this.tasksSelectTarget.id;
    console.log("target = ", target);

    console.log("selected_list = ", selected_list);

    get( `/selected_list?selected_list=${selected_list}&target=${target}`,{
      // body: JSON.stringify({
      //   list_id: sortableListId,
      //   row_order_position: event.newDraggableIndex      
      // }),
      responseKind: "turbo-stream",
      contentType: "application/json"
      //responseKind: "html"
    });


  }
  
  // <meta name="csrf-token" content="W3sp3zCCIcb8Uzgndi8l1PG1qoj0QqC64ezlYhhdkMviZ_LZZ-rkNUyKk7pSn3sc6DoKRkfg4zjgQNbA1AIciA">
   getMetaValue(name){
    const element = document.head.querySelector(`meta[name="${name}"]`);
    return element.getAttribute("content");
  }
}
