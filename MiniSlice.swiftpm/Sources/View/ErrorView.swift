import SwiftUI

struct ErrorView<Error>: View {
    let error: Error
    
    var body: some View {
        Text(String(describing: error))
            .foregroundColor(.white)
            .padding(10)
            .background(Color(red: 0.6, green: 0, blue: 0))
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: ParseError.expected(.let, actual: .leftParen))
    }
}
