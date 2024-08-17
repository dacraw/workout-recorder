import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["toggleable", "activatable", "rotatable"];

  toggle() {
    this.toggleableTarget.classList.toggle("hidden");
  }

  toggleAccordion() {
    this.rotateCaret();
    this.hideExercises();
    this.toggleableTarget.classList.toggle("hidden");
    this.toggleActive();
  }

  toggleActive() {
    document
      .querySelectorAll(".active-workout")
      .forEach((target) => target.classList.remove("active-workout"));

    this.activatableTargets.forEach((target) => {
      target.classList.toggle("active-workout");
    });
  }

  rotateCaret() {
    document
      .querySelectorAll(".rotate-90")
      .forEach((target) => target.classList.remove("rotate-90"));
    this.rotatableTarget.classList.toggle("rotate-90");
  }

  hideExercises(e) {
    document
      .querySelectorAll(".exercises")
      .forEach((target) => target.classList.add("hidden"));
  }
}
