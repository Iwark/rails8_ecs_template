import { Controller } from "@hotwired/stimulus"
// import validate from 'validator';

export default class extends Controller {
  static get targets() {
    return ['errorContainer', 'input']
  }
  static get values() {
    return {
      hasError: Boolean,
      validations: Array
    }
  }

  togglePasswordVisibility(e) {
    const input = e.currentTarget.parentElement.querySelector('input');
    if (input.type === 'password') {
      input.type = 'text';
    } else {
      input.type = 'password';
    }
    const hiddenIcon = e.currentTarget.querySelector('svg.hidden');
    e.currentTarget.querySelectorAll('svg').forEach((svg) => {
      svg.classList.add('hidden');
    });
    hiddenIcon.classList.remove('hidden');
  }

  connect() {
    // if (this.hasErrorValue) {
    //   this.#validate();
    // }
  }

  validateNow() {
    // this.#validate();
  }

  validateLater() {
    // this.#removeErrors();

    // clearTimeout(this.timeoutId);
    // this.timeoutId = setTimeout(() => this.#validate(), 200);
  }

  #validate() {
    if (!this.hasInputTarget) return;

    const results = validate(this.inputTarget.value, this.validationsValue, this);
    const errors = results.filter(e => e.level === 'error');
    const warnings = results.filter(e => e.level === 'warning');
    this.#removeErrors();
    if (errors.length > 0) {
      this.element.classList.add('error');
      errors.forEach((e) => this.#addErrorMessage(e.message));
    }
    if (warnings.length > 0) {
      this.element.classList.add('warning');
      warnings.forEach((e) => this.#addWarningMessage(e.message));
    }
  }

  #removeErrors() {
    this.errorContainerTarget.innerHTML = '';
    this.element.classList.remove('error', 'warning');
  }

  #addErrorMessage(message) {
    const error = document.createElement('small');
    error.classList.add('mt-1', 'text-left', 'text-semantic-danger');
    error.textContent = message;
    this.errorContainerTarget.appendChild(error);
  }

  #addWarningMessage(message) {
    const error = document.createElement('small');
    error.classList.add('mt-1', 'text-left', 'text-warning-400');
    error.textContent = message;
    this.errorContainerTarget.appendChild(error);
  }
}
