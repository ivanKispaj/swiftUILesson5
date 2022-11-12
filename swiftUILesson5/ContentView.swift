//
//  ContentView.swift
//  swiftUILesson5
//
//  Created by Ivan Konishchev on 11.11.2022.
//




import SwiftUI
import Combine

enum Mode {
    case camelCase
    case snakeCase
    case kebabCase
}

struct ContentView: View {
    @State var text: String = ""
    @State var modeText: String = "snake_case"
    @ObservedObject var model: Model = .init(mode: .snakeCase)
    var body: some View {
        VStack {
            TextField(modeText, text: model.$value)
                .frame(width: 100)
                .foregroundColor(.red)
                .padding(.bottom, 20)
                .textInputAutocapitalization(.never)
            Text(model.value)
                .padding(.bottom, 20)
            
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
                 Text("CaseStyle")
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

@propertyWrapper
final class CodingStyle {
    
    
    
    var mode: Mode
    private var _value: String = ""
    private var publisher: ObservableObjectPublisher
    private var changeChar: Bool = false
    private var camelUp: Bool = false
    
    init(wrappedValue: String = "" , mode: Mode = .snakeCase, publisher: ObservableObjectPublisher = .init() ) {
        self.mode = mode
        self._value = wrappedValue
        self.publisher = publisher
    }
    
    var projectedValue: Binding<String> {
        .init {
            self.wrappedValue
        } set: {
            self.wrappedValue = $0
        }
    }
    
    var wrappedValue: String {
        get {
            _value
            
        }
        set {
            
            switch mode {
                
            case .camelCase:
                _value = self.fixToCamelCase(new: newValue, old: _value)
            case .snakeCase:
                _value = self.fixToSnakeCase(new: newValue, old: _value)
            case .kebabCase:
                _value = self.fixToKebabCase(new: newValue, old: _value)
                
            }
            publisher.send()
        }
    }
    
    
    
    private func fixToCamelCase(new value: String, old: String) -> String {
        var result = value
        
        if changeChar {
            changeChar = false
            return old
        }
        guard let last = value.last,
              !value.isEmpty
        else { return "" }
        
        if let _ = old.last {
            var res = old
        
            result.removeLast()
            if camelUp {
                res.removeLast()
                res.append(contentsOf: last.uppercased())
                changeChar = true
                camelUp = false
                return res
            } else {
                if last == "_" || last == "-" {
                    camelUp = true
                }
                changeChar = true
                return value
            }
            
        } else {
            if last.isUppercase {
                result = last.lowercased()
            }
            if last == "-" {
                result = ""
            }
            if last.isLowercase {
                result = last.lowercased()
            }
        }
        changeChar = true
        return result
    }
    
    private func fixToSnakeCase(new value: String, old: String) -> String {
        var result = value
        
        if changeChar {
            changeChar = false
            return old
        }
        guard let last = value.last,
              !value.isEmpty
        else { return "" }
        
        if let previus = old.last {
            result.removeLast()
            
            if previus == "_" {
                if last.isUppercase {
                    result.append(contentsOf: last.lowercased())
                }
                if last.isLowercase {
                    result.append(contentsOf: last.lowercased())
                }
            } else {
                if last.isUppercase {
                    result.append(contentsOf: "_")
                    result.append(contentsOf: last.lowercased())
                } else if last == "-" {
                    result.append(contentsOf: "_")
                } else {
                    result.append(contentsOf: last.lowercased())
                }
                
            }
        } else {
            if last.isUppercase {
                result = last.lowercased()
            }
            if last == "-" {
                result = "_"
            }
            if last.isLowercase {
                result = last.lowercased()
            }
        }
        changeChar = true
        return result
    }
    
    private func fixToKebabCase(new value: String, old: String) -> String {
        var result = value
        
        if changeChar {
            changeChar = false
            return old
        }
        guard let last = value.last,
              !value.isEmpty
        else { return "" }
        
        if let previus = old.last {
            result.removeLast()
            
            if previus == "-" {
                if last.isUppercase {
                    result.append(contentsOf: last.lowercased())
                }
                if last.isLowercase {
                    result.append(contentsOf: last.lowercased())
                }
            } else {
                if last.isUppercase {
                    result.append(contentsOf: "-")
                    result.append(contentsOf: last.lowercased())
                } else if last == "_" {
                    result.append(contentsOf: "-")
                } else {
                    result.append(contentsOf: last.lowercased())
                }
                
            }
        } else {
            if last.isUppercase {
                result = last.lowercased()
            }
            if last == "_" {
                result = "-"
            }
            if last.isLowercase {
                result = last.lowercased()
            }
        }
        changeChar = true
        return result
    }
}


final class Model: ObservableObject {
    @CodingStyle var value: String = .init()
    init(mode: Mode) {
        _value = CodingStyle(wrappedValue: "",
                             mode: mode,
                             publisher: objectWillChange
        )
    }
    public func setMode(mode: Mode) {
        _value.mode = mode
    }
    public func getMode() -> String {
        switch _value.mode {
        case .snakeCase:
            return "snake_case"
        case .kebabCase:
            return "kebab-case"
        default: return "camelCase"
        }
    }
}
