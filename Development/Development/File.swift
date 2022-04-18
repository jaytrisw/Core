import Foundation
import CoreData
import Core
import RxSwift

public extension Repository where Model == Item {
    
    static var itemRepository: Repository<Item> {
        return .coreData(
            dataModel: .main,
            fetchRequest: CDItem.fetchRequest())
    }
    
}

extension Repository {
    
    struct Reactive<Model: Persistable> {
        
        private let repository: Repository<Model>
        
        fileprivate init(_ repository: Repository<Model>) {
            self.repository = repository
        }
        
    }
    
    var rx: Repository.Reactive<Model> {
        get { return Reactive(self) }
    }
    
}

extension Repository.Reactive {
    
    func readAll() -> Observable<[Model]> {
        return self.repository
            .readAll()
            .toObservable()
        
    }
    
    func readFirst(
        where firstWhere: @escaping (Model) throws -> Bool) rethrows -> Observable<Model?> {
            return self.repository
                .readFirst(firstWhere)
                .toObservable()
            
        }
    
    func writeModel(
        model: Model) -> Observable<Model> {
            return self.repository
                .writeModel(model)
                .toObservable()
        }
    
    func writeModels(
        models: [Model]) -> Observable<[Model]> {
            return self.repository
                .writeModels(models)
                .toObservable()
        }
    
    func delete(
        object: Model)  -> Observable<Model> {
            return self.repository
                .delete(object)
                .toObservable()
        }
    
    func deleteAll() -> Observable<Model.Type> {
        return self.repository
            .deleteAll()
            .toObservable()
    }
    
}

extension Result {
    
    func toObservable() -> Observable<Success> {
        Observable.create { observer in
            switch self {
                case .success(let success):
                    observer.onNext(success)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
            }
            
            return Disposables.create {}
        }
    }
    
}
