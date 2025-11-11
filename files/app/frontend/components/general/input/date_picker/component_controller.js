import InputController from "components/general/input/component_controller"

import flatpickr from "flatpickr";
import { Japanese } from "flatpickr/dist/l10n/ja.js"

export default class extends InputController {
  static get values() {
    return {
      dateFormat: String,
      altFormat: String
    }
  }

  connect() {
    this._setCalendar();
  }

  disconnect() {
    this.calendar.destroy();
  }

  setDate(date) {
    this.calendar?.setDate(date);
  }

  reload() {
    this.calendar?.destroy();
    this._setCalendar();
  }

  _setCalendar() {
    this.calendar = flatpickr(this.inputTarget, {
      altInput: true,
      dateFormat: this.dateFormatValue,
      altFormat: this.altFormatValue,
      locale: Japanese,
    });
  }
}
