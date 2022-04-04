import Foundation

public struct Repository<Model: Persistable> {
    
    public var readAll: () -> Result<[Model], Error>
    public var readFirst: (@escaping (Model) throws -> Bool) -> Result<Model?, Error>
    public var write: (Model) -> Result<Model, Error>
    public var writeModels: ([Model]) -> Result<[Model], Error>
    public var delete: (Model) -> Result<Model, Error>
    public var deleteAll: () -> Result<Model.Type, Error>
    
    public init(
        readAll: @escaping () -> Result<[Model], Error>,
        readFirst: @escaping (@escaping (Model) throws -> Bool) -> Result<Model?, Error>,
        write: @escaping (Model) -> Result<Model, Error>,
        writeModels: @escaping ([Model]) -> Result<[Model], Error>,
        delete: @escaping (Model) -> Result<Model, Error>,
        deleteAll: @escaping () -> Result<Model.Type, Error>) {
            self.readAll = readAll
            self.readFirst = readFirst
            self.write = write
            self.writeModels = writeModels
            self.delete = delete
            self.deleteAll = deleteAll
        }
    
}
