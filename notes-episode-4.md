
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

## Stripe API 
They deploy a Stripe API written by the guest @14:00, I don't think you need that. I think we can stub that out.

They show how to find SAM deployment written by Alec through the AWS UI, @15:00

This will deploy the lambda functions and other things into your account to allow you to use Stripe to credit card transactions with your users.

## Create role to run the step function
Switch to the AWS AIM UI @29:20

Copies the right Resource name for the policy @31:50

## Create the DataSource in Appsync that calls your Step function
@33:20

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
