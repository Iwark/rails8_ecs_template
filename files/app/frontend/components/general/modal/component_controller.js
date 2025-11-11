import { Controller } from "@hotwired/stimulus"
import { useScrollLocker } from "mixins/useScrollLocker"
import { useEscClose } from "mixins/useEscClose"

export default class extends Controller {

  static get values() {
    return {
      closeOnEsc: { type: Boolean, default: true }
    }
  }

  connect() {
    this.element.controller = this

    useScrollLocker(this)
    this.lockScroll()

    if (this.closeOnEscValue) {
      useEscClose(this)
      this.setCloseOnEsc(this.element)
    }
  }

  disconnect() {
    this.unlockScroll()
    if (this.closeOnEscValue) {
      this.unsetCloseOnEsc(this.element)
    }
  }

  close(e) {
    if (e) {
      e.preventDefault()
      if (e.type === 'turbo:submit-end' && !e.detail.success) {
        return
      }
    }

    this.element.removeAttribute("src")
    this.element.remove()
    // this.element.dispatchEvent(new CustomEvent('modalClose', { bubbles: true }))
  }
}
