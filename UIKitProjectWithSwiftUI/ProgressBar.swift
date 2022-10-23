import SwiftUI
import Combine

struct ProgressBar: View {
    @ObservedObject var vm: ProgressBarViewModel
    var hideSub = PassthroughSubject<Void, Never>()

    var maxWidth: Double {
        return min(Double(vm.progress), vm.containerWidth)
    }

    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                GeometryReader { geo in
                    RoundedRectangle(cornerRadius: 60)
                        .foregroundColor(.clear)
                        .onAppear {
                            vm.containerWidth = geo.size.width
                        }
                }
                RoundedRectangle(cornerRadius: 60)
                    .stroke(Color("BorderColor"), lineWidth: 1)

                ZStack(alignment: .trailing) {
                    RoundedRectangle(cornerRadius: 60)
                        .fill(Color("ProgressColor"))

                    Text("\(vm.progressTitle)")
                        .monospaced()
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
                        .background(
                            RoundedRectangle(cornerRadius: 60)
                                .fill(Color("CircleColor"))
                        )
                }
                .padding(2)
                .frame(minWidth: maxWidth)
                .fixedSize()
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(20)
            .onAppear {
                vm.progressTitle = "\(vm.progress)%"
            }

            Button("Hide") {
                hideSub.send()
            }
            .tint(Color("CircleColor"))
        }

    }

    func start() {
        print("containerWidth: \(vm.containerWidth)")
        vm.progress = 0

        Task {
            for i in 1 ... 100 {
                try await Task.sleep(until: .now.advanced(by: .milliseconds(30)), clock: .continuous)
                vm.progressTitle = "\(i)%"
                withAnimation {
                    vm.progress = Int(Double(vm.containerWidth) / 100 * Double(i))
                }
            }
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(vm: ProgressBarViewModel())
    }
}
