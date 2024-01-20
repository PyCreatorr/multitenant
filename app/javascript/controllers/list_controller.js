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
    console.log("ClickedList");
    event.preventDefault();  

    console.log(" event.target.contains = ", event.target );
    // event.target.contains("resizableListTextarea")
    
      //  console.log("this.nameTarget = ",this.originalNameTarget);  
      // if (resizableListTextarea)     

      let createdInputElement = document.getElementById("resizableListTextarea");

      console.log("createdInputElement = ", createdInputElement);
      if (!createdInputElement){


        this.originalNameTarget = this.nameTarget;

        let listName = this.originalNameTarget.querySelector("a").innerText;

        console.log("listName = ", listName);

        let inputField = this.createInputField(listName);

        console.log("inputField created = ",inputField);
        //  console.log("this.element.replaceChild = ", this.element);


        this.element.replaceChild(inputField, this.nameTarget);
        // this.element.append(inputField, this.nameTarget);

        // Attach the autoResizeListTextarea function to the input event of the textarea
        let textareaClicked = document.getElementById('resizableListTextarea');
        console.log("ListTextareaClicked= ", textareaClicked);
        if (textareaClicked) {
          textareaClicked.addEventListener('input', this.autoResizeListTextarea(textareaClicked));
        }

        inputField.focus();

      }
   
   }


    // Function to auto-resize the textarea
    autoResizeListTextarea(el) {
      //const textarea = document.getElementById('resizableListTextarea');
      if (el){
        el.style.height = 'auto'; // Reset the height to auto to allow it to shrink
        el.style.height = (el.scrollHeight) + 'px'; // Set the height to the scrollHeight
      console.log("el.scrollHeight =", el.scrollHeight);
      }
    }


   createInputField(value){
    // let inputField = document.createElement("input");
    let inputField = document.createElement("textarea");
    inputField.id = "resizableListTextarea";

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

    
     inputField.addEventListener("blur", this.submit.bind(this));
    // inputField.addEventListener("keyup", (event) => {
    //   if (event.key === "Enter") {event.target.blur(); }
    // });

    inputField.addEventListener("input", () => {
      this.autoResizeListTextarea(inputField);
    });

     let divField = document.createElement("div");

    //Add click event listener to close the field when clicking outside the textarea
    document.addEventListener("click", (event)=> {
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
      inputField.appendChild(divField);
  
      //return container;
  
    return inputField;
  }

  submit(event){
    let inputField = event.target;
    let { listId } = this.element.dataset;
    console.log("listId = ", listId);
    let listName = inputField.value;

    // if (listName != ""){    
      fetch(`/lists/${listId}/update_name`, {
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
            
             //if (inputField) inputField.remove();
          
          } else {
            
            // Handle error ...

        // console.error("Error:", status);
        //console.error("Name:", name);
        inputField.value = "error";
        // this.originalNameTarget.querySelector("a").innerText = name;
         this.element.replaceChild(this.originalNameTarget, inputField);

         if (inputField) inputField.remove();
        };
      })
        .catch(({ error, name1 }) => {
        //Handle catch errors
        console.error("Error:", error);
        console.error("Name:", name1);
        inputField.value = "error";
        // this.originalNameTarget.querySelector("a").innerText = name1;
        this.element.replaceChild(this.originalNameTarget, inputField);
        // if (inputField) inputField.remove();
        // , name: last_list.name }
      }); 
    } 
    
 
  
  // <meta name="csrf-token" content="W3sp3zCCIcb8Uzgndi8l1PG1qoj0QqC64ezlYhhdkMviZ_LZZ-rkNUyKk7pSn3sc6DoKRkfg4zjgQNbA1AIciA">
   getMetaValue(name){
    const element = document.head.querySelector(`meta[name="${name}"]`);
    return element.getAttribute("content");
  }
}
