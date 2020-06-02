#!/bin/sh

# Variables
URL="https://raw.githubusercontent.com/SparingSoftware/form-builder/master/src"

# Create necessary dirs
mkdir components
mkdir components/formBuilder
mkdir components/formBuilder/adapters
mkdir plugins

# Download plugins
cd ./plugins
curl -O "${URL}/plugins/{formBuilder,veeValidate}.js"
cd ..

# Download Form Builder
cd components/formBuilder
curl -O "${URL}/components/{FormBuilder,Loader,SmooothReflow}.vue"

# Download Adapters
cd adapters
curl -O "${URL}/components/adapters/Base{Input,Checkbox}.vue"
curl -O "${URL}/components/adapters/adapter.mixin.js"
cd ../../..

# Remove instalator
rm install.sh
