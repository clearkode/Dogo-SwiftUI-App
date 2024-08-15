//
//  DropDown.swift
//  DogoSwiftUITestApp
//
//  Created by Dev on 06/06/2024.
//

import SwiftUI

struct DropDownView: View {
    @Binding var selection: String?
    @Binding var isExpanded: Bool
    @Binding var iconName: String
    @Binding var dropDownPlaceholder: String
    @Binding var maxWidth: CGFloat
    @Binding var time: Bool
    var options: [String]
        
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: {
                        withAnimation {
                            self.isExpanded.toggle()
                        }
                    }) {
                        HStack {
                            Image(systemName: iconName)
                                .resizable()
                                .frame(width: 32, height: 32)
                                .foregroundColor(Color("menuShadowColor"))
                            Spacer()
                            Text(selection ?? dropDownPlaceholder)
                                .font(Font.custom("Verdana-Regular", size: 14))
                                .foregroundColor(Color("textfieldColor1"))
                            Spacer()
                            Image(systemName: "chevron.down")
                                .font(.title3)
                                .foregroundColor(Color("textfieldColor1"))
                                .rotationEffect(.degrees(isExpanded ? 180 : 0))
                                .animation(.easeInOut(duration: 0.2))
                        }
                        .frame(maxWidth: maxWidth)
                        .frame(height: 40)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 5)
                        .background(Color("white"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("textfieldColor1"), lineWidth: 1)
                        )
                    }
                }
                .zIndex(1)
                
                if isExpanded {
                    GeometryReader { geometry in
                        ScrollView {
                            VStack {
                                ForEach(options, id: \.self) { option in
                                    Button(action: {
                                        self.selection = option
                                        withAnimation {
                                            self.isExpanded.toggle()
                                        }
                                    }) {
                                        Text(option)
                                            .padding(10)
                                            .frame(width: geometry.size.width, alignment: .leading)
                                            .foregroundColor(Color("textfieldColor1"))
                                    }
                                    .background(Color("white"))
                                    
                                    Divider()
                                        .frame(height: 1)
                                        .overlay(Color("menuShadowColor"))
                                }
                            }
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("textfieldColor1"), lineWidth: 1)
                            )
                            .padding(.vertical, 4)
                        }
                        .background(Color.white)
                        .frame(height: 125)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .position(x: maxWidth / 2, y: maxWidth > 172 ? 5 : 0)
                    .padding(.leading, maxWidth > 172 ? 10 : 5)
                    .padding(.trailing, maxWidth > 172 ? -10 : -5)
                    .zIndex(0)
                }
                
                Spacer()
            }
            .padding()
        }
    }
}


#Preview {
    DropDownView(selection: .constant(nil), isExpanded: .constant(true), iconName: .constant("clock.circle"), dropDownPlaceholder: .constant("10:00"), maxWidth: .constant(170), time: .constant(true), options: ["option1", "option2"])
}
