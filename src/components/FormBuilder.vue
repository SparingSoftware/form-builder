<template lang="html">
  <SmoothReflow>
    <div v-if="success">
      <slot name="success"/>
    </div>
    <Loader v-else :loading="$wait.is(waitFor)">
      <ValidationObserver ref="form" tag="form" @submit.prevent="$submit">
        <slot
          :form-errors="formErrors"
          :inputs-errors="inputErrors"
        />
      </ValidationObserver>
    </Loader>
  </SmoothReflow>
</template>

<script>
import Loader from '@/components/Loader'

export default {
  components: {
    Loader
  },
  props: {
    waitFor: {
      type: String,
      default () {
        return `loader ${this._uid}`
      }
    },
    service: {
      type: String,
      default: null
    },
    submit: {
      type: Function,
      default: null
    }
  },
  data () {
    return {
      success: false,
      inputs: [],
      serviceMethod: null,
      formErrors: null,
      inputErrors: null
    }
  },
  created () {
    if (this.service !== null) {
      const servicePathParts = this.service.split('.')

      this.serviceMethod = this.$service

      try {
        servicePathParts.forEach(part => {
          this.serviceMethod = this.serviceMethod[part]
        })
      } catch (err) {
        throw new TypeError(`FormBuilder: service '${this.service}' does not exist!`)
      }
    }
  },
  methods: {
    async $submit () {
      const isFormValid = await this.$refs.form.validate()
      console.log('isFormValid', isFormValid)
      const isLoaderActive = this.$wait.is(this.waitFor)
      if (!isFormValid || isLoaderActive) return

      const inputs = this.$refs.form.$el.querySelectorAll('input, textarea, select')
      const formData = {}

      inputs.forEach(input => {
        formData[input.name] = input.type === 'checkbox'
          ? input.checked
          : input.value
      })

      const responsePromise = this.serviceMethod
        ? this.serviceMethod(formData)
        : this.submit(formData)

      if (!(responsePromise instanceof Promise)) {
        const method = this.serviceMethod ? 'service' : 'submit'
        throw new TypeError(`FormBuilder: The ${method} method must return a promise!`)
      }

      try {
        const response = await responsePromise
        this.success = true
        this.$wait.end(this.waitFor)
        this.$emit('success', response)
      } catch (error) {
        this.$wait.end(this.waitFor)
        if (error.response && error.response.data) {
          this.$refs.form.setErrors(error.response.data)
          this.formErrors = error.response.data.non_field_errors
          this.inputErrors = error.response.data
          this.$emit('error', error.response)
        } else {
          throw error
        }
      }
    }
  }
}
</script>
