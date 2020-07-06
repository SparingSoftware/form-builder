<template>
  <ValidationProvider
    v-slot="{ errors, required, ariaInput, ariaMsg }"
    tag="label"
    :rules="rules"
    :name="name || label"
    :vid="api"
    class="wrapper"
  >
    <!-- Label -->
    <div class="label">
      {{ label || name }}
      {{ required ? '*' : '' }}
    </div>
    <!-- e/o Label -->

    <input
      v-model="innerValue"
      v-bind="{ ...$attrs, ...ariaInput }"
      class="input"
      :name="api"
      :type="type"
      v-on="listeners"
    >

    <!-- Errors -->
    <SmoothReflow :options="{ transition: 'height 0.2s' }">
      <div v-if="errors.length > 0" v-bind="ariaMsg" class="error">
        {{ errors[0] }}
      </div>
    </SmoothReflow>
    <!-- e/o Errors -->
  </ValidationProvider>
</template>

<script>
import adapterMixin from './adapter.mixin'

export default {
  mixins: [adapterMixin],
  props: {
    type: {
      type: String,
      default: 'text',
      validator (value) {
        return [
          'url',
          'text',
          'password',
          'tel',
          'search',
          'number',
          'email'
        ].includes(value)
      }
    }
  }
}
</script>

<style lang="scss" scoped>
  .wrapper {
    display: block;
  }

  .label {

  }

  .input {

  }

  .error {

  }
</style>
