<template lang="html">
  <component :is="tag" class="loader-wrap">
    <div class="loader" :class="{ 'loader--active': loading }">
      loader
    </div>
    <div class="slot" :class="{ 'slot--disabled': loading }">
      <slot/>
    </div>
  </component>
</template>

<script>
export default {
  props: {
    tag: {
      type: String,
      default: 'div'
    },
    loading: {
      type: Boolean,
      required: true
    }
  }
}
</script>

<style lang="scss" scoped>
  .loader-wrap {
    position: relative;
  }

  .loader {
    position: absolute;
    z-index: 1;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;

    display: flex;
    justify-content: center;
    align-items: center;

    transition: opacity 0.2s, visibility 0.2s;

    opacity: 0;
    visibility: hidden;

    &--active {
      opacity: 1;
      visibility: visible;
    }
  }

  .slot {
    transition: opacity 0.2s;

    &--disabled {
      opacity: 0.2;
    }
  }
</style>
