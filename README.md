# Lattice Celebrate 🎉

A simple app that allows you to celebrate important milestones for your team members like birthdays and workaversaries. This application requires a Lattice account.

## Prerequisites

1. A Lattice account
2. A Slack account
3. An AWS account

## Setup Instructions

1. Clone this repo
2. Upload the included `function.zip` file to AWS Lambda. If you'd like, you can install the dependencies locally and create your own zip file.
3. Add your Lattice API key to the `LATTICE_API_KEY` environment variable. You can find your API key in the "API Keys" section of your Lattice account settings.
4. Grab your Slack API Token from the "OAuth & Permissions Page" in your Slack App and add it to the `SLACK_API_TOKEN` environment variable.
5. Add your destination Slack channel to the `SLACK_CHANNEL` environment variable.
6. On the AWS Lambda dashboard, under Configuration > General Configuration, set the timeout to 1min 30sec. The script should not take this long to run, but it's better to be safe than sorry. We can't have people missing their birthday shoutouts.

## Ignoring Users

Some people may not wish to have their birthdays or workaversaries mentioned. To ignore a user, add their email to the `IGNORED_USERS` environment variable, which is a comma separated list.

Example of how the variable might look: `IGNORED_USERS="sally.test@test.com, joe.test@test.com"`

