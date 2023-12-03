import { Controller } from "@hotwired/stimulus"

import Sortable from 'sortablejs';

import { get, post, put, patch, destroy } from '@rails/request.js';

// Connects to data-controller="sortable"
export default class extends Controller {
  connect() {
    var sortable = new Sortable(this.element, {

      onEnd: this.onEnd.bind(this)
    });
    
  }

  onEnd(event){
    // console.log(event.newIndex);
    console.log(event.item.dataset.sortableId);
    console.log("row_oder_position =", event.newIndex);

    put(`/lists/${event.item.dataset.sortableId}/sort?id=${event.item.dataset.sortableId}&row_oder_position=${event.newIndex}`,{
      body: JSON.stringify({row_oder_position: event.newIndex}), // set new index to the updated list
      responseKind: "turbo-stream",
      contentType: "application/json"
      //responseKind: "html"
    });
  }
}
