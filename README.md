# swiftUILesson5

## Описание

Эта программа меняет формат ввода в зависимости от выбранного режима
### Menu выбора состоит 
**camelCase**

**snake_case**

**kebab-case**

### camelCase -> 
Если вводится знаки "_","-"," ", то при вводе следующей буквы она станет заглавной а введенный знак убирается
> Что соответствует camalCase

### snake_case ->
Если вводится заглавная буква, то она меняется на прописную и перед ней вставляется знак "_", если вводится "-" или " " то он меняется на знак подчеркивания.
> Что соответствует snake_case

### kebab-case ->
Заглавные буквы, знак подчеркивания и пробел меняются на знак "-".
=======
*** camelCase ***
*** snake_case ***
*** kebab-case ***

### camelCase -> 
Если вводится знак `_` или `-` то при вводе следующей буквы она станет заглавной а введенный знак убирается
> Что соответствует camalCase

### snake_case ->
Если вводится заглавная буква, то она меняется на прописную и перед ней вставляется знак `_`, если вводится `-` то он меняется на знак подчеркивания.
> Что соответствует snake_case

### kebab-case ->
Заглавные буквы и знак подчеркивания меняются на знак `-`.

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

1. Скопировать код файла "CodingStyle" в свой проект.
2. В вашем View добавить и проинициализироватть : @ObservedObject var model: Model = .init(mode: .snakeCase)
3. В TexField в поле binding cсылки указать -> model.$value
