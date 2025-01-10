//
//  BreathingView.swift
//  BreathControl
//
//  Created by Panagiotis Theodosiadis on 8/1/25.
//

import SwiftUI
import CoreHaptics

struct BreathingView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var selectedTime: Int = 1
    @State private var breathingMode: BreathingModeEnum = .boxBreathing
    
    @State var engine: CHHapticEngine?
    
    @State var title: String = "Breath Control"
    
    @State private var startExercise: Bool = false
    
    let breathingModes: [BreathingModeEnum] = BreathingModeEnum.allCases
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Spacer()
                
                Text(title)
                    .font(.custom("Noteworthy-Bold", size: 40))
                    .foregroundColor(colorScheme == .dark ? Color.white : Color(hex: "#75caf7"))
                
                Spacer()
            }
            
            HStack {
                Spacer()
                
                Image("flower")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .background((colorScheme == .dark ? Color(hex: "#020116") : Color.white))
                
                Spacer()
            }
            
            Spacer()
            
            Text("Breathing Mode")
                .font(.custom("Noteworthy-Bold", size: 24))
                .foregroundColor(colorScheme == .dark ? Color.white : Color(hex: "#75caf7"))
            
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(breathingModes, id: \.self) { mode in
                            Text(mode.rawValue)
                                .font(.custom("Noteworthy-Light", size: 16))
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .foregroundColor(breathingMode == mode ? .primary : .gray)
                                .overlay(
                                    Capsule()
                                        .stroke((breathingMode == mode ? Color(hex: "#75caf7") : Color.gray.opacity(0.5)),
                                                lineWidth: 1.5)
                                )
                                .onTapGesture {
                                    withAnimation {
                                        breathingMode = mode
                                        proxy.scrollTo(mode, anchor: .center)
                                    }
                                }
                                .id(mode)
                        }
                    }
                    .padding(.vertical)
                    .padding(.horizontal, 1)
                }
            }
            .padding(.top, -16)
            
            Text("Time")
                .font(.custom("Noteworthy-Bold", size: 24))
                .foregroundColor(colorScheme == .dark ? Color.white : Color(hex: "#75caf7"))
            
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(1...10, id: \.self) { time in
                            Text("\(time) min")
                                .font(.custom("Noteworthy-Light", size: 16))
                                .foregroundColor(time == selectedTime ? .primary : .gray)
                                .onTapGesture {
                                    withAnimation {
                                        selectedTime = time
                                        proxy.scrollTo(time, anchor: .center)
                                    }
                                }
                                .id(time)
                        }
                    }
                }
            }
            .padding(.top, -4)
            
            Spacer()
            
            Button(action: {
                startExercise = true
            }) {
                Text("Start Breathing")
                    .font(.custom("Noteworthy-Bold", size: 24))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color(hex: "#75caf7"))
                    .clipShape(Capsule())
            }
            .fullScreenCover(isPresented: $startExercise, content: {
               ExerciseView(hapticManager: HapticManager(breathingMode: breathingMode, totalDuration: selectedTime))
            })

        }
        .padding(.all, 24)
        
    }
}

#Preview {
    BreathingView()
}
