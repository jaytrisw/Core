import Foundation
import Combine

@available(iOS 13.0, *)
public extension Repository {
    
    func readAll() -> AnyPublisher<[Model], Error> {
        return Future { promise in
            self.readAll { persistence in
                switch persistence {
                    case .success(let success):
                        promise(.success(success))
                    case .failure(let error):
                        promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
        
    }
    
    func readFirst(
        where firstWhere: @escaping (Model) throws -> Bool) rethrows -> AnyPublisher<Model?, Error> {
            return Future { promise in
                do {
                    try self.readFirst(where: firstWhere) { persistence in
                        switch persistence {
                            case .success(let success):
                                promise(.success(success))
                            case .failure(let error):
                                promise(.failure(error))
                        }
                    }
                } catch {
                    promise(.failure(error))
                }
            }
            .eraseToAnyPublisher()
            
        }
    
    func write(
        object: Model) -> AnyPublisher<Model, Error> {
            return Future { promise in
                self.write(object: object) { persistence in
                    switch persistence {
                        case .success(let success):
                            promise(.success(success))
                        case .failure(let error):
                            promise(.failure(error))
                    }
                }
            }
            .eraseToAnyPublisher()
        }
    
    func write(
        objects: [Model]) -> AnyPublisher<[Model], Error> {
            return Future { promise in
                self.write(objects: objects) { persistence in
                    switch persistence {
                        case .success(let success):
                            promise(.success(success))
                        case .failure(let error):
                            promise(.failure(error))
                    }
                }
            }
            .eraseToAnyPublisher()
        }
    
    func delete(
        object: Model)  -> AnyPublisher<Model, Error> {
            return Future { promise in
                self.delete(object: object) { persistence in
                    switch persistence {
                        case .success(let success):
                            promise(.success(success))
                        case .failure(let error):
                            promise(.failure(error))
                    }
                }
            }
            .eraseToAnyPublisher()
        }
    
    func deleteAll() -> AnyPublisher<Model.Type, Error> {
        return Future { promise in
            self.deleteAll { persistence in
                switch persistence {
                    case .success(let success):
                        promise(.success(success))
                    case .failure(let error):
                        promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
}
