import { ValidationProvider } from 'vee-validate'

export default {
  inheritAttrs: false,
  components: {
    ValidationProvider
  },
  props: {
    api: {
      type: String,
      required: true
    },
    name: {
      type: String,
      default: ''
    },
    label: {
      type: String,
      default: ''
    },
    rules: {
      type: [Object, String],
      default: ''
    },
    value: {
      type: null,
      default: ''
    }
  },
  data: () => ({
    innerValue: ''
  }),
  computed: {
    listeners () {
      const { input, ...listeners } = this.$listeners
      return listeners
    }
  },
  watch: {
    innerValue (value) {
      this.$emit('input', value)
    },
    value (val) {
      if (val !== this.innerValue) {
        this.innerValue = val
      }
    }
  },
  created () {
    if (this.value) {
      this.innerValue = this.value
    }
  }
}
