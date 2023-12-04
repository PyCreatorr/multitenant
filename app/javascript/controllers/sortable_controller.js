import { Controller } from "@hotwired/stimulus"

import Sortable from 'sortablejs';

import { get, post, put, patch, destroy } from '@rails/request.js';

// Connects to data-controller="sortable"
export default class extends Controller {

  static values = {
    group: String
  }
  connect() {
    var sortable = new Sortable(this.element, {

      onEnd: this.onEnd.bind(this),
      //group: 'shared',
      group: this.groupValue,
    });
    
  }

  onEnd(event){
    console.log("event.to=", event.to);
    console.log("event.to.dataset.sortableListId=", event.to.dataset.sortableListId);
    //console.log("event=", event.item);
    //console.log("this.element.textContent", this.element.textContent);
    // console.log(event.item.dataset.sortableId);


    var sortableListId = event.to.dataset.sortableListId;
    
    var sortableUpdateUrl = event.item.dataset.sortableUpdateUrl;
    console.log("sortableUpdateUrl = ",sortableUpdateUrl);
    

    console.log("row_oder_position =", event.newDraggableIndex);


    put( `${sortableUpdateUrl}?row_oder_position=${event.newDraggableIndex}`,{
      body: JSON.stringify({
        list_id: sortableListId,
        row_oder_position: event.newDraggableIndex      
      }),
      responseKind: "turbo-stream",
      contentType: "application/json"
      //responseKind: "html"
    });

    // put(`/lists/${event.item.dataset.sortableId}/sort?id=${event.item.dataset.sortableId}&row_oder_position=${event.newIndex}`,{
    //   body: JSON.stringify({row_oder_position: event.newIndex}), // set new index to the updated list
    //   responseKind: "turbo-stream",
    //   contentType: "application/json"
    //   //responseKind: "html"
    // });
  }
}
