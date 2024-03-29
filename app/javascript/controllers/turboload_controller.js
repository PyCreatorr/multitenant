import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="turboload"
export default class extends Controller {

  connect() {

    let div2Scroll = document.getElementById('lists');

    if (div2Scroll.complete) {
      this.handleDOMContentLoaded();
    } else {
      // If the image is not yet loaded, wait for the 'load' event
      div2Scroll.addEventListener('load', this.handleDOMContentLoaded());
    }

    //console.log("turboload_connected!");  
  }

  handleDOMContentLoaded = () => {
    // Code to be executed when DOMContentLoaded event fires
    console.log('DOMContentLoaded event fired!!');

    let div2Scroll = document.getElementById('lists');
    const icon_sidebar = document.getElementById("sidebar_buttom_slide");
    //console.log("icon_sidebar=", icon_sidebar)

    //let { scrollLeft } = this.element.dataset;
    //let scroll2Position = div2Scroll.dataset.scrolling;
    // dataset.list-updated
    let l = div2Scroll.dataset.listUpdated;
    if (!l) {
      let url = window.location.href;
      console.log("url=",url);
      let se = url.replace(/^.+sortable_list=/,'');
      console.log("se = ", se);
      if (!se.includes('http')) l = se;
      else l = 0;      
    }

    let sl = `sortable_list_${l}`;
    console.log('l =', `sortable_list_${l}`);

   let el =  document.getElementById(sl);
   console.log("screen.width=", screen.width);

   
   if (el) {
     
     let rect = el.getBoundingClientRect();
     console.log("rect.left=", rect.left);

     console.log('div2Scroll.scrollLeft1 =', div2Scroll.scrollLeft);
      

      if (icon_sidebar.classList.contains('fa-angle-left')) {

        if (screen.width < 1024 ) div2Scroll.scrollLeft = div2Scroll.scrollLeft + rect.left-40 - 300; 
        if (screen.width >= 1024 ) div2Scroll.scrollLeft = rect.left -24 -300; 
        
      }

      if (icon_sidebar.classList.contains('fa-angle-right')) {

        if (screen.width < 1024 ) div2Scroll.scrollLeft = rect.left-40 ; 
        if (screen.width >= 1024 ) div2Scroll.scrollLeft = rect.left -24 ; 
        
      }
      
      console.log('div2Scroll.scrollLeft2 =', div2Scroll.scrollLeft);

    }

  }

  onload() {
    // Your code to be executed after the page has fully loaded
    console.log('Page has finished loading!');
    let div2Scroll = document.getElementById('lists');
    //let { scrollLeft } = this.element.dataset;
    let scroll2Position = div2Scroll.dataset.scrolling;
    console.log('scroll2Position =', scroll2Position);

    div2Scroll.scrollLeft = scroll2Position;
   
  };
}
