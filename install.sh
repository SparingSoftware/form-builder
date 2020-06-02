#!/bin/sh

# Variables
URL="https://raw.githubusercontent.com/SparingSoftware/form-builder/master/src"

# Utils
green_text () {
  echo
  echo -e "\e[32m$1\e[0m"
}

green_text "=== FORM BUILDER INSTALLER ==="

# Create necessary dirs
green_text "Create dirs..."
mkdir components
mkdir components/formBuilder
mkdir components/formBuilder/adapters
mkdir plugins

# Download plugins
green_text "Download plugins..."
cd ./plugins
curl -O "${URL}/plugins/{formBuilder,veeValidate}.js"
cd ..

# Download Form Builder
green_text "Download Form Builder..."
cd components/formBuilder
curl -O "${URL}/components/{FormBuilder,Loader,SmooothReflow}.vue"

# Download Adapters
green_text "Download Adapters..."
cd adapters

curl -O "${URL}/components/adapters/adapter.mixin.js"
curl -O "${URL}/components/adapters/Base{Input,Checkbox}.vue"
cd ../../..

# Install npm dependencies
green_text "Install dependencies..."
npm i vee-validate vue-smooth-reflow vue-wait

# Remove installer
rm install.sh

# Done
green_text "DONE - Form Builder installed!"
