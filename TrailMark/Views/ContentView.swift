
import SwiftUI
import TrailMarkCore

struct ContentView: View {
    @Environment(AppModel.self) private var model
    
    var body: some View {
        NavigationStack {
            Group {
                switch model.health.authorization {

                case .unavailable:
                    ContentUnavailableView(
                        "Health data unavailable",
                        systemImage: "heart.slash",
                        description: Text(
                            "This device can't provide health data."
                        )
                    )

                case .denied:
                    ContentUnavailableView {
                        Label(
                            "Health Access Needed",
                            systemImage: "lock.fill"
                        )
                    } description: {
                        Text("Enable TrailMark access in the Health app.")
                    } actions: {
                        Button("Try again") {
                            Task {
                                await model.health.requestAuth()
                                await model.health.refreshTodaySummary()
                            }
                        }
                    }

                default:
                    summary
                }
            }
            .navigationTitle("Today's Data")
            .navigationBarTitleDisplayMode(.large)
            
            .task {
                if model.health.authorization == .unkown {
                    await model.health.requestAuth()
                }

                await model.health.refreshTodaySummary()
            }

            .refreshable {
                await model.health.refreshTodaySummary()
            }
        }
    }

    private var summary: some View {
        ScrollView {
            VStack(spacing: 16) {
                cardViewModel(
                    title: "Steps",
                    value: model.health.todaySumary.stepsText,
                    image: "figure.walk",
                    imageColor: .yellow
                )

                cardViewModel(
                    title: "Distance",
                    value: model.health.todaySumary.distanceText,
                    image: "point.topleft.down.curvedto.point.bottomright.up",
                    imageColor: .blue
                )

                cardViewModel(
                    title: "Active Energy",
                    value: model.health.todaySumary.activeEnergyKcalText,
                    image: "flame.fill",
                    imageColor: .red
                )
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
    }
}


#Preview {
    ContentView()
        .environment(AppModel())
}
