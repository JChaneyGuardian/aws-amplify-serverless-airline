
## Install this basic software
git                 https://git-scm.com/download/win
npm (Node.js)       https://www.npmjs.com/get-npm
aws cli             https://docs.aws.amazon.com/cli/latest/userguide/install-windows.html#install-msi-on-windows
vscode              https://code.visualstudio.com/download

**NOTE:** I've had some reports that you do not need to install the aws cli to work with the 'Build on Serverless' examples.

### Configure NPM to work with ZScaler
Get your Zscaler proxy virtual IP
http://ip.zscaler.com/

Configure NPM to use Zscaler
`npm config set proxy http://`_{virtual ip}_`:80/`
`npm config set https-proxy http://`_{virtual ip}_`:80/`


### Configure git to use Zscaler
`git config --global http.proxy http://`_{virtual ip}_`:80/`
`git config --global https.proxy https://`_{virtual ip}_`:80/`

## Create an AWS Free Tier Account 
If you are going to use the Accounts associated with the Koch Tenant you do not need to create a Free Tier account.
https://aws.amazon.com/free/?all-free-tier.sort-by=item.additionalFields.SortRank&all-free-tier.sort-order=asc&awsf.Free%20Tier%20Types=categories%23featured

*** You will need to give it a Credit/Debit card number ***
- Create an Administrator user that is not your Root user.
https://docs.aws.amazon.com/IAM/latest/UserGuide/getting-started_create-admin-group.html

## Koch Tenant signon
If you are going to use a Free Tier account you don't have to worry about this section
This URL will get you to the selection of Koch Tenant Accounts you have available.  Some people have been using the gdn-lab-test account.  
Talk to Phil Tsui to get assigned to it.  

https://sso.kochind.com/idp/startSSO.ping?PartnerSpId=urn:amazon:webservices

You have to be on the Guardian Network to use this.  That means at a Guardian facility on their network on connected through the WAN.

## Get the Build On Servless: aws-serverless-airline source code
This command will clone the repo from git-hub into your current folder.  
`git clone https://github.com/aws-samples/aws-serverless-airline-booking.git . `
`git checkout episode0`

**NOTE**: Pull requests at github
Shows all the changes done to the files during the commits of an episode. 
Contains all the notes he had in his "Untitled.md" file while he was talking. 
https://github.com/aws-samples/aws-serverless-airline-booking/pulls?utf8=%E2%9C%93&q=is%3Apr

## NVM - Node Version Manager
**NOTE:** You should not need this.

I had some issues with amplify on my home machine.  I noticed he does a `nvm use 8.10` in the video.  
NVM allows you to install multiple versions of Node and switch between them.  Here is some information
about it, however, if you don't need it I would avoid this complication until you are comfortable with
using Node.

https://davidwalsh.name/nvm 
https://github.com/coreybutler/nvm-windows  -- Windows version
https://github.com/nvm-sh/nvm/blob/master/README.md  -- Mac only

`wmic os get osarchitecture` -- allows you to find the architecture version proably 64-bit.

`nvm install 8.10 64-bit`

`amplify configure`

## Initialize node modules
This command will load the npm libaries already set by the original author.
`npm install`  

This should install aws-amplify and aws-amplify-vue.

This command will install the amplify command line interface on your computer
`npm install -g @aws-amplify/cli`

 ## Install Amplify CLI
**NOTE:** After installing the amplify cli, some of us were getting an error that `amplify` was a valid command.  We had to manually add 
`C:\Users\`_{your user id}_`\AppData\Roaming\npm` to our Environment PATH.


## CI/CD with GitHub
Create a GitHub account if you want to play with CI/CD, you will need to setup your own Git hub repository to link to.

https://github.com/

Create a repository and copy the Clone url of the repo to your clipboard

### Rename the origin remote 
Rename the repo you originally pulled the source from "aws-examples: aws-serverless-airline" to a new name such as aws-examples.
`git remote rename origin aws-examples`

### Add the remote to your local repo
`git remote set-url --add origin` _{paste the url for your repo here}_

Now when you fetch, pull or push the remote repo will be your new repo instead of the original 
aws-samples/aws-serverless-airline-booking repo on git hub.  If your git client asks you to choose, 
simply choose "origin" remote.


