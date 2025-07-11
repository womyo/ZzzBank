import SwiftUI

struct DreamonSheetView: View {
    @ObservedObject var viewModel: DreamonViewModel
    @State private var hasAppeared = false
    @State var showAlert = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(Array(viewModel.dreamonList.enumerated()), id: \.element.id) { index, dreamon in
                    Button {
                        if dreamon.hp == 0 {
                            showAlert = true
                        } else {
                            viewModel.dreamon = dreamon
                            viewModel.hp = dreamon.hp
                            viewModel.selectedIndex = index
                            viewModel.didUsePass = false
                            viewModel.isSheetPresented = false
                        }
                    } label: {
                        DreamonImageView(dreamon: dreamon, hp: dreamon.hp, showDamage: false)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(title: Text("You can't send a fainted Dreamon into battle!"))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.customBackground)
    }
}
