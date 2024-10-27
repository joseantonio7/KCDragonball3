import Foundation

enum SplashState {
    case loading
    case error
    case ready
}

class SplashViewModel {
    var onStateChanged = Binding<SplashState>()
    
    func load(build:()->()) {
        onStateChanged.update(newValue: .loading)
        build()
        onStateChanged.update(newValue: .ready)
    }
}
