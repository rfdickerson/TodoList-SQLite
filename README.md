# Kitura Todo List Boilerplate

> An example using the Kitura web framework and HTTP Server to develop a backend for a todo list organizer

## Requirements:

 - swift-DEVELOPMENT-06-06-SNAPSHOT compiler toolchain

## Quick start for developing locally:

1. Install the [06-06-DEVELOPMENT Swift toolchain](https://swift.org/download/) 

2. Clone the boilerplate:

  `git clone https://github.com/IBM-Swift/todolist-boilerplate`

2. Autogenerate an XCode project:

  ```
  cd todolist-boilerplate
  swift package generate-xcodeproj
  ```

3. Add additional Library Search Path:   

  Currently the 06-06 snapshot will automatically generate an XCode project, but will fail to find compiled libraries that are located in .build/debug. You must manually add a search path to the XCode project. Open the XCode project and in the 'Build Settings' of both the ***Kitura*** and ***Kitura-net*** modules, add the following to your ***Library Search Paths***:
    
    `$SRCROOT/.build/debug`

3. Add the necessary dependencies to your `Package.swift` file:

  For example, the CouchDB implementation could look like:
  
  ```swift
  let package = Package(
    name: "TodoList",
    dependencies: [
                      .Package(url: "https://github.com/IBM-Swift/todolist-api.git", majorVersion: 0),
                      .Package(url: "https://github.com/IBM-Swift/Kitura-CouchDB.git", majorVersion: 0, minor: 16)
    ]
   )
  ```

3. Open the project and open Sources/

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
