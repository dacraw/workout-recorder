import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["toggleable"];

  toggle() {
    this.toggleableTarget.classList.toggle("hidden");
  }

  toggleAccordion(e) {
    const target = e.target.nextElementSibling;
    target.classList.toggle("hidden");
  }

  connect() {}
}
