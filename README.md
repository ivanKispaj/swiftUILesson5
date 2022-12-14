# swiftUILesson5

## Описание

Эта программа меняет формат ввода в зависимости от выбранного режима
### Menu выбора состоит 

> Что соответствует kebab-case

Все это выполняется на лету.

```
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
                }
    }
}
```

## Что необходимо для использоввания:
            
