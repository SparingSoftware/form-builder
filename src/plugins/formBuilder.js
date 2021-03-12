import Vue from 'vue'
import { ValidationProvider, ValidationObserver } from 'vee-validate'
import FormBuilder from '@/components/formBuilder/FormBuilder'
import SmoothReflow from '@/components/formBuilder/SmoothReflow'

Vue.component('ValidationProvider', ValidationProvider)
Vue.component('ValidationObserver', ValidationObserver)
Vue.component('SmoothReflow', SmoothReflow)
Vue.component('FormBuilder', FormBuilder)
