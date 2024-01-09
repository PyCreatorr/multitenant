// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@rails/request.js"

import "@fortawesome/fontawesome-free"

// import 'flowbite'
import "trix"
import "@rails/actiontext"

import {Turbo} from  "@hotwired/turbo-rails"

// turbo_stream.action(:redirect, board_url(@board))

Turbo.StreamActions.redirect = function(){
    Turbo.visit(this.target);
}


// turbo_stream.advanced_redirect(board_url(@board))
Turbo.StreamActions.advanced_redirect = function(){
    let url = this.getAttribute('url');
    console.log("url=", url);
    Turbo.visit(url);
}

