## Project Plan

The goal of this project is to create a practical solution for optimizing CI/CD workflows. Industry costs for runners can rack up quickly if they are left running constantly. I read that it is more cost-efficient to have AWS host the runners using **EC2 Spot Instances** that die after a job is done. Im going to try that wirh fargate spot/ecs as i beleive i might be able to save costs this way

I mainly wanted to do this project because I think resume projects should solve a problem that is actually faced in the job you are going for. It shouldn't just be a project that shows you know the services, but one that shows you know how to figure out problems and work with the services in the context of the role.

## Tools
- Terraform
- AWS
- Github actions
- Linux
- Docker
- JS / Node.js for lambda
- Maybe some Bash

## AWS services
- **ECS**
- **Fargate** Spot Instances
- **SSM** to store parameters like webhooks and Github keys
- **Lambda** to auth the webhook + secret from github so randoms cant make a runner


## Flow so far
- user commits
- pull request is triggered
- sends a webhook / secret to my lambda
- Lambda auths the webhook against my the secret i have stored
- lambda asks for a runner token from github
- lambda spins up ECS task
- Container is loaded up with the code
- container builds and runs tests
- after job is done, container dies
