//
//  SplashView.swift
//  BreathControl
//
//  Created by Panagiotis Theodosiadis on 7/1/25.
//

import SwiftUI

struct SplashView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var scale: CGFloat = 0.1
    @State var routingEnum: RoutingEnum = .splash
    
    var body: some View {
        ZStack {
            
            (colorScheme == .dark ? Color(hex: "#020116") : Color.white)
                .ignoresSafeArea()

            switch routingEnum {
            case .main:
                BreathingView()
            case .splash:
                VStack() {
                    
                    Spacer()
                    
                    LottieView(animationFileName: "lottie_flower", loopMode: .playOnce)
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        
                    Spacer()
                    
                    Text("Breath Control")
                        .font(.custom("Noteworthy-Bold", size: 40))
                        .shadow(radius: (colorScheme == .dark ? 1 : 0))
                        .foregroundColor(colorScheme == .dark ? Color.white : Color(hex: "#75caf7"))
                        .scaleEffect(scale)
                        .padding(.bottom, 32)
                    
                }
                .padding()
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        scale = 1.0
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                withAnimation {
                    self.routingEnum = .main
                }
            }
        }
        
    }
}

extension SplashView {
    enum RoutingEnum {
        case splash
        case main
    }
}

#Preview {
    SplashView()
}
