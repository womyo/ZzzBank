import SwiftUI

struct MessageRow: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isFromUser {
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
            }
            
            Text(message.body)
                .padding()
                .background(message.isFromUser ? .main : .cell)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            
            if !message.isFromUser {
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
            }
        }
        .padding([.horizontal, .top])
    }
}
