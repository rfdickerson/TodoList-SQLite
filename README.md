# Kitura To-do List Backend

*An example using the Kitura web framework and HTTP Server to develop a backend for a todo list organizer*

[![Build Status](https://travis-ci.org/IBM-Swift/Kitura-TodoList.svg?branch=master)](https://travis-ci.org/IBM-Swift/Kitura-TodoList)

> Supports the 05-03 SNAPSHOT.

## Tutorial

This project accompanies the tutorial on IBM Developer Works: [Build End-to-End Cloud Apps using Swift with Kitura](https://developer.ibm.com/swift/2016/02/22/building-end-end-cloud-apps-using-swift-kitura/)

## Quick start for running locally

1. Install the [05-03-DEVELOPMENT Swift toolchain](https://swift.org/download/) 

2. Install Kitura dependencies:

  1. Mac OS X: 
  
    `brew install curl`
  
  2. Linux (Ubuntu 15.10):
   
    `sudo apt-get install libcurl4-openssl-dev`

3. Build TodoList application

  1. Mac OS X: 
	
	`swift build`
	
  2. Linux:
  
    	`swift build -Xcc -fblocks`
	
4. Install couchdb:

    If on OS X, install with Homebrew with:
    
    `brew install couchdb`
    
    If on Ubuntu, install with apt-get:
    
    `apt-get install couchdb`
    
    Follow your distribution's directions for starting the CouchDB server
    
5. Create the necessary design and views for CouchDB:

    Create a new file in your directory called mydesign.json and add the following:
    
    ```javascript
    {
    "_id": "_design/example",
        "views" : {
            "all_todos" : {
                "map" : "function(doc) { 
                    if (doc.type == 'todo' && doc.active) { 
                        emit(doc._id, [doc.title, doc.completed, doc.order]);
                }"
             }
        },
        "total_todos": {
            "map" : "function(doc) { 
                   if (doc.type == 'todo' && doc.active) { 
                       emit(doc.id, 1); 
                   }
                }",
            "reduce" : "_count"
            }
        }
    }
    ```

    Run the following on the command line:
    
    ```
    curl -X PUT http://127.0.0.1:5984/todolist
    curl -X PUT http://127.0.0.1:5984/todolist/_design/example --data-binary @mydesign.json
    ```

5. Run the TodoList application:

	`./.build/debug/TodoList`
	
6. Open up your browser, and view: 

   [http://www.todobackend.com/client/index.html?http://localhost:8090](http://www.todobackend.com/client/index.html?http://localhost:8090)

## Developing and Running in XCode:

Make sure you are running at least XCode 7.3. 

1. Automatically generate an XCode project from the Package.swift:

  `swift build -X`

2. Open XCode project

  `open TodoList.xcodeproj`

3. Switch the toolchain to the open source version of Swift.

4. Add Library search paths *This is a temporary work around*

    Currently 05-03 snapshot of Swift has trouble finding the compiled C libraries that are located in .build/debug. You must manually add a search path to the XCode project. Open the XCode project and in both the ***Kitura*** and ***Kitura-net*** modules, add the following to your ***Library Search Paths***:
    
    `$SRCROOT/.build/debug`

## Tests

  To run unit tests, run:
  
  `swift test`
  
  If you are using XCode, you can run the Test Cases as normal in the IDE.

## Deploying to BlueMix

1. Get an account for [Bluemix](https://new-console.ng.bluemix.net/?direct=classic)

2. Dowload and install the [Cloud Foundry tools](https://new-console.ng.bluemix.net/docs/starters/install_cli.html):

    ```
    cf login
    bluemix api https://api.ng.bluemix.net
    bluemix login -u username -o org_name -s space_name
    ```

    Be sure to change the directory to the Kitura-TodoList directory where the manifest.yml file is located.

3. Run `cf push`

    ***Note** The uploading droplet stage should take a long time, roughly 5-7 minutes. If it worked correctly, it should say:

    ```
    1 of 1 instances running 

    App started
    ```

4. Create the Cloudant backend and attach it to your instance.

    ```
    cf create-service cloudantNoSQLDB Shared database_name
    cf bind-service Kitura-TodoList database_name
    cf restage
    ```

5. Create a new design in Cloudant

    Log in to Bluemix, and select New View. Create a new design called `_design/example`. Inside of the design example, create 2 views:

6. Create a view named `all_todos` in the example design:

    This view will return all of the todo elements in your database. Add the following Map function:

    ```javascript
    function(doc) {
        if (doc.type == 'todo' && doc.active) {
            emit(doc._id, [doc.title, doc.completed, doc.order]);
        }
    }
    ```

    Leave Reduce as None.

7. Create a view named `total_todos` in the example design:

    This view will return the count of all the todo documents in your database.

    ```javascript
    function(doc) {
        if (doc.type == 'todo' && doc.active) {
            emit(doc.id, 1);
        }
    }
    ```

    Set the reduce function to `_count` which will tally all of the returned documents.



## License 

This library is licensed under Apache 2.0. Full license text is available in [LICENSE](LICENSE).
