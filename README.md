# Kitura Todo List SQLite 

[![Build Status](https://travis-ci.com/IBM-Swift/TodoList-SQLite.svg?token=pTMsfo6Pp2LFy6rU4Wcz&branch=master)](https://travis-ci.com/IBM-Swift/TodoList-SQLite)
[![Swift 3 6-20](https://img.shields.io/badge/Swift%203-6/20 SNAPSHOT-blue.svg)](https://swift.org/download/#snapshots)

Todo list backend with [SQLite3](http://www.sqlite.org)

## Requirements:

 - swift-DEVELOPMENT-06-20-SNAPSHOT compiler toolchain
 - XCode version 7.3
 - [SQLite 3](http://www.sqlite.org)

## Quick start for developing locally:

1. Install the [06-20-DEVELOPMENT Swift toolchain](https://swift.org/download/) 

2. Clone the boilerplate:

  `git clone https://github.com/IBM-Swift/todolist-sqlite`

3. Create a file database from the schema:

  `sqlite3 todolist.sqlite < schema.sql`

4. Run Swift Build

  - macOS: `swift build`
  - Linux: `swift build -Xcc -fblocks`
 
5. Run the tests

  `swift test`

## Using Docker

1. Install Docker on your operating system

2. Build the Docker image:

  `sudo docker build -t todolist-sqlite . `

3. Run the web server:

  `sudo docker run -p 8090:8090 -d todolist-sqlite`
  
