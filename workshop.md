# Load Test Workshop Challenges

This is a short series of challanges that can be used in an interactive workshop to get hands on experience with Azure Load Testing.

It uses the sample application and sample load test script in this repository as a starting point.

The demo application is an web app hosted in Azure App Services with a Cosmos Database backend. The mission is to see if you can get 500 requests per second from this application without spending more money than is necessary on the Azure resources.

Later challenges are about adapting this to one of your own application or service.

## Challenge One - Create Load Test Resource

This may be done in the Azure portal or using automation. You could also try the (https://docs.microsoft.com/en-us/azure/load-testing/quickstart-create-and-run-load-test([Quickstart]

You need to consider the location of the load testing service with respect to the target system's location. Discuss why this may be important.

## Challenge Two - Create a Demo System Under Test

Deploy the demo application using one of the scripts provided.

Where is it best to run these scripts?

Once deployed, discuss:
1. the application location
2. the application moving parts and how these may impact the performance of the application.

## Challenge Three - Run some load tests, checking results and changing scale to improve the application

May need here to achieve a target request rate that is in excess of what the service can deliver out of the box.

This may need several iterations.

What needed to change to acheive the desired request rate?

## Challenge Four - Generate a JMeter Dashboard of the results

The Azure Load Test service is currently in preview. The feature to generate JMeter dashboards has been disabled.

Work out how you may generate the JMeter dashboard yourself.

1. What do you need to do this?
2. Can it be done interactively or does it need some command-line tools?


## Challenge Five - Automate load testing in a GitHub Action

You will need to think about:
1. In which GitHub repository to run the action
2. when the action will run
3. How the action step is authenticated
4. How to drive parameters into the test
5. How to set success criteria
 
## Challenge Six - Load test your own application's endpoint

This is where things get more interesting - to apply all of the above to an application of your own. What you will need to do is:
1. Create/amend a JMX file. 
2. Run load test interactively
3. Discuss what changes may be needed to the application or test to get better results
4. Automate in GitHub action - setting success criteria
