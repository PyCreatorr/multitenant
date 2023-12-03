import { Controller } from "@hotwired/stimulus"

import Sortable from 'sortablejs';

// Connects to data-controller="sortable"
export default class extends Controller {
  connect() {
    var sortable = new Sortable(this.element, {});
    
  }
}
