//
//  CircularProgressView.swift
//  CineScopeApp
//
//  Created by Semih TAKILAN on 5.05.2026.
//

import SwiftUI

struct CircularProgressView: View {
    let voteAverage: Double
    
    var progressColor: Color {
        if voteAverage >= 7.5 { return .green }
        else if voteAverage >= 5.0 { return .yellow }
        else { return .red }
    }
    
    var percentage: Double {
        return voteAverage / 10.0
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 4)
                .foregroundColor(Color.gray.opacity(0.3))
            
            Circle()
                .trim(from: 0.0, to: CGFloat(percentage))
                .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .foregroundColor(progressColor)
                .rotationEffect(Angle(degrees: -90))
            
            Text(voteAverage / 10, format: .percent.precision(.fractionLength(0)))
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(width: 40, height: 40)
        .background(Color.black.opacity(0.8))
        .clipShape(Circle())
    }
}

// Sağdaki Canvas'ta (Önizleme) görebilmen için test verisi
#Preview {
    CircularProgressView(voteAverage: 8.2)
}
