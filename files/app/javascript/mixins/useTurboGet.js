export const useTurboGet = (controller) => {
  Object.assign(controller, {

    appendTurboGetForm(url, turboFrame, turboStream = false) {
      this.turboGetForm = this._createTurboGetForm(url, turboFrame, turboStream);
      document.body.appendChild(this.turboGetForm);
    },

    removeTurboGetForm() {
      if (this.turboGetForm) {
        this.turboGetForm.remove();
        this.turboGetForm = null;
      }
    },

    updateTurboGetParams(params = new URLSearchParams()) {
      if (!this.turboGetForm) {
        return;
      }
      this.turboGetForm.innerHTML = '';
      for (const [key, value] of params.entries()) {
        const input = document.createElement("input");
        input.setAttribute('name', key);
        input.setAttribute('value', value);
        input.setAttribute('type', 'hidden');
        this.turboGetForm.appendChild(input);
      }
    },

    requestTurboGet() {
      this.turboGetForm?.requestSubmit();
    },

    _createTurboGetForm(url, turboFrame, turboStream) {
      const form = document.createElement("form");
      form.setAttribute('action', url);
      form.setAttribute('method', 'get');
      if (turboFrame) {
        form.setAttribute('data-turbo-frame', turboFrame);
      }
      if (turboStream) {
        form.setAttribute('data-turbo-stream', 'true');
      }
      form.setAttribute('data-turbo-action', 'advance');
      form.setAttribute('accept-charset', 'UTF-8');
      return form;
    }
  })
}
