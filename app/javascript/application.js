// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";

// FontAwesome added using importmaps based on this post: https://stackoverflow.com/questions/71430573/can-font-awesome-be-used-with-importmaps-in-rails-7
// This is because I don't want to use SASS in this project, and using both SASS and TailwindCSS caused issues that made using the FontAwesome SASS rails gem difficult.
// I will revisit this issue at a later time, as I don't want to have so many FontAwesome JS packages on the server.
import { far } from "@fortawesome/free-regular-svg-icons";
import { fas } from "@fortawesome/free-solid-svg-icons";
import { fab } from "@fortawesome/free-brands-svg-icons";
import { library } from "@fortawesome/fontawesome-svg-core";
import "@fortawesome/fontawesome-free";
library.add(far, fas, fab);
