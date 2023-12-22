import { Controller } from "@hotwired/stimulus"

import Sortable from 'sortablejs';

import { get, post, put, patch, destroy } from '@rails/request.js';

// Connects to data-controller="sidebar-board"
export default class extends Controller {

  static targets = [ "sidebar" ];

  connect() {
    console.log("hello from sidebar");
  }

  onload() {
    // Your code to be executed after the page has fully loaded
    console.log('Page has finished loading!');
  };

  toggle(e){
    // Prevent default action -> refresh the page
    e.preventDefault();
    let s_position = "opened";
    
    const icon_sidebar = document.getElementById("sidebar_buttom_slide");
    const sidebar_info = document.getElementById("board_sidebar_information");
    //icon_sidebar.classList.remove('class');
    if (icon_sidebar.classList.contains('fa-angle-right')) {
      icon_sidebar.classList.remove('fa-angle-right');
      icon_sidebar.classList.add('fa-angle-left');
      //s_position = "closed";
    } else {
      icon_sidebar.classList.add('fa-angle-right');
      //s_position = "opened";
    }

    if (icon_sidebar.classList.length === 3) {
      s_position = "closed";
      console.log("fa-angle-right", s_position);
      
      //sidebar_info.style.visibility = "hidden";
      sidebar_info.style="opacity: 0; transition: visibility 0ms linear 100ms, opacity 100ms;";
      //sidebar_info.innerHTML="";
      //sidebar_info.classList.add('hide');
    }

    if (icon_sidebar.classList.length === 2) {
      s_position = "opened";
      console.log("fa-angle-left", s_position);
      //sidebar_info.style.visibility = "visible";
      sidebar_info.style="opacity: 1; transition: visibility 100ms linear 500ms, opacity 500ms;";
    }



    
    //button_sidebar.sidebar.textContent='<i class="fa-solid fa-angle-left" style="color: #111d32;"></i>';
    console.log("button_sidebar=", icon_sidebar.classList);

    console.log(this.sidebarTarget);
    this.sidebarTarget.classList.toggle("slide_sidebar");

   // put request to save the preference sidebar_position 
    put( `users/sidebar_position?sidebar_position=${s_position}`,{
      body: JSON.stringify({
        sidebar_position: s_position
        //list_id: sortableListId,
        //row_order_position: e.newDraggableIndex      
      }),
      responseKind: "turbo-stream",
      contentType: "application/json"
      //responseKind: "html"
    });

    //const modal = document.getElementById("modal");
    
    //modal.innerHTML="";

    //Remove the src attribute from the modal
    //modal.removeAttribute("src");

    //Remove attribute complete
    //modal.removeAttribute("complete");
  }

}
