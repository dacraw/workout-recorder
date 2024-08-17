import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["toggleable"];

  toggle() {
    this.toggleableTarget.classList.toggle("hidden");
  }

  toggleAccordion(e) {
    this.hideExercises();
    // Remove `active-workout` class from elements that were part of the previously selected workout
    const previouslyActive = document.querySelectorAll(".active-workout");
    previouslyActive.forEach((target) =>
      target.classList.remove("active-workout")
    );

    // Target the element containing the workout name as the base for toggling exercise list and `active-workout` class
    const workoutNameElement = e.target.closest("span");
    const workoutExercisesElement = workoutNameElement.nextElementSibling;

    workoutNameElement.classList.add("active-workout");
    workoutExercisesElement.classList.add("active-workout");
    workoutExercisesElement.classList.toggle("hidden");
  }

  hideExercises(e) {
    document
      .querySelectorAll(".exercises")
      .forEach((target) => target.classList.add("hidden"));
  }

  connect() {}
}
