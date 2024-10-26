import Foundation

protocol GetTransformationsUseCaseContract {
    func execute(identifier: String, completion: @escaping (Result<[Transformation], Error>) -> Void)
}

final class GetTransformationsUseCase: GetTransformationsUseCaseContract {
    func execute(identifier: String, completion: @escaping (Result<[Transformation], any Error>) -> Void) {
        GetHeroTransformationsAPIRequest(identifier: identifier)
            .perform { result in
                do {
                    try completion(.success(result.get()))
                } catch {
                    completion(.failure(error))
                }
            }
    }
}

