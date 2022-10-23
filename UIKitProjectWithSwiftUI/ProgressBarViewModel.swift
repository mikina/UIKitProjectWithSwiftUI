import Foundation

class ProgressBarViewModel: ObservableObject {
    @Published var containerWidth: CGFloat = 0
    @Published var progressTitle: String = ""
    @Published var progress: Int = 0
}
