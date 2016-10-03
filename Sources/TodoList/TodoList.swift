/**
 * Copyright IBM Corporation 2016
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import Foundation
import TodoListAPI
import LoggerAPI
import SQLite
import SwiftyJSON

public struct TodoList : TodoListAPI {
    
    // Change this to use a different file.
    let defaultDatabasePath = "todolist.sqlite"

    var sqlLite: SQLite!
    
    public init?(databasePath: String) {
        sqlLite = try? SQLite(path: databasePath)
    }
    
    public init?(){
        sqlLite = try? SQLite(path: defaultDatabasePath)
    }
    
    public func count(withUserID: String?, oncompletion: @escaping (Int?, Error?) -> Void) {

        let user = withUserID ?? "default"
        do {
            let query = "SELECT * FROM todos WHERE owner_id=\"\(user)\""
            let results = try sqlLite?.execute(query)
            oncompletion(results?.count, nil)
        }
        catch {
            Log.error("There was a problem with the SQLite query: \(error)")
            oncompletion(nil, TodoCollectionError.CreationError("There was a problem with the query: \(error)"))
        }
    }
    
    public func clear(withUserID: String?, oncompletion: @escaping (Error?) -> Void) {

        let user = withUserID ?? "default"
        do {
            let query = "DELETE FROM todos WHERE owner_id=\"\(user)\""
            _ = try sqlLite?.execute(query)
            oncompletion(nil)
        }
        catch {
            Log.error("There was a problem with the query: \(error)")
            oncompletion(TodoCollectionError.CreationError("There was a problem with the query: \(error)"))
        }
    }
    
    public func clearAll(oncompletion: @escaping (Error?) -> Void) {

        do {
            let query = "DELETE From todos"
            _ = try sqlLite?.execute(query)
            oncompletion(nil)
        }
        catch {
            Log.error("There was a problem with the query: \(error)")
            oncompletion(TodoCollectionError.CreationError("There was a problem with the query: \(error)"))
        }
    }
    
    public func get(withUserID: String?, oncompletion: @escaping ([TodoItem]?, Error?) -> Void) {

        let user = withUserID ?? "default"
        do {
            let query = "SELECT rowid,* FROM todos WHERE owner_id=\"\(user)\""
            let results = try sqlLite?.execute(query)
            let todos = try parseTodoItemList(results: results!)
            oncompletion(todos, nil)
        }
        catch {
            Log.error("There was a problem with the query: \(error)")
            oncompletion(nil, TodoCollectionError.CreationError("There was a problem with the query: \(error)"))
        }
    }
    
    public func get(withUserID: String?, withDocumentID: String, oncompletion: @escaping (TodoItem?, Error?) -> Void ) {

        let user = withUserID ?? "default"
        let documentID = Int(withDocumentID)!
        do {
            let query = "SELECT rowid, * FROM todos WHERE owner_id=\"\(user)\" AND rowid=\(documentID)"
            let results = try sqlLite?.execute(query)
            let todos = try parseTodoItemList(results: results!)
            oncompletion(todos[0], nil)
        }
        catch {
            Log.error("There was a problem with the query: \(error)")
            oncompletion(nil, TodoCollectionError.CreationError("There was a problem with the query: \(error)"))
        }
    }
    
    public func add(userID: String?, title: String, rank: Int, completed: Bool,
             oncompletion: @escaping (TodoItem?, Error?) -> Void ) {

        let user = userID ?? "default"

        do {
            let completedValue = completed ? 1 : 0
            let query = "INSERT INTO todos (title, owner_id, completed, orderno) VALUES (\"\(title)\", \"\(user)\", \(completedValue), \(rank))"
            _ = try sqlLite?.execute(query)

            guard let id = sqlLite?.lastId else {
                oncompletion(nil, TodoCollectionError.CreationError("There was a problem getting the ID from new todo item"))
                return
            }
            
            let todoItem = TodoItem(documentID: String(id), userID: user, rank: rank, title: title, completed: completed)
            oncompletion(todoItem, nil)
        }
        catch {
            Log.error("There was a problem with the query: \(error)")
            oncompletion(nil, TodoCollectionError.CreationError("There was a problem with the query: \(error)"))
        }
    }
    
    public func update(documentID: String, userID: String?, title: String?, rank: Int?,
                completed: Bool?, oncompletion: @escaping (TodoItem?, Error?) -> Void ) {

        let user = userID ?? "default"

        get(withUserID: userID, withDocumentID: documentID) {
            todo, error in

            guard let todo = todo else {
                oncompletion(nil, TodoCollectionError.CreationError("There was a problem with the query: \(error)"))
                return
            }

            var queryElements = [String]()
                
            let finalTitle = title ?? todo.title
            if title != nil {
                queryElements.append( "title=\"\(finalTitle)\"" )
            }
        
            let finalOrder = rank ?? todo.rank
            if rank != nil {
                queryElements.append( "orderno=\(finalOrder)" )
            }
        
            let finalCompleted = completed ?? todo.completed
            if completed != nil {
                let completedValue = finalCompleted ? 1 : 0
                queryElements.append( "completed=\(completedValue)" )
            }
        
            let concatQuery = queryElements.joined(separator: ",")

            do {
                let query = "UPDATE todos SET \(concatQuery) WHERE rowid=\"\(documentID)\""
                _ = try self.sqlLite?.execute(query)

                let todoItem = TodoItem(documentID: String(documentID), userID: user, rank: finalOrder, title: finalTitle, completed: finalCompleted)
                oncompletion(todoItem, nil)
            }
            catch {
                Log.error("There was a problem with the MySQL query: \(error)")
                oncompletion(nil, TodoCollectionError.CreationError("There was a problem with the query: \(error)"))
            }    
        }                
    }
    
    public func delete(withUserID: String?, withDocumentID: String, oncompletion: @escaping (Error?) -> Void) {

        let user = withUserID ?? "default"
        
        do {
            let query = "DELETE FROM todos WHERE owner_id=\"\(user)\" AND rowid=\"\(withDocumentID)\""
            _ = try sqlLite?.execute(query)
            
            oncompletion(nil)
            
        }
        catch {
            Log.error("There was a problem with the query: \(error)")
            oncompletion(TodoCollectionError.IDNotFound("There was a problem with the query: \(error)"))
        }    
    }
    
    private func parseTodoItemList(results: [SQLite.Result.Row]) throws -> [TodoItem] {

        var todos = [TodoItem]()
        for row in results {
            let item = TodoItem(withDictionary: row.data)
            todos.append(item!)
        }
        return todos
    }

}

extension TodoItem {

    init?(withDictionary entry: [String: String]) {

        guard let   documentID = entry["rowid"],
                    let completed = entry["completed"],
                    let orderNo = entry["orderno"],
                    let title = entry["title"],
                    let userID = entry["owner_id"]
        else {
            Log.warning("Item did not contain all the fields")
            return nil
        }
        
        guard let iorderNo = Int(orderNo), let icompleted = Int(completed) else {
            Log.warning("Order or completed were not integers")
            return nil
        }

        let completedValue = (icompleted == 1) ? true : false

        self.documentID = documentID
        self.userID = userID
        self.rank = iorderNo
        self.title = title 
        self.completed = completedValue
    }

}
