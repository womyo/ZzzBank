import SwiftUI

struct DreamonBattleView: View {
    @ObservedObject var viewModel: DreamonViewModel
    @State private var battleTask: Task<Void, Never>?
    @State private var showAlert = false
    
    var body: some View {
        ZStack {
            VStack {
                DreamonImageView(
                    dreamon: viewModel.enemyDreamon ?? Dreamon.placeholder,
                    hp: viewModel.enemyHp,
                    damage: viewModel.damage,
                    showDamage: viewModel.showDamage
                )
                .opacity(viewModel.enemyDreamon == nil ? 0 : 1)
                
                Button {
                    if viewModel.hp == 0 {
                        showAlert = true
                    } else {
                        battleTask = Task {
                            await viewModel.battle()
                        }
                    }
                } label: {}
                    .frame(width: 240, height: 70)
                    .buttonStyle(HarmonicStyle(viewModel: viewModel))
                    .disabled(viewModel.isInBattle)
                
                DreamonImageView(
                    dreamon: viewModel.dreamon ?? Dreamon.placeholder,
                    hp: viewModel.hp,
                    damage: viewModel.enemyDamage,
                    showDamage: viewModel.showEnemyDamage
                )
                .opacity(viewModel.dreamon == nil ? 0 : 1)
                
                if let dreamon = viewModel.dreamon {
                    if viewModel.hp == 0 {
                        if viewModel.didUsePass {
                            Button {
                                viewModel.dreamonList[viewModel.selectedIndex].hp = 0
                                viewModel.isSheetPresented = true
                            } label: {
                                Text("Select Next")
                                    .foregroundStyle(.main)
                            }
                        } else {
                            Button {
                                viewModel.hp = dreamon.hp
                                viewModel.didUsePass = true
                            } label: {
                                Text("Soul Ember")
                                    .foregroundStyle(.main)
                            }
                        }
                    }
                }
            }
            .task {
                viewModel.enemyDreamon = nil
                viewModel.showBattleResult = false
                
                await viewModel.getDreamonList()
                viewModel.hp = viewModel.dreamon!.hp
            }
            .onDisappear {
                battleTask?.cancel()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Unable to Battle"))
            }
            
            if viewModel.isLoadingForBattleResult {
                ZStack {
                    Color.black.opacity(0.65)
                        .ignoresSafeArea()
                        .allowsHitTesting(true)
                    
                    ProgressView("Analyzing...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .foregroundColor(.white)
                        .padding()
                }
            } else if viewModel.showBattleResult {
                ZStack {
                    Color.black.opacity(0.65)
                        .ignoresSafeArea()
                    
                    Text(viewModel.battleResultText)
                        .font(.system(size: 18))
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.ultraThinMaterial)
                        )
                        .padding(.horizontal, 40)
                }
                .onTapGesture {
                    viewModel.showBattleResult = false
                }
            }
        }
        .sheet(isPresented: $viewModel.isSheetPresented) {
            DreamonSheetView(viewModel: viewModel)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.customBackground)
    }
}
