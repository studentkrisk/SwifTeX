import SwiftUI

struct TeX: View {
    let latex: String
    init(_ latex: String) {
        self.latex = latex
    }
    
    var body: some View {
        Text(latex)
    }
}

struct Example: View {
    
    var body: some View {
        
    }
}
#Preview {
    Example()
}
