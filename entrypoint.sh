#!/bin/bash
set -e

install_zip_dependencies(){
	echo "Installing and zipping dependencies..."
	mkdir python
	pip install --target=python -r "${INPUT_REQUIREMENTS_TXT}"
	zip -r dependencies.zip ./python
}

publish_dependencies_as_layer(){
	echo "Publishing dependencies as a layer..."
	local result=$(aws lambda publish-layer-version --layer-name "${INPUT_LAMBDA_LAYER_ARN}" --zip-file fileb://dependencies.zip)
	LAYER_VERSION=$(jq '.Version' <<< "$result")
	rm -rf python
	rm dependencies.zip
}

publish_function_code(){
	echo "Deploying the code itself..."
	zip -r code.zip . -x \*.git\*
	aws s3api put-object --bucket my-web-crawler --key code.zip --body code.zip
	aws lambda update-function-code --function-name "${INPUT_LAMBDA_FUNCTION_NAME}"
}

update_function_layers(){
	echo "Using the layer in the function..."
	aws lambda update-function-configuration --function-name "${INPUT_LAMBDA_FUNCTION_NAME}" --layers "${INPUT_LAMBDA_LAYER_ARN}:${LAYER_VERSION}"
	
}

deploy_lambda_function(){
	install_zip_dependencies
	download_chrome_drivers
	publish_dependencies_as_layer
	publish_function_code
	update_function_layers
}

download_chrome_drivers(){
	# Get chromedriver
	curl -SL https://chromedriver.storage.googleapis.com/96.0.4664.35/chromedriver_linux64.zip > chromedriver.zip
	unzip chromedriver.zip -d .
	
	# Get Headless-chrome
	curl -SL https://github.com/adieuadieu/serverless-chrome/releases/download/v1.0.0-57/stable-headless-chromium-amazonlinux-2.zip > headless-chromium.zip
	unzip headless-chromium.zip -d .
	
	# Clean
	rm headless-chromium.zip chromedriver.zip
}

deploy_lambda_function
echo "Done."
