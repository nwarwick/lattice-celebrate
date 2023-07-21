# Lattice Celebrate 🎉
A simple app that allows you to celebrate important milestones for you team members like birthdays and workaversaries. This application requires a Lattice account.

## Setup Instructions
1. Clone this repo
2. Add your Lattice API key to the `.env` file under `LATTICE_API_KEY`
3. Deploy to your platform of choice!

## Ignoring Users
Some people may not wish to have their birthdays or workaversaries mentioned. To ignore a user, add their email to the comma separated list contained within the `IGNORED_USERS` environment variable in the `.env` file.

Example of how the variable might look: `IGNORED_USERS="sally.test@test.com, joe.test@test.com"`