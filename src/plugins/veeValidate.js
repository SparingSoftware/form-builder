import { extend, localize } from 'vee-validate'
import { required } from 'vee-validate/dist/rules'
import en from 'vee-validate/dist/locale/en.json'

extend('required', required)

localize('en', en)
