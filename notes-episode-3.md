


# Episode 3
His notes from pull request: https://github.com/aws-samples/aws-serverless-airline-booking/pull/11

Nadit recaps the overview and setup up to @9:00

Updates schema with new fields and models @9:10

/amplify/backend/api/awsserverlessonline/schema.graphql

**NOTE**: This is not the schema.graphql you created in the previous episode.  Also, the folder under "/api/" will be
different, if you used a different name for your api.

`amplify push` @18:10

create a test flight through AppSync @23:50

**NOTE**: You get the client id for logging in from the `"aws_user_pools_web_client_id"`
property in `aws-exports.js`

**WARNING**: If you have to log in you will lose any recent changes to your query document
so make sure you copy it to someplace safe so you can copy it back.

_create new flight with seat allocation_
````graphql
mutation flight1 {
  createFlight(input:    {
        departureDate: "2019-07-02T08:00:00Z",
        departureAirportCode: "LGW",
        departureAirportName: "London Gatwick",
        departureCity: "London",
        departureLocale: "Europe/London",
        arrivalDate: "2019-07-03T10:15Z",
        arrivalAirportCode: "MAD",
        arrivalAirportName: "Madrid Barajas",
        arrivalCity: "Madrid",
        arrivalLocale: "Europe/Madrid",
        ticketPrice: 234,
        ticketCurrency: "EUR",
        flightNumber: "1812",
        seatAllocation: 3
  }),{
    id
  }
}
````

**NOTE**: save the flight id you just created.


changes "mutation" to "Mutation" @26:50 and does an `amplify push` in the background

## newBooking
starts creating a new mutation to add a booking @27:40 but jumps back and forth a lot
to get the flight id from a query etc. and finishes @30:50

_newBooking mutation_
````graphql
mutation newBooking {
  createBooking(input:{
    paymentToken:"sometoken"
    bookingOutboundFlightId:"{Use the flight Id you created just before this}"
  }) {
    id
  }
}
````

**NOTE**: Save the booking id you just created


## getBooking
creates a query "getBooking" @31:00 that pulls in data from connected flight

_getBooking query_
````graphql
query getBooking {
  getBooking(id: "{Use the booking id you just created}") {
    id
    outboundFlight {
      arrivalDate
      arrivalCity
      arrivalLocale
      seatAllocation
      departureDate
      departureCity
      departureLocale
    }


  }
}
````

## PaymentAPI DataSource
starts attaching the custom resolver "processingBooking" @33:50 but then
switches to creating a datasource @36:00

`https://httpbin.org`

back to attaching pipeline resolver to processBooking @36:50 and creates function VerifyToken

**NOTE:** You can ignore what he puts into the before mapping for now.
He is actually going to skip this until he creates the three function he will actually use in
the pipeline resolver @44:00

## VefifyToken Function
Starts creating VerifyToken function @37:10

_function_
````json
{
  "method": "GET",
  "resourcePath": "/status/200",
  "params":{
      "query":{
      	"token": $util.toJson($ctx.stash.paymentToken)
      },
      "headers": {
          "Authorization": "$ctx.request.headers.Authorization"
      }
  }
}
````

_response mapping_
````javascript
## Raise a GraphQL field error in case of a datasource invocation error
#if($ctx.error)
  $util.error("VerifyToken Error",$ctx.error.message, $ctx.error.type)
#end
## Pass back the result from DynamoDB **
$util.toJson($ctx.result)
````

## ReserveFlight Function
Starts creating a new function "ReserveFlight" @39:00

_Configure request template_
````json
{
	"version":"2017-02-28",
    "operation": "UpdateItem",
    "key": {
  		"id":$util.dynamodb.toDynamoDBJson($ctx.stash.outboundFlightId)
    },
    "update": {
    	"expression":"SET seatAllocation = seatAllocation - :dec",
        "expressionValues" : {
        	":dec":{"N": "1"}
        }
    },
    "condition": {
        "expression": "seatAllocation > :noSeat",
        "expressionValues": {
            ":noSeat": {"N": "0"}
        }
    }
}
````

_Configure response mapping template to have custom error message_
````javascript
## Raise a GraphQL field error in case of a datasource invocation error
#if($ctx.error)
    $util.error("No seats left...", $ctx.error.message, $ctx.error.type)
#end
## Pass back the result from DynamoDB. **
$util.toJson($ctx.result)
````

## ReserveBooking Function
starts creating the "ReserveBooking" function @41:13

_function_
````javascript
$util.qr($context.args.input.put("createdAt", $util.time.nowISO860()))
$util.qr($context.args.input.put("updatedAt", $util.time.nowISO860()))
$util.qr($context.args.input.put("__typename", "Booking"))
$util.qr($context.args.input.put("checkedIn", false))
### Add logged in customer as the value
$util.qr($context.args.input.put("customer", $ctx.identity.sub))
$util.qr($context.args.input.put("status", "UNCONFIRMED"))

## Missing outbound flight ID
{
    "version": "2017-02-28",
    "operation":"PutItem",
    "key": {
        "id": $util.dynamodb.toDynamoDBJson($util.defaultIfNullOrBlank($ctx.args.input.id, $util.autoId()))
    },
    "attributeValues": $util.dynamodb.toMapValuesJson($context.args.input),
    "condition": {
    	"expression":"attribute_not_exists(#id)",
        "expressionNames": {
        	"#id":"id"
        }
    }
}

````

## ProcessBooking Pipeline Resolver
Goes back to ProcessBooking mutation AGAIN @43:50 and chooses create pipline resolver.
At this point he is ready to put all the functions together.

_before mapping template_
````javascript
$util.qr($ctx.stash.put("outboundFlightId", $ctx.args.input.bookingOutboundFlightId))
$util.qr($ctx.stash.put("paymentToken", $ctx.args.input.paymentToken))
$util.qr($ctx.stash.put("customer", $ctx.identity.sub))
{}
````

He flops is mouse around a LOT again but adds the functions in this order
"VerifyToken", "ReserveFlight", "ReserveBooking"

Create it

## ProcessBooking mutation
He tests the resolver using a GraphQL query mutation @46:10

````graphql
mutation processBooking {
  processBooking(input:{
    paymentToken:"sometoken",
    bookingOutboundFlightId:"{Use the flight Id you created before}"
  }) {
    id
  }
}
````

calls it multiple times until it returns an error that no seats are available.

## Recap
He recaps what he did in this video starting @48:00