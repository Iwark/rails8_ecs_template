import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static get targets() {
    return ['message', 'subMessage', 'detailList', 'detailListItemTemplate']
  }

  static get values() {
    return {
      timeout: { type: Number, default: 5000 },
      message: { type: String, default: '' },
      subMessage: { type: String, default: '' },
      detailList: { type: Array, default: [] }
    }
  }

  connect() {
    if (this.messageValue) {
      this.messageTarget.textContent = this.messageValue;
    } else if (this.hasMessageTarget) {
      this.messageTarget.remove();
    }
    if (this.subMessageValue) {
      this.subMessageTarget.textContent = this.subMessageValue;
    } else if (this.hasSubMessageTarget) {
      this.subMessageTarget.remove();
    }
    if (this.detailListValue.length > 0) {
      this.detailListTarget.innerHTML = this.detailListValue.map(item => {
        const html = this.detailListItemTemplateTarget.innerHTML;
        return html.replace('$key', item.key).replace('$value', item.value);
      }).join('');
    } else if (this.hasDetailListTarget) {
      this.detailListTarget.remove();
    }

    if (this.timeoutValue <= 0) {
      return;
    }

    setTimeout(() => {
      this.removeNotification();
    }, this.timeoutValue);
  }

  disconnect() {
    this.removeNotification();
  }

  removeNotification(e = null) {
    if (e) {
      e.preventDefault();
    }
    this.element.classList.remove('animate-fade-in-left');
    this.element.classList.add('animate-fade-out-left');
    setTimeout(() => {
      this.element.remove();
    }, 400);
  }
}
