//
//  ContentView.swift
//  swiftUILesson5
//
//  Created by Ivan Konishchev on 11.11.2022.
//




import SwiftUI
import Combine



struct ContentView: View {
    @State var text: String = ""
    @State var modeText: String = "snake_case"
    @ObservedObject var model: Model = .init(mode: .snakeCase)
    var body: some View {
        VStack {
            
            TextField(modeText, text: model.$value)
                .frame(width: 300)
                .frame(minHeight: 100)
                .foregroundColor(.red)
                .padding(.bottom, 20)
                .textInputAutocapitalization(.never)

            Menu {
                Button {
                    model.setMode(mode: .camelCase)
                    modeText = model.getMode()
                    text = ""
                } label: {
                    Text("camelCase")
                }
                Button {
                    model.setMode(mode: .snakeCase)
                    modeText = model.getMode()

                    text = ""

                } label: {
                    Text("snake_case")
                }
                Button {
                    model.setMode(mode: .kebabCase)
                    modeText = model.getMode()

                    text = ""

                } label: {
                    Text("kebab-case")
                }
            } label: {
                 Text(modeText)
            }
            .padding(10)
            .border(.gray,width: 1)
            .cornerRadius(4)
            .background(Color.gray.opacity(0.2))

        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

