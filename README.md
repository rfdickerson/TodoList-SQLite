# Kitura Todo List SQLite 

[![Build Status](https://travis-ci.org/IBM-Swift/todolist-boilerplate.svg?branch=master)](https://travis-ci.org/IBM-Swift/todolist-boilerplate)
[![Swift 3 6-20](https://img.shields.io/badge/Swift%203-6/20 SNAPSHOT-blue.svg)](https://swift.org/download/#snapshots)


> Todo list backend with [SQLite3](http://www.sqlite.org)

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

  macOS: `swift build`
  Linux: `swift build -Xcc -fblocks`
 
5. Run the tests

  `swift test`

