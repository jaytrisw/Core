import Foundation

public extension Repository {
    
    static func inMemory(storage: [Model] = []) -> Self {
        
        var mutableStorage = storage
        
        return Repository(
            readAll: {
                return .success(mutableStorage)
            },
            readFirst: { firstWhere in
                let item = try? mutableStorage.first(where: firstWhere)
                
                return .success(item)
            },
            writeModel: { model in
                mutableStorage.append(model)
                
                return .success(model)
            },
            writeModels: { models in
                mutableStorage.append(contentsOf: models)
                
                return .success(models)
            },
            delete: { model in
                if let index = mutableStorage.firstIndex(of: model) {
                    mutableStorage.remove(at: index)
                }
                
                return .success(model)
            },
            deleteAll: {
                mutableStorage = []
                
                return .success(Model.self)
            })
        
        
    }
    
}
