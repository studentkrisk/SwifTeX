import SwiftUI

enum CharTypes {
    case Escape
    case GroupStart
    case GroupEnd
    case MathShift
    case Parameter
    case Superscript
    case Subscript
    case Space
    case Letter
    case OtherChar
    case ActiveChar
    case CommentChar
    case InvalidChar
}

enum Token {
    case char(CharTypes, Character)
    case control(String)
}

struct TeX: View {
    
    let toks: [Token]
    init(_ latex: String) {
        let latex_array = Array(latex)
        var cur = 0
        while cur < latex.count {
            let char = latex_array[cur]
            switch char {
            case "\\":
                self.toks.append(Token.char(CharTypes.Escape, char))
            case "{":
                self.toks.append(Token.char(CharTypes.GroupStart, char))
            case "}":
                self.toks.append(Token.char(CharTypes.GroupEnd, char))
            case "$":
                self.toks.append(Token.char(CharTypes.MathShift, char))
            case "^":
                self.toks.append(Token.char(CharTypes.Superscript, char))
            case "_":
                self.toks.append(Token.char(CharTypes.Subscript, char))
            case " ":
                self.toks.append(Token.char(CharTypes.Space, char))
            case Character("a"):
                self.toks.append(Token.char(CharTypes.Space, char))
            default:
                print("a")
            }
            cur += 1
        }
    }
    
    var body: some View {
        Text(toks)
    }
}

struct Example: View {
    
    var body: some View {
        List {
            TeX(#"te{st}"#)
            TeX(#"test"#)
        }
    }
}
#Preview {
    Example()
}
