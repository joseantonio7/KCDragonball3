import Foundation

enum TransformationsListState: Equatable {
    case loading
    case error(reason: String)
    case success
}

final class TransformationsListViewModel {
    let onStateChanged = Binding<TransformationsListState>()
    private(set) var transformations: [Transformation] = []
    private let useCase: GetTransformationsUseCaseContract
    private let identifier: String
    
    init(identifier: String, useCase: GetTransformationsUseCase) {
        self.useCase = useCase
        self.identifier = identifier
    }
    
    func load() {
        onStateChanged.update(newValue: .loading)
        useCase.execute(identifier: identifier) { [weak self] result in
            do {
                self?.transformations = try result.get()
                self?.onStateChanged.update(newValue: .success)
            } catch {
                self?.onStateChanged.update(newValue: .error(reason: error.localizedDescription))
            }
        }
    }
}
