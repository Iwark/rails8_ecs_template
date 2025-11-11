import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const frame = this.element.closest("turbo-frame")
    const src = frame?.getAttribute('src')
    const dataSrc = frame?.getAttribute('data-src')
    if (src && (!dataSrc || src === dataSrc)) {
      frame.reload()
    } else if (dataSrc) {
      frame.setAttribute('src', frame.getAttribute('data-src'))
    }
    this.element.remove()
  }
}