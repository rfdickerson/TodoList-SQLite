# Kitura Todo List SQLite 

[![Build Status](https://travis-ci.com/IBM-Swift/TodoList-SQLite.svg?token=pTMsfo6Pp2LFy6rU4Wcz&branch=master)](https://travis-ci.com/IBM-Swift/TodoList-SQLite)
[![Swift 3 9-05](https://img.shields.io/badge/Swift%203-9/05 SNAPSHOT-blue.svg)](https://swift.org/download/#snapshots)

Todo list backend with [SQLite3](http://www.sqlite.org)

## Requirements:

 - swift-DEVELOPMENT-09-05-SNAPSHOT compiler toolchain
 - XCode version 7.3
 - [SQLite 3](http://www.sqlite.org)

## Quick start for developing locally:

1. Install the [09-05-DEVELOPMENT Swift toolchain](https://swift.org/download/) 

2. Clone the boilerplate:

  `git clone https://github.com/IBM-Swift/todolist-sqlite`

3. Create a file database from the schema:

  `sqlite3 todolist.sqlite < schema.sql`

4. Run Swift Build

  - macOS: `swift build`
  - Linux: `swift build -Xcc -fblocks`
 
5. Run the tests

  `swift test`

## Using Docker Locally

1. Install Docker on your operating system

2. Build the Docker image:

  `sudo docker build -t todolist-sqlite . `

3. Run the web server:

  `sudo docker run -p 8090:8090 -d todolist-sqlite`
  

## Deploying Docker to IBM Bluemix Container

1. Login to your [Bluemix](https://new-console.ng.bluemix.net/?direct=classic) account (create an account, if necessary) 

2. Download and install the [Cloud Foundry tools](https://new-console.ng.bluemix.net/docs/starters/install_cli.html):
```
cf login
bluemix api https://api.ng.bluemix.net
bluemix login -u username -o org_name -s space_name
```

3. Download and install the [IBM Container's Plugin] (https://console.ng.bluemix.net/docs/containers/container_cli_cfic_install.html)

4. Log into cf ic
  `cf ic login` 

5. Build a Docker Image `sudo docker build -t todolist-sqlite . `

6. Tag the Docker image:

  `docker tag todolist-sqlite registry.ng.bluemix.net/<ORGANIZATION_NAME>/todolist-sqlite`

7. Push the Docker image: 

  `docker push registry.ng.bluemix.net/<ORGANIZATION_NAME>/todolist-sqlite`

8. Go to Bluemix and look for Compute 

  ![Sqlite](Images/ClickCompute.png)

9. Search for the '+' sign on the top right corner 

  ![Sqlite](Images/ClickOnPlus.png)

10. Then look for the 'todolist-sqlite' container that you pushed

  ![Sqlite](Images/SearchForYourContainer.png)

11. Input the value suggested in the images. Do not require advanced options unless you have any

  ![Sqlite](Images/Scalable.png)

12. Create the container and you should see your container on the dashboard page

  ![Sqlite](Images/ContainerCreated.png)
