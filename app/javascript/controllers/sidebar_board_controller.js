import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sidebar-board"
export default class extends Controller {

  static targets = [ "sidebar" ];

  connect() {
    console.log("hello from sidebar");
  }

  toggle(e){
    // Prevent default action -> refresh the page
    e.preventDefault();
    
    const icon_sidebar = document.getElementById("sidebar_buttom_slide");
    //icon_sidebar.classList.remove('class');
    if (icon_sidebar.classList.contains('fa-angle-right')) {
      icon_sidebar.classList.remove('fa-angle-right');
      icon_sidebar.classList.add('fa-angle-left');
    } else {
      icon_sidebar.classList.add('fa-angle-right');
    }
    
    //button_sidebar.sidebar.textContent='<i class="fa-solid fa-angle-left" style="color: #111d32;"></i>';
    console.log("button_sidebar=", icon_sidebar.classList);

    console.log(this.sidebarTarget);
    this.sidebarTarget.classList.toggle("slide_sidebar");

    


    //const modal = document.getElementById("modal");
    
    //modal.innerHTML="";

    //Remove the src attribute from the modal
    //modal.removeAttribute("src");

    //Remove attribute complete
    //modal.removeAttribute("complete");
  }

}
