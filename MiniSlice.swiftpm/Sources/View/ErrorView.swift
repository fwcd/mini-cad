import SwiftUI

struct ErrorView<Error>: View {
    let error: Error
    var background: Color = Color(red: 0.6, green: 0, blue: 0)
    
    var body: some View {
        Text(String(describing: error))
            .foregroundColor(.white)
            .padding(10)
            .background(background, in: RoundedRectangle(cornerRadius: ViewConstants.cornerRadius))
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: ParseError.expected(.let, actual: .init(kind: .leftParen, range: "".startIndex..<"".endIndex)))
    }
}
