<template lang="html">
  <SmoothReflow>
    <div v-if="success && ($slots.success || $scopedSlots.success)">
      <slot name="success" :response="response"/>
    </div>
    <Loader v-else :loading="$wait.is(waitFor)">
      <ValidationObserver ref="form" tag="form" @submit.prevent="$submit">
        <slot :form-errors="formErrors" :inputs-errors="inputErrors"/>
      </ValidationObserver>
    </Loader>
  </SmoothReflow>
</template>

<script>
import { flatten, unflatten } from 'flat'
import Loader from './Loader'

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
      response: null,
      inputs: [],
      serviceMethod: null,
      formErrors: null,
      inputErrors: null
    }
  },
  created () {
    // Search for service
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
    async $getData () {
      await this.$nextTick()

      // Get JSON form data and native formData
      const inputs = [...this.$refs.form.$el.querySelectorAll('input, textarea, select')]
      let data = {}
      const formData = new FormData()

      const isApiInput = input => input.name
      const isNotFileInput = input => input.type !== 'file'
      const apiInputs = inputs.filter(isApiInput).filter(isNotFileInput)

      apiInputs.forEach(input => {
        let inputValue = null

        if (input.type === 'checkbox') {
          inputValue = input.checked
        } else if (input.type === 'radio') {
          const checkedValue = apiInputs.find(i => i.name === input.name && i.checked)
          inputValue = checkedValue && checkedValue.value
        } else {
          inputValue = input.value
        }

        // Add data to JSON
        data[input.name] = inputValue

        // Add data to formData
        formData.append(input.name, inputValue)
      })

      // Unflatten data structure ({ 'nested.key': 'test' } -> { nested: { key: 'test' } })
      // Allows using api="nested.key" format in inputs
      data = unflatten(data)

      // Now add files:
      const fileInputs = []

      // Recurrent searching for files
      function searchFileInputs (component) {
        if (
          component._name === '<FileInputAdapter>' ||
          component._name === '<FileComponent>' ||
          component.$options.name === 'FileInputAdapter'
        ) {
          fileInputs.push({
            apiName: component.api,
            value: component.files.map(file => file.id) || component.value,
            files: component.files
          })

          // Dont search FileInputs in FileInput component
          return
        }

        component.$children.forEach(searchFileInputs)
      }
      searchFileInputs(this)

      // Add files to data
      fileInputs.forEach(fileInput => {
        // Add files to formData
        fileInput.files.forEach(file => {
          formData.append(fileInput.apiName, file)
        })

        // Add files to JSON
        data[fileInput.apiName] = fileInput.value || fileInput.files
      })

      // Create axios config
      const isAnyFileInput = this.$refs.form.$el.querySelector('input[type=file]')
      const axiosConfig = isAnyFileInput
        ? { headers: { 'Content-Type': 'multipart/form-data' } }
        : {}

      // Create arguments for callback
      return { data, formData, axiosConfig }
    },
    async $submit () {
      // Check is form valid and there is no pending submit
      const isFormValid = await this.$refs.form.validate()
      const isLoaderActive = this.$wait.is(this.waitFor)

      if (!isFormValid) {
        this.$emit('validation-error')
        return
      }

      if (isLoaderActive) {
        // TODO ???
        // this.$emit('in-progress ???')
        return
      }

      const data = await this.$getData()
      const responsePromise = this.serviceMethod
        ? this.serviceMethod(data)
        : this.submit(data)

      const isResponseAPromise = responsePromise instanceof Promise

      // If there is a "submit" function from component
      // and this function doesnt return a promise
      // - all work here is done
      if (!isResponseAPromise && !this.serviceMethod) {
        this.$emit('success', {})
        return
      }

      // Throw error if service method doesnt return a Promise
      if (this.serviceMethod && !isResponseAPromise) {
        throw new Error('FormBuilder: The service method must return a promise!')
      }

      this.$wait.start(this.waitFor)

      try {
        // Get response from promise
        const response = await responsePromise

        // If there is no errors - all work here is done
        this.success = true
        this.response = response
        this.$wait.end(this.waitFor)
        this.$emit('success', response)
      } catch (error) {
        this.$wait.end(this.waitFor)

        // If this is a HTTP error
        if (error.response && error.response.data) {
          // Set errors from backend
          // Flatten errors ({ nested: { key: ['error'] } } -> { 'nested.key': ['error'] })
          // Allows showing nested errors for inputs with api="nested.key"
          const flatErrors = flatten(error.response.data, { safe: true })
          this.$refs.form.setErrors(flatErrors)
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
