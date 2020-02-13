import Vue from 'vue'
import { ValidationProvider, ValidationObserver } from 'vee-validate'
import FormBuilder from '@/components/FormBuilder'
import SmoothReflow from '@/components/SmoothReflow'

Vue.component('ValidationProvider', ValidationProvider)
Vue.component('ValidationObserver', ValidationObserver)
Vue.component('SmoothReflow', SmoothReflow)
Vue.component('FormBuilder', FormBuilder)
