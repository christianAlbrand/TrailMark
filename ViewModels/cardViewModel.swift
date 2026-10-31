//
//  cardViewModel.swift
//  TrailMark
//
//  Created by Christian-SDGKU on 14/10/26.
//

import SwiftUI


struct cardViewModel: View {
    let title: String
    let value: String
    let image: String
    let imageColor: Color
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: image)
                .font(.title)
                .foregroundStyle(imageColor)
            
            VStack {
                Text(title)
                    .foregroundStyle(.gray)
                Text(value)
                    .font(.title)
                    .bold()
            }
            
            Spacer()
        }
        .padding(30)
        .frame(width: 350, height: 110)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(20)
    }
}

#Preview {
    cardViewModel( title: "sample", value: "100m", image: "person", imageColor: .blue)
}
