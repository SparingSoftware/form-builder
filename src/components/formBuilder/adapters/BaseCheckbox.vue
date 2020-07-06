<template>
  <ValidationProvider
    v-slot="{ errors, required, ariaInput, ariaMsg, focus }"
    tag="label"
    :rules="{ required: { allowFalse: rules !== 'required' } }"
    :name="name || label"
    :vid="api"
    class="wrapper"
  >
    {{ focus }}
    <!-- Visually-hidden input -->
    <input
      v-model="innerValue"
      v-bind="{ ...$attrs, ...ariaInput }"
      class="input"
      :name="api"
      type="checkbox"
      v-on="listeners"
    >
    <!-- e/o Visually-hidden input -->

    <div class="flex">
      <!-- Fake input -->
      <div class="fake-input" :class="{ 'fake-input--checked': checked }"/>
      <!-- e/o Fake input -->

      <!-- Label -->
      <div class="label">
        <slot/>
      </div>
      <!-- e/o Label -->
    </div>

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
  data: () => ({
    innerValue: false
  }),
  computed: {
    checked () {
      return this.innerValue === true
    }
  }
}
</script>

<style lang="scss" scoped>
  .wrapper {
    display: block;
    cursor: pointer;
    margin-bottom: 1em;
    width: 10em;
  }

  .input {
    position: absolute !important;
    clip: rect(1px, 1px, 1px, 1px);
    padding: 0 !important;
    border: 0 !important;
    height: 1px !important;
    width: 1px !important;
    overflow: hidden;
  }

  .flex {
    display: flex;
    padding-bottom: 0.3em;
  }

  .label {
    width: calc(100% - 2em)
  }

  .fake-input {
    width: 1em;
    margin-right: 1em;
    height: 1em;
    border: 0.063em solid grey;
    position: relative;

    &--checked {
      &::after {
        content: '';
        display: block;
        position: absolute;
        top: 0.05em;
        left: 0.25em;
        width: 0.375em;
        height: 0.625em;
        border: solid #222;
        border-width: 0 0.125em 0.125em 0;
        transform: rotate(40deg);
      }
    }
  }

  .error {
    margin-left: 2.2em;
    font-size: 0.875em;
    color: tomato;
  }
</style>
