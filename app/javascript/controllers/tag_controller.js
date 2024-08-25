import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="tag"
export default class extends Controller {
  static targets = ["taglist"];
  tagList = [];

  toggleTag(e) {
    console.log(this.taggableTarget);
    const tag = e.target.innerText;
    e.currentTarget.classList.toggle("bg-green-600");

    console.log(e.currentTarget);
    this.tagList.push(tag);
    this.taglistTarget.value = this.tagList.join(";");
  }

  connect() {}
}
