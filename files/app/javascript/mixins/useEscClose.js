export const useEscClose = (controller) => {
  Object.assign(controller, {
    setCloseOnEsc(closeEl) {
      const modalClosePriority = document.querySelectorAll('[data-modal-close-priority]').length
      closeEl.dataset.modalClosePriority = modalClosePriority

      if (modalClosePriority === 0) {
        document.addEventListener("keyup", this._closeTopModalOnEscKeypress)
      }
    },

    unsetCloseOnEsc(closeEl) {
      if (closeEl.dataset.modalClosePriority === '0') {
        document.removeEventListener("keyup", this._closeTopModalOnEscKeypress)
      }

      delete closeEl.dataset.modalClosePriority
    },

    _closeTopModalOnEscKeypress: (e) => {
      if (e.key !== 'Escape') {
        return
      }

      const modalCloseEls = document.querySelectorAll('[data-modal-close-priority]')
      const modalToCloseEl = Array.from(modalCloseEls).reduce((prev, cur) => {
        return parseInt(cur.dataset.modalClosePriority) > parseInt(prev.dataset.modalClosePriority) ? cur : prev
      })
      const modalController = controller.application.getControllerForElementAndIdentifier(modalToCloseEl, controller.identifier)
      modalController.close()
    }
  })
}
