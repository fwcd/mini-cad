import SwiftUI

struct ParseErrorView: View {
    let error: ParseError
    
    var body: some View {
        Text(String(describing: error))
            .foregroundColor(.white)
            .padding(10)
            .background(Color(red: 0.6, green: 0, blue: 0))
    }
}

struct ParseErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ParseErrorView(error: ParseError.expected(.let, actual: .leftParen))
    }
}
