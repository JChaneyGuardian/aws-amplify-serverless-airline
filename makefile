
##########################
# Bootstrapping variables
##########################

target:
	$(info ${HELP_MESSAGE})
	@exit 0

init: ##=> Install OS deps, python3.6 and dev tools
	$(info [*] Bootstrapping CI system...)
	@$(MAKE) _install_os_packages

outputs: ##=> Fetch SAM stack outputs and save under /tmp
	#$(MAKE) outputs.payment

outputs.payment: ##=> Fetch SAM stack outputs
	 aws cloudformation describe-stacks --stack-name $${STACK_NAME}-payment-$${AWS_BRANCH} --query 'Stacks[0].Outputs' --region $${AWS_REGION} > /tmp/payment-stack.json

outputs.vue: ##=> Converts Payments output stack to Vue env variables
	cat /tmp/payment-stack.json | jq -r '.[] | "VUE_APP_" + .OutputKey + "=\"" + (.OutputValue|tostring) + "\""'  > src/frontend/.env

deploy: ##=> Deploy services
	$(info [*] Deploying...)
	#$(MAKE) deploy.payment
	$(MAKE) deploy.booking

deploy.booking: ##=> Deploy booking service using SAM
	$(info [*] Packaging and deploying Booking service...)
	cd src/backend/booking && \
		sam build && \
		sam package \
			--s3-bucket $${DEPLOYMENT_BUCKET_NAME} \
			--region $${AWS_REGION} \
			--output-template-file packaged.yaml && \
		sam deploy \
			--template-file packaged.yaml \
			--stack-name $${STACK_NAME}-booking-$${AWS_BRANCH} \
			--capabilities CAPABILITY_IAM \
			--parameter-overrides \
				BookingTable=$${BOOKING_TABLE_NAME} \
				FlightTable=$${FLIGHT_TABLE_NAME} \
				CollectPaymentFunction=/service/payment/collect-function/$${AWS_BRANCH} \
				RefundPaymentFunction=/service/payment/refund-function/$${AWS_BRANCH} \
				AppsyncApiId=$${GRAPHQL_API_ID} \
				Stage=$${AWS_BRANCH} \
			--region $${AWS_REGION}

deploy.payment: ##=> Deploy payment service using SAM
	$(info [*] Packaging and deploying Payment service...)
	cd src/backend/payment && \
		sam build && \
		sam package \
			--s3-bucket $${DEPLOYMENT_BUCKET_NAME} \
			--region $${AWS_REGION} \
			--output-template-file packaged.yaml && \
		sam deploy \
			--template-file packaged.yaml \
			--stack-name $${STACK_NAME}-payment-$${AWS_BRANCH} \
			--capabilities CAPABILITY_IAM CAPABILITY_AUTO_EXPAND \
			--parameter-overrides \
				Stage=$${AWS_BRANCH} \
				StripeKey=$${STRIPE_SECRET_KEY} \
			--region $${AWS_REGION}


#############
#  Helpers  #
#############

_install_os_packages:
	$(info [*] Installing jq...)
	yum install jq -y
	$(info [*] Upgrading Python PIP, SAM CLI and CloudFormation linter...)
	python3 -m pip install --upgrade pip cfn-lint aws-sam-cli

define HELP_MESSAGE
	Common usage:

	...::: Bootstraps environment with necessary tools like SAM and Pipenv :::...
	$ make init

	...::: Deploy all SAM based services :::...
	$ make deploy
endef