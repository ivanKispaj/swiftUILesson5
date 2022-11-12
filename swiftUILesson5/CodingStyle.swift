//
//  CodingStyle.swift
//  swiftUILesson5
//
//  Created by Ivan Konishchev on 12.11.2022.
//

import Foundation
import SwiftUI
import Combine

enum Mode {
    case camelCase
    case snakeCase
    case kebabCase
}

//MARK:  propertyWrapper  CodingStyle
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
    
    
    //MARK:   Фикс для camelCase
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
                if last == "_" || last == "-" || last == " "  {
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
    
    //MARK:   Фикс для snake_case
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
                } else if last == "-" || last == " " {
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
    
    //MARK:   Фикс для kebab-case
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
                } else if last == "_" || last == " "  {
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

//MARK: обертка для отслеживания обновления
final class Model: ObservableObject {
    @CodingStyle var value: String = .init()
    init(mode: Mode) {
        _value = CodingStyle(wrappedValue: "",
                             mode: mode,
                             publisher: objectWillChange
        )
    }
    
    //MARK: метод для смены режима редактирования
    public func setMode(mode: Mode) {
        _value.mode = mode
    }
    //MARK: Метод возвращает текстовый вид типа ввода
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

