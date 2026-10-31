import SwiftUI
import MapKit
import TrailMarkCore

struct JourneyDetailsView: View {
    @Environment(AppModel.self) private var model

    let journey: Journey

    private struct MemoPin: Identifiable {
        let id: UUID
        let title: String
        let symbol: String
        let coordinate: CLLocationCoordinate2D
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                map
                    .frame(height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
        }
        .navigationTitle(journey.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var memos: [MediaMemo] {
        model.media.memos.filter { memo in
            journey.memosIDs.contains(memo.id)
        }
    }

    private var pins: [MemoPin] {
        memos.compactMap { memo in
            guard let coordinate = memo.coordinate else { return nil }
            return MemoPin(
                id: memo.id,
                title: memo.type.displayName,
                symbol: memo.type.symbolName,
                coordinate: coordinate
            )
        }
    }

    private var trackCoordinates: [CLLocationCoordinate2D] {
        journey.track.coordinates
    }

    private var map: some View {
        Map(initialPosition: cameraPosition) {
            if trackCoordinates.count > 1 {
                MapPolyline(coordinates: trackCoordinates)
                    .stroke(.blue, lineWidth: 4)
            }
            ForEach(pins) { pin in
                Marker(pin.title, systemImage: pin.symbol, coordinate: pin.coordinate)
            }
        }
    }

    private var cameraPosition: MapCameraPosition {
        if let first = trackCoordinates.first {
            return .region(
                MKCoordinateRegion(
                    center: first,
                    span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                )
            )
        }
        return .automatic
    }
}
