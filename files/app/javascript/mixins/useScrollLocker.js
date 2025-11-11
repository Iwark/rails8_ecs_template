export const useScrollLocker = (controller) => {
  Object.assign(controller, {
    // Lock the scroll and save current scroll position
    lockScroll() {
      // Add right padding to the body so the page doesn't shift
      // when we disable scrolling
      const scrollbarWidth =
        window.innerWidth - document.documentElement.clientWidth
      document.body.style.paddingRight = `${scrollbarWidth}px`

      // Save the scroll position
      this._saveScrollPosition()

      // Add classes to body to fix its position
      document.body.classList.add('fixed', 'inset-x-0', 'overflow-hidden')

      // Add negative top position in order for body to stay in place
      document.body.style.top = `-${this.scrollPosition}px`
    },

    // Unlock the scroll and restore previous scroll position
    unlockScroll() {
      // Remove tweaks for scrollbar
      document.body.style.paddingRight = null

      // Remove classes from body to unfix position
      document.body.classList.remove('fixed', 'inset-x-0', 'overflow-hidden')

      // Restore the scroll position of the body before it got locked
      this._restoreScrollPosition()

      // Remove the negative top inline style from body
      document.body.style.top = null
    },

    _saveScrollPosition() {
      this.scrollPosition = window.pageYOffset || document.body.scrollTop
    },

    _restoreScrollPosition() {
      document.documentElement.scrollTop = this.scrollPosition
    }
  })
}
