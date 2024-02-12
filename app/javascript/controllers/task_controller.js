import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="listtask"

import { get, post, put, patch, destroy } from '@rails/request.js';



export default class extends Controller {

  static targets = ["tname", "listsSelect", "tasksSelect", "addTName"];

  connect() {

    console.log("Connected_task!!");
    this.originalNameTarget = null;

  }

  handleAddNewTask(event){
    console.log("New task");
    event.preventDefault();

    
    if (!document.getElementById('resizableTaskTextarea')){
    
      this.originalNameTarget = this.addTNameTarget;
      //let taskName = this.originalNameTarget.querySelector("a").innerText;
      
      let taskName = this.originalNameTarget.querySelector("a").innerText;
      //console.log("this.addTNameTarget = ",this.addTNameTarget );
      
      let inputField = this.createInputFieldNewTask("");
      this.element.prepend(inputField, this.addTNameTarget.parentNode);
      
      // Attach the autoResizeTextarea function to the input event of the textarea
      
      let textareaClicked = document.getElementById('resizableTaskTextarea');

      if (textareaClicked) {
        textareaClicked.addEventListener('input', this.autoResizeTextarea(textareaClicked));
      }
      inputField.focus();      
     }
  };

  handleTaskClick(event){
    // console.log("Clicked");
    event.preventDefault();
  

    // Optionally, trigger the function on page load to handle pre-filled content
     //window.addEventListener('input', this.autoResizeTextarea());

    const icon_edit = document.getElementById("icon_edit");
    //icon_edit.innerHTML="";
   
     this.originalNameTarget = this.tnameTarget;
    //  console.log("this.nameTarget = ",this.originalNameTarget);
     let taskName = this.originalNameTarget.querySelector("a").innerText;
    //  console.log("taskName = ",taskName);

     let inputField = this.createInputField(taskName);
    //  console.log("inputField = ",inputField);
    //  console.log("this.element.replaceChild = ", this.element);


     //this.element.replaceChild(inputField, this.tnameTarget);
     this.originalNameTarget.querySelector("a").style.visibility = "hidden";

     this.originalNameTarget.style.borderStyle = "hidden";

     this.originalNameTarget.style.backgroundColor="#f8f8f8";
     
     this.element.append(inputField, this.tnameTarget);



    // Attach the autoResizeTextarea function to the input event of the textarea
    let textareaClicked = document.getElementById('resizableTextarea');
    // console.log("textareaClicked= ", textareaClicked);
    if (textareaClicked) {
      textareaClicked.addEventListener('input', this.autoResizeTextarea(textareaClicked));
    }


     inputField.focus();
   };

    // Function to auto-resize the textarea
    autoResizeTextarea(el) {
      //const textarea = document.getElementById('resizableTextarea');
      if (el){
        el.style.height = 'auto'; // Reset the height to auto to allow it to shrink
        el.style.height = (el.scrollHeight) + 'px'; // Set the height to the scrollHeight
      // console.log("el.scrollHeight =", el.scrollHeight);
      }
    }


  createInputFieldNewTask(value){
    // let inputField = document.createElement("input");
    let inputField = document.createElement("textarea");
    inputField.id = "resizableTaskTextarea";

    // inputField.setAttribute("data-list-target", "name");

    inputField.value = value;
    // inputField.style.position="absolute";
    inputField.style.height = 'auto'; 
    // inputField.style.wordBreak= "break-all";
    // inputField.style.resize="both";
    // inputField.type="text";
    // inputField.style.width="100%";

    inputField.style.overflow="hidden";

    inputField.style.boxSizing = "border-box";
    inputField.classList.add('textarea_style');

    
      inputField.addEventListener("blur", this.submitNewTask.bind(this));
    // inputField.addEventListener("keyup", (event) => {
    //   if (event.key === "Enter") {event.target.blur(); }
    // });

    inputField.addEventListener("input", () => {
      this.autoResizeTextarea(inputField);
    });

      let divField = document.createElement("div");

    //Add click event listener to close the field when clicking outside the textarea
    document.addEventListener("click", (event)=> {
      // this.submitNewTask.bind(this);
        console.log("event.target=", event.target);
      //  if (inputField) inputField.remove();
      if (event.target.contains(divField)) {


          // let bluredField = document.getElementById("bluredField");
          // if (bluredField) bluredField.remove();
        }
      });

      //let container = document.createElement("div");

      //container.appendChild(inputField);
      // container.appendChild(divField);
      // inputField.appendChild(divField);
  
      //return container;
  
    return inputField;
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
    inputField.style.zIndex ="500000000";
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
       //console.log("event.target!!=", event.target);
      if (event.target.contains(divField)) {
          if (inputField) inputField.remove();
          let bluredField = document.getElementById("bluredField");
          if (bluredField) bluredField.remove();

          this.originalNameTarget.querySelector("a").style.visibility = "visible";
          this.originalNameTarget.style.borderStyle = "solid";
          this.originalNameTarget.style.backgroundColor="#ffffff";
        }
      });

    //inputField.append("<div class='blur-overlay'>ggg</div>");

    let container = document.createElement("div");

    container.appendChild(inputField);
    container.appendChild(divField);

    return container;
  }

  submitNewTask(event){
    let inputField = event.target;
    let { listId } = this.element.dataset;

    console.log("event.target1 = ", event.target );

    console.log("list_id=", listId );

    // console.log("this.element.dataset = ", this.element);

     console.log("event.target = ", event.target);
    let taskName = inputField.value;  
    
    
    // if (inputField) inputField.remove();

    
    fetch(`/lists/${listId}/tasks?name=${taskName}&list_id=${listId}`, {
      method: "POST", 
      headers: {
        "Content-Type": "application/json",
        Accept:  "application/json",
        "X-CSRF-Token": this.getMetaValue("csrf-token")
      },
      body: JSON.stringify({ name: taskName, list_id: listId }),
      credentials: "same-origin",
    })
      .then((response) => response.json())
      .then(({ status, name, task_id }) =>{
        if(status === "ok") {

          //this.originalNameTarget.querySelector("a").innerText = name;

          // let bluredField = document.getElementById("bluredField");
          // console.log("bluredField=", bluredField);

          console.log("inputField = ", inputField);

          if (inputField) inputField.remove();          

          // this.element.replaceChild(this.originalNameTarget, inputField);

          // let div1 = document.createElement("div");
          // let sp1 = document.createElement("a");          
          // let sp1_content = document.createTextNode("+ Add task");
          // div1.setAttribute("data-task-target", "addTName");          
          // sp1.appendChild(sp1_content);

          //<div data-sortable-update-url="/tasks/${task_id}/sort" id="sortable_task_${task_id}">
          //</div>    
          
          let htmlCode = `
            <div id="task_${task_id}" class="my-3">          
              <div data-controller='task' data-task-id='${task_id}' class='group hover:hover:bg-slate-100 group hover: rounded-lg' style='min-height:42px; width:242px; margin:0px; position: relative'>
                <div data-task-target='tname' class='p-2 border-2 border-gray-200 rounded-lg task_style'>
                  <a data-turbo-frame='modal' href='/tasks/${task_id}/edit'> ${taskName}</a>
                </div>
                <div id='icon_edit' data-action='click->task#handleTaskClick' class='cursor-pointer invisible group-hover:visible edit_task_hover'>
                  <i class='fa-solid fa-pen fa-xs' style='color: #000000;'></i>
                </div>
              </div>
            </div>      
          `;
            	
          console.log("htmlCode=", htmlCode);

          let newDiv = document.createElement("div");

          newDiv.setAttribute("data-sortable-update-url", `/tasks/${task_id}/sort`); 
          newDiv.id = `sortable_task_${task_id}`;

          newDiv.innerHTML = htmlCode;
          let id =`tasks_add_new_${listId}`;
          
          let elToAdd =  document.getElementById(id);
          
          elToAdd.append(newDiv);



          // get( `${sortableUpdateUrl}?row_order_position=${event.newDraggableIndex}`,{
          //   body: JSON.stringify({
          //     list_id: sortableListId,
          //     row_order_position: event.newDraggableIndex      
          //   }),
          //   responseKind: "turbo-stream",
          //   contentType: "application/json"
          //   //responseKind: "html"
          // });


          // console.log("div1=", div1);

          // div1.append(sp1);

          // this.originalNameTarget.append(div1);

          // <a href="">+ Add task</a>
        } else {
          if (inputField) inputField.remove();  
          
          // Handle error ...
        };
    })
       .catch((error) => {
      //Handle catch errors
       console.error("Error:", error);
    });  
  }

  submit(event){
    let inputField = event.target;
    let { taskId } = this.element.dataset;
    // console.log("this.element.dataset = ", this.element);

    // console.log("taskId = ", taskId);
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

          this.originalNameTarget.querySelector("a").style.visibility = "visible";
          this.originalNameTarget.style.borderStyle = "solid";
          this.originalNameTarget.style.backgroundColor="#ffffff";

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
    // console.log("selected board!");

    let selected_board = event.target.selectedOptions[0].value;
    let target = this.listsSelectTarget.id;
    let tasksTarget = this.tasksSelectTarget.id;

    // let targetList = this.listsSelectTarget.id;

    // console.log("target = ", target);
    // console.log("tasksTarget = ", tasksTarget);

    // console.log("selected_board = ", selected_board);

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
    // console.log("selected list!");

    let selected_list = event.target.selectedOptions[0].value;
    let target = this.tasksSelectTarget.id;
    // console.log("target = ", target);

    // console.log("selected_list = ", selected_list);

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
