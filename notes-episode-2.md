

# Episode 2
Pull Request: https://github.com/aws-samples/aws-serverless-airline-booking/pull/3

## CI/CD with GitHub
If you want to play with CI/CD, (@5:10), you will need to setup your own Git Hub repository to link to.  

Create a GitHub account https://github.com/

Create a repository and copy the Clone url of the repo to your clipboard

### Rename the origin remote 
Rename the repo you originally pulled the source from "aws-examples: aws-serverless-airline" to a new name such as aws-examples.
`git remote rename origin aws-examples`

### Add the remote to your local repo
`git remote set-url --add origin` _{paste the url for your repo here}_

Now when you fetch, pull or push the remote repo will be your new repo instead of the original 
aws-samples/aws-serverless-airline-booking repo on git hub.  If your git client asks you to choose, 
simply choose "origin" remote.

If you want to pull from the aws-examples repo you can by naming the remote.  Git client tools like Git Extensions
makes this very easy.  I'm not sure how to do it from VSCode other than command line.

Use this repo for his instructions for doing CI/CD.

## Setting up a domain
Starting around @9:00 he talk about registering your own domain name.

## Is it safe to push the amplify folder?
Around @9:30 they talk about the "safety" of pushing your source to a repo, passwords, client ids, etc.

## Adding an API
`amplify api add` @11:10

You can use [schema.graphql](https://github.com/heitorlessa/aws-serverless-airline-booking/blob/8c161093861ac661228077f03e80d0457b747dba/amplify/backend/api/awsserverlessairline/schema.graphql) checked into aws-examples to get his example.

I changed flightNumber to a String.

`amplify push` @14:45

## Using queries through AppSync

### Login to the AppSync UI
**NOTE:** If you are logged in the AppSync UI will save your queries.
He will get to it, but, you can log in before you enter the following and it will be saved.
Use the "ws_user_pools_web_client_id" from "src/aws-exports.js" and the user and password 
you registed in Episode 1.

He gets to logging in @23:08.

**NOTE:** I had to change the format of the dates otherwise I was getting an error about
the date being an invalid format.  I found [this](https://www.w3schools.com/js/js_date_formats.asp)
that described the proper format for dates in JavaScript

There may be a different option about formatting the data that is returned from GraphQL.

````graphql
mutation flight1 {
    createFlight(input: {
        departureDate:"2019-07-04T08:00:00Z",
      	departureAirportCode: "LGW",
      	departureAirportName: "London Gatwick",
      	departureCity: "London",
      	departureLocale: "Europe/London",
      	arrivalDate: "2019-07-04T10:00:00Z",
      	arrivalAirportCode: "MAD",
      	arrivalAirportName: "Madrid Barajas",
      	arrivalCity: "Madrid",
      	arrivalLocale: "Europe/Madrid",
      	ticketPrice: 400, 
      	ticketCurrency: "EUR",
      	flightNumber: "1812"
    }) {
      id
    }
}
````

He troubleshoots why his query @24:10.

@24:50
````graphql
query listFlights {
  listFlights(limit: 2){
    items{
    	id,
      departureCity,
      arrivalCity
    }
  }
}
````

@27:23
````graphql
query getFlight { 
  getFlight(id:"{replace wtih the ID you created before}") {
  	id
    departureCity
    arrivalCity
    departureDate
  }
}
````

## Connect fetchFlights to graphql 
catalog/actions.js @29:25

GraphQL vs AppSync SDK @30:35

````javascript 
import Amplify, {API, graphqlOperation} from "aws-amplify";
import {listFlights }from "../../graphql/queries";
````

````javascript
      // graphQL API
      const flightDataApi = await API.graphql(graphqlOperation(listFlights));
      console.log(flightDataApi);
````

**NOTE:** He uses a Chrome extension GraphQL Network to debug his GraphQL queries in the 
Chrome debugger.

@38:45
````javascript
      // graphQL API
      const {
        data: {
          listFlights: {
            items: flightDataApi
          }
        }
      } = await API.graphql(graphqlOperation(listFlights));
      console.log(flightDataApi);

      const flights = flightDataApi.map(flight => new Flight(flight));
````

@44:00
I couldn't use the date parameter directly because it was passed as DD-MM-YYYY.
````javascript
const formattedDate = date.slice(-4) + "-" + date.slice(3, 5) + "-" + date.slice(0, 2);
````

## Using Git CL to commit
@51:51 he uses the Git command line to 

Add all changed / new files to staging
`git add .`

Commit those changes to the branch
`git commit -m "feat: ep2 - Catalog service api"`

and push the changes on the local brach "twitch" to the remote origin repository. 
`git push origin twitch`

He then creates a pull request directly in Git Hub.