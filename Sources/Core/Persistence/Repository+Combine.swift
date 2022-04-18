import Foundation
import Combine

@available(iOS 13.0, *)
public extension Repository {
    
    struct Publisher<Model: Persistable> {
        
        private let repository: Repository<Model>
        
        fileprivate init(_ repository: Repository<Model>) {
            self.repository = repository
        }
        
    }
    
    var publisher: Repository.Publisher<Model> {
        get { Repository.Publisher(self) }
    }
    
}

@available(iOS 13.0, *)
public extension Repository.Publisher {
    
    func readAll() -> AnyPublisher<[Model], Error> {
        return self.repository
            .readAll()
            .toFuture()
            .eraseToAnyPublisher()
        
    }
    
    func readFirst(
        where firstWhere: @escaping (Model) throws -> Bool) rethrows -> AnyPublisher<Model?, Error> {
            return self.repository
                .readFirst(firstWhere)
                .toFuture()
                .eraseToAnyPublisher()
            
        }
    
    func writeModel(
        model: Model) -> AnyPublisher<Model, Error> {
            return self.repository
                .writeModel(model)
                .toFuture()
                .eraseToAnyPublisher()
        }
    
    func writeModels(
        models: [Model]) -> AnyPublisher<[Model], Error> {
            return self.repository
                .writeModels(models)
                .toFuture()
                .eraseToAnyPublisher()
        }
    
    func delete(
        object: Model)  -> AnyPublisher<Model, Error> {
            return self.repository
                .delete(object)
                .toFuture()
                .eraseToAnyPublisher()
        }
    
    func deleteAll() -> AnyPublisher<Model.Type, Error> {
        return self.repository
            .deleteAll()
            .toFuture()
            .eraseToAnyPublisher()
    }
    
}

@available(iOS 13.0, *)
extension Result {
    
    func toFuture() -> Future<Success, Error> {
        return Future { promise in
            switch self {
                case .success(let success):
                    promise(.success(success))
                case .failure(let error):
                    promise(.failure(error))
            }
        }
    }
    
}
