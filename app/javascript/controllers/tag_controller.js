import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="tag"
export default class extends Controller {
  static targets = ["taglist"];

  toggleTag(e) {
    const tag = e.target.innerText;
    e.currentTarget.classList.toggle("bg-green-600");

    if (this.tagList.includes(tag)) {
      const existingTagIdx = this.tagList.indexOf(tag);
      this.tagList.splice(existingTagIdx, 1);
    } else {
      this.tagList.push(tag);
    }
    this.taglistTarget.value = this.tagList.join(",");
  }

  connect() {
    this.tagList = [];
  }
}
