import { Controller } from "@hotwired/stimulus"

import Sortable from 'sortablejs';

import { get, post, put, patch, destroy } from '@rails/request.js';

// Connects to data-controller="sidebar-board"
export default class extends Controller {

  static targets = [ "sidebar" ];

  connect() {
    //console.log("hello from sidebar");
    const icon_sidebar = document.getElementById("sidebar_buttom_slide");

    const sidebar_mobile_name = document.getElementById("sidebar_mobile_name");
    const sidebar_mobile_new_list = document.getElementById("sidebar_mobile_new_list");
    //console.log("sidebar_mobile_name=", sidebar_mobile_name);

    // sidebar_mobile_name.style = "visibility: visible;";
    //sidebar_mobile_new_list.style = "visibility: visible;";

    //let s_m_name = sidebar_mobile_name.innerHTML;
    //let s_m_new_list = sidebar_mobile_new_list.innerHTML;
     
    //console.log("textContent=", sidebar_mobile_name.textContent.substr(0,1));

    if (icon_sidebar.classList.contains('fa-angle-left')) {

      if (screen.width <= 1024 ) {

        // if(board_title.length > 1) board_title = sidebar_mobile_name.textContent.substr(0,1);
        // sidebar_mobile_name.innerHTML = board_title;
        //sidebar_mobile_name.style = "visibility: hidden; height:20px; width:0; padding:0; margin:0; overflow: hidden";
        //sidebar_mobile_name.innerHTML = sidebar_mobile_name.innerHTML.substr(0,1);
        sidebar_mobile_name.style = "overflow: hidden; white-space: nowrap; text-overflow: ellipsis;";
        sidebar_mobile_new_list.style = "visibility: hidden;  height:20px; width:0; padding:0; margin:0; overflow: hidden";
        //sidebar_mobile_name.innerHTML="";
        //sidebar_mobile_new_list.innerHTML="";
      }
    };

    if (icon_sidebar.classList.contains('fa-angle-right')) {

      if (screen.width <= 1024 ) {
        sidebar_mobile_name.style = "visibility: visible; white-space: normal; text-overflow: ellipsis;";
        sidebar_mobile_new_list.style = "visibility: visible;";

        //sidebar_mobile_name.innerHTML = board_title_;

        //sidebar_mobile_new_list.innerHTML= s_m_name;
        //sidebar_mobile_new_list.innerHTML = s_m_new_list;
      }
    }


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
    const sidebar_mobile_name = document.getElementById("sidebar_mobile_name");
    const sidebar_mobile_new_list = document.getElementById("sidebar_mobile_new_list");

    //console.log("sidebar_mobile_name=", sidebar_mobile_name);
    //icon_sidebar.classList.remove('class');
    if (icon_sidebar.classList.contains('fa-angle-right')) {
      icon_sidebar.classList.remove('fa-angle-right');
      icon_sidebar.classList.add('fa-angle-left');
      //s_position = "closed";
    } else {
      icon_sidebar.classList.add('fa-angle-right');
      //s_position = "opened";
    }

    console.log("screen.width =", screen.width);

    if (icon_sidebar.classList.length === 3) {
      s_position = "closed";
      // console.log("fa-angle-right", s_position);
      
      //sidebar_info.style.visibility = "hidden";
      sidebar_info.style="overflow: hidden; opacity: 0; transition: visibility 0ms linear 100ms, opacity 100ms;";
      //sidebar_info.innerHTML="";
      //sidebar_info.classList.add('hide');
      if (screen.width <= 1024 ) {
        //sidebar_mobile_name.style = "visibility: visible;";
        sidebar_mobile_name.style = "visibility: visible; white-space: normal; ";
        sidebar_mobile_new_list.style = "visibility: visible;";

        //sidebar_mobile_new_list.innerHTML= s_m_name;
        //sidebar_mobile_new_list.innerHTML = s_m_new_list;
      };
    }

    if (icon_sidebar.classList.length === 2) {
      s_position = "opened";
      console.log("fa-angle-left", s_position);
      //sidebar_info.style.visibility = "visible";
      sidebar_info.style="overflow-y: auto; opacity: 1; transition: visibility 100ms linear 500ms, opacity 500ms;";

      if (screen.width <= 1024 ) {
        sidebar_mobile_name.style = "overflow: hidden; white-space: nowrap; text-overflow: ellipsis;";
        sidebar_mobile_new_list.style = "visibility: hidden;  height:20px; width:0; padding:0; margin:0; overflow: hidden";

        //sidebar_mobile_name.innerHTML="";
        //sidebar_mobile_new_list.innerHTML="";
      }
    }
    
    //button_sidebar.sidebar.textContent='<i class="fa-solid fa-angle-left" style="color: #111d32;"></i>';
    //console.log("button_sidebar=", icon_sidebar.classList);

    // console.log(this.sidebarTarget);
    this.sidebarTarget.classList.toggle("slide_sidebar");

   // put request to save the preference sidebar_position 
    put( `/boards/users/sidebar_position?sidebar_position=${s_position}`,{
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
