import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["toggleable", "activatable", "rotatable"];

  toggle() {
    this.toggleableTarget.classList.toggle("hidden");
    if (this.rotatableTarget)
      this.rotatableTarget.classList.toggle("rotate-90");
  }

  toggleAccordion() {
    this.rotateCaret();
    this.hideExercises();
    this.toggleableTarget.classList.toggle("hidden");
    this.toggleActive();
  }

  removeActiveWorkout() {
    document
      .querySelectorAll(".active-workout")
      .forEach((target) => target.classList.remove("active-workout"));
  }

  toggleActive() {
    this.removeActiveWorkout();

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

  hideExercises() {
    document
      .querySelectorAll(".exercises")
      .forEach((target) => target.classList.add("hidden"));
  }

  disconnect() {
    this.hideExercises();
    this.removeActiveWorkout();
  }
}
