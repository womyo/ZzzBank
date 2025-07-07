import SwiftUI

struct SearchBar: View {
    @ObservedObject var viewModel: MessageViewModel
    @FocusState var isFocused
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                
                TextField("Search", text: $viewModel.searchText)
                    .foregroundStyle(.primary)
                    .onSubmit {
                        viewModel.searchMessageByText()
                    }
                    .submitLabel(.search)
                    .focused($isFocused)
                    .onChange(of: isFocused) { oldValue, newValue in
                        viewModel.isSearchFocused = newValue
                    }
                
                if !viewModel.searchText.isEmpty {
                    Button {
                        viewModel.clearSearch()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                } else {
                    EmptyView()
                }
            }
            .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
            .foregroundStyle(.secondary)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10.0))

        }
        .padding(.horizontal)
    }
}
