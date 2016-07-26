

import Foundation

import Kitura
import HeliumLogger
import LoggerAPI
import TodoListWeb
import CloudFoundryEnv
import TodoListAPI

Log.logger = HeliumLogger()

extension DatabaseConfiguration {
    
    init(withService: Service) {
        if let credentials = withService.credentials{
            self.host = credentials["host"].stringValue
            self.username = credentials["username"].stringValue
            self.password = credentials["password"].stringValue
            self.port = UInt16(credentials["port"].stringValue)!
        } else {
            self.host = "127.0.0.1"
            self.username = "root"
            self.password = ""
            self.port = UInt16(3306)
        }
        self.options = ["test" : "test"]
    }
}

let databaseConfiguration: DatabaseConfiguration
let todos: TodoList

do {
    if let service = try CloudFoundryEnv.getAppEnv().getService(spec: "TodoList-SQLite"){
        Log.verbose("Found TodoList-MySQL")
        databaseConfiguration = DatabaseConfiguration(withService: service)
        todos = TodoList(databasePath: "Somepath")
    } else {
        Log.info("Could not find Bluemix SQlLite service")
        todos = TodoList(databasePath: "/Users/sakandur/sai/sqlite-autoconf-3130000/todolist")
    }
    
    let controller = TodoListController(backend: todos)
    
    let port = try CloudFoundryEnv.getAppEnv().port
    Log.verbose("Assigned port is \(port)")
    
    Kitura.addHTTPServer(onPort: port, with: controller.router)
    Kitura.run()
    
} catch CloudFoundryEnvError.InvalidValue {
    Log.error("Oops... something went wrong. Server did not start.")
}
