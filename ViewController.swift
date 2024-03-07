import UIKit

final class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        execute()
    }
    
    private func execute() {
        let colorPicker = ActorReentrancy()
        //some unstructured way
        Task {
            await colorPicker.pickup(color: .blue)
        }
        
        Task {
            await colorPicker.pickup(color: .blue)
        }
    }
}

actor ActorReentrancy {
    
    enum Colors {
        case red, green, blue
    }
    
    private var colors: [Colors] = [.blue, .green, .red]
    
    private func canPick(color: Colors) -> Bool {
        return colors.contains(color)
    }
    
    func pickup(color: Colors) async {
        guard canPick(color: color) else {
            return
        }
        
        guard await confirmPick() else {
            return
        }
        
        //After some await operations, please again check the logic.
        
        guard canPick(color: color) else {
            print("\(color) is not available")
            return
        }
        
        colors = colors.filter( { $0 != color } )
    }
    
    private func confirmPick() async -> Bool {
        //Task.sleep not Thread.sleep
        try? await Task.sleep(for: .seconds(1))
        return true
    }
}
