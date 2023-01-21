import SwiftUI

struct ParseErrorView: View {
    let error: ParseError
    
    var body: some View {
        Text(String(describing: error))
    }
}

struct ParseErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ParseErrorView(error: ParseError.expected(.let, actual: .leftParen))
    }
}
