import InputController from "components/general/input/component_controller"

export default class extends InputController {
  static get targets() {
    return [...super.targets, 'dummy', 'counter']
  }
  static get values() {
    return {
      ...super.values,
      maxLength: Number,
      staticHeight: Boolean
    }
  }

  connect() {
    super.connect();
    this._initCounter();
    this._updateDummyContent();
    if (!this.staticHeightValue) {
      this._initResizeObserver();
    }
  }

  disconnect() {
    super.disconnect();
    if (this._resizeObserver) {
      this._resizeObserver.disconnect();
    }
  }

  update() {
    this._updateCounter();
    this._updateDummyContent();
    if (this.inputTarget.value) {
      this.validateLater();
    }
  }

  _initCounter() {
    if (this.maxLengthValue === 0) return;

    this.counterTarget.classList.add('active');
    this._updateCounter();
  }

  _updateCounter() {
    const text = `${this.inputTarget.value.length}/${this.maxLengthValue}`;
    this.counterTarget.textContent = text;
  }

  _updateDummyContent() {
    this.dummyTarget.textContent = this.inputTarget.value + '\u200b';
  }

  _initResizeObserver() {
    const computedStyle = window.getComputedStyle(this.dummyTarget);
    const minHeightPx = parseInt(computedStyle.minHeight, 10);

    this._resizeObserver = new ResizeObserver(() => {
      const contentHeight = this.dummyTarget.scrollHeight;
      const minHeight = minHeightPx > 0 ? Math.max(minHeightPx, contentHeight) : contentHeight;

      if (this.inputTarget.style.height !== `${minHeight}px`) {
        this.inputTarget.style.height = `${minHeight}px`;
      }
    });

    this._resizeObserver.observe(this.dummyTarget);
  }
}
