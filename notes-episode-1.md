
# WARNING
This is not a tutorial.  These are just my notes from watching the video and following.
Others may find them helpful.  The @ timestamps are there because I found myself going
back and forth as I watched to pick up things I had missed.

There are some installation instructions in the Installation.md file.  It would probably 
be a benefit to look at that before starting the videos.

# Episode 1
Pull Request Notes: https://github.com/aws-samples/aws-serverless-airline-booking/pull/2


## Initialize amplify environment
**NOTE:** Make sure you are on an episode0 commit/branch otherwise much of this will have already been done 
and you won't be asked some of the questions.
`amplify init`  @16:40

**NOTE:** If you are using the shared gdn-lab-test account under the Koch tenant make sure you add your initials to the names to 
keep things separate from the others that will be pushing to that account.

## Add Authentication
`amplify auth add` @25:00

I was asked to choose how I want the users to sign in.  That wasn't in the video.  I chose "Email".
**NOTE:** By choosing email, that became what the user has to enter to sign into my app.  In hindsite I might have
chosen a simpler Username instead.

At the end I was asked if I want to use the OAuth flow.  I chose "No"

## Add Custom Attributes 
Add luggage_preference and meal_preference @29:19

`amplify push` @34:00

## Test the application so far
`npm run serve` @37:35

## Customize Sign-Up
He starts talking about customizing the Signup for @40:40.  

He gives up trying to figure out adding the custom fields and continues testing @48:15.

Final code that gets working after the video can be found in the Git-Hub repo.  Switch to the "episode1" tag, 
and go to the "[src/Views/Authentication.vue](https://github.com/aws-samples/aws-serverless-airline-booking/blob/episode1/src/views/Authentication.vue)" file.

I changed the default phone prefix to 1 for USA.  He uses 44 for the UK.

**NOTE:** He uses a service [TempMail](https://temp-mail.org/en/api/) @48:20 to get a temporary email.  Pretty cool :)  I didn't use that.
This service can also be used to get a temporary SMS number.

## Vue Chrome Extension
During debugging he uses a Chrome extension, , to provide a cleaner look at the Vue debug information.

I installed Vue.js Devtools. It had a good rating and was available for both Chrome and FireFox.

## Review User in Cognito
He attempts to trouble shoot the problems with the user through the Cognito UI @49:45

He continues the demo again @52:00

## Amplify calls and Auth Tokens
He looks at the calls in the Network tab @55:10

## Create a user in Cognito
He goes back and creates a user directly in Cognito @57:30



