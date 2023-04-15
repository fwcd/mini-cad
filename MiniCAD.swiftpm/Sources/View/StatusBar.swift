import SwiftUI

struct StatusBar: View {
    let text: String
    var background: Color = .accentColor
    
    var body: some View {
        Text(text)
            .foregroundColor(.white)
            .padding(10)
            .background(background, in: RoundedRectangle(cornerRadius: ViewConstants.cornerRadius))
    }
}

extension StatusBar {
    init<Error>(error: Error, background: Color = Color(red: 0.6, green: 0, blue: 0)) {
        self.init(text: String(describing: type(of: error)) + ": " + String(describing: error), background: background)
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        StatusBar(error: ParseError.unimplementedOperator(.greaterOrEqual, token: nil))
    }
}
