
# Episode 4

This episode is all about AWS Step functions.  If you are learning Mule
or have worked MS Flow, they seem like the same kind of functionality.

[Build on Serverless | S2 E4 : Youtube video](https://www.youtube.com/watch?v=_LpIw32MwZU)

[aws-examples/aws-serverless-airline-booking episode 4 pull request](https://github.com/aws-samples/aws-serverless-airline-booking/pull/12)

(Secret GIST: booking-part-2-alek.md containing code samples)[https://gist.github.com/heitorlessa/51325686df06836f2fc062201364e7b0]

## Recap and overview
Switching from pipline resolvers to step functions.

Using SAM to deploy Step function.

Ends @13:45 They also increase the volume at this time.

## SAM template
They did a lot of work prior to the episode to create a cloud formation
template that they simply push at this point in the video.  The rest of 
the video is simply using the resources they created with the template.

### Stripe API 
The guest host, Alec, has a Stripe SAM application they incoroproate into this demo.  I 
don't know if the Koch Tenant will allow you to add it to the account.  If you try it 
and it works let me know.

It is interesting to follow along and see how they search the SAR (SAM Application 
Repository).  

They deploy a Stripe API written by the guest @14:00.

They show how to find SAM deployment written by Alec through the AWS UI, @15:00

This will deploy the lambda functions and other things into your account to allow you 
to use Stripe to credit card transactions with your users.  Their template.yaml
incorporates this SAM to do the heavy lifting of working with Stripe.

### Files from this episode
These are the files they commited to their repo for this episode.  The put them under "src/backend/booking".

The aws command below needs to be run from the folder where you put the "template.yaml" with the python
source files in a "src" folder under that. 

[template.yaml](https://github.com/aws-samples/aws-serverless-airline-booking/blob/b9f4e33dd36f007f3f4e5b71631e646484cda99d/src/backend/booking/template.yaml)

**NOTE:** The template.yaml has already been fixed with the correct JSON replacement 
syntax as noted in the PR and the caues of the issues they run into @44:27.

[src/collect.py](https://github.com/aws-samples/aws-serverless-airline-booking/blob/b9f4e33dd36f007f3f4e5b71631e646484cda99d/src/backend/booking/src/collect.py)

[src/confirm.py](https://github.com/aws-samples/aws-serverless-airline-booking/blob/b9f4e33dd36f007f3f4e5b71631e646484cda99d/src/backend/booking/src/confirm.py)

[src/refund.py](https://github.com/aws-samples/aws-serverless-airline-booking/blob/b9f4e33dd36f007f3f4e5b71631e646484cda99d/src/backend/booking/src/refund.py)

### Not using Stripe
I did not want to hassle with Stripe.  I modified the template.yaml and python
source to simply always return a success response.

Here are the files from my repo.  If you look at the history you can see the simple changes
I made to the files.  I am not a python programmer (yet :) ) 

[template.yaml](https://github.com/JChaneyGuardian/aws-amplify-serverless-airline/tree/personal/episode3/src/backend/booking/template.yaml)

[src/collect.py](hhttps://github.com/JChaneyGuardian/aws-amplify-serverless-airline/tree/personal/episode3/src/backend/booking/src/collect.py)

[src/confirm.py](https://github.com/JChaneyGuardian/aws-amplify-serverless-airline/tree/personal/episode3/src/backend/booking/src/confirm.py)

[src/refund.py](https://github.com/JChaneyGuardian/aws-amplify-serverless-airline/tree/personal/episode3/src/backend/booking/src/refund.py)


### S3 Bucket
You will need an S3 bucket as a workspace for the cloudformation utility to work in.
This is the [AWS Quick Start Guide](https://docs.aws.amazon.com/quickstarts/latest/s3backup/step-1-create-bucket.html) for creating an S3 bucket.

## Pushing to cloudformation
@14:02 They use the commands below to create the CloudFormation Stack in AWS using the
template.yaml they created before the video.

If you aren't using your "default" AWS security profile, swap in the correct name below.

You also need to change to Id's of your DynamoDb tables for Bookings and Flights.

**NOTE:** You need put these commands all on one line. The backslashes didn't work for me.
````
aws cloudformation package \
    --template-file template.yaml \
    --output-template-file packaged.yaml \
    --s3-bucket {S3 bucket you created for this} \
    --profile {Your chosen profile probably "default"}

aws cloudformation deploy \
    --template-file packaged.yaml \
    --stack-name process-booking-state-machine \
    --capabilities CAPABILITY_IAM CAPABILITY_AUTO_EXPAND \
    --parameter-overrides BookingTable={Booking table from DynamoDb} FlightTable={Flight table from DynamoDb} \
    --profile {your chosen profile probably "default"}
````

## Create role to run the step function
Switch to the AWS AIM UI @29:20

Policy as json
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "states:StartExecution"
            ],
            "Resource": [
                "{copy the arn of your new Step function}"
            ],
            "Effect": "Allow"
        }
    ]
}
```

Copies the right Resource name for the policy @31:50

## Create the DataSource in Appsync that calls your Step function
@33:20

**NOTE:** Update the region in your endpoint and signingInRegion.

**File:** *state-machine-datasource.json*

I created this file in the "src/backend/booking" folder, because that's
where my current directory was.
```json
{
    "endpoint": "https://states.{region}.amazonaws.com",
    "authorizationConfig": {
        "authorizationType": "AWS_IAM",
        "awsIamConfig": {
            "signingRegion": "{region}",
            "signingServiceName": "states"
        }
    }
}
```

````bash
aws appsync create-data-source --api-id {api id } \
    --name ProcessBookingStateMachine \
    --type HTTP \
    --http-config file://state-machine-datasource.json \
    --service-role-arn {created in just previous step} \
    --profile default
````

## Create function to call step function
[gist example code](https://gist.github.com/heitorlessa/51325686df06836f2fc062201364e7b0#gistcomment-2917981)

He walks through the code in the GIST @36:40

@36:59 They tell you it's not as complicated as it looks.  This is a LIE. It IS complicated. LOL

@41:25 Attaches the function to the pipeline resolver for procesBooking

@41:45 they talk about how the Schema has been updated to take the new response
type from processBooking, but, I don't remember them actually updating the 
schema.

## Test it
 @42:25 they test the new functions through the AppSync Query Interface

same query as before
 
 @44:27 go to step function state machine and debug the process.
 @46:20 debug the error that caused the failure

@50:30
 In the [pull request notes](https://github.com/aws-samples/aws-serverless-airline-booking/pull/12) he talks about there being a typo in his json expansions.  Instead of `"TableName": "$.flightTable"` they should look 
 like this `"TableName.$": "$.flightTable"`.

@51:49 they make another test using an actual charge id.

@53:00 they decide the problems can't be figured out in the video.  (Not complicated? )
