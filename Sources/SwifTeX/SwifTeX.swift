import SwiftUI

enum CharType {
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
}

enum Token {
    case char(CharType, Character)
    case control(String)
}

indirect enum BoxContents {
    case Box(Box)
    case Char(CGGlyph)
}

struct Box {
    let height: Int
    let width: Int
    let depth: Int
    let contents: BoxContents
}

struct Glue {
    let space: Int
    let strech: Int
    let shrink: Int
}

enum Mode {
    case Vertical
    case InternalVertical
    case Horizontal
    case RestrictedHorizontal
    case Math
}

struct TeX: View {
    
    var toks: [Token] = []
    init(_ latex: String) {
        let latex_array = Array(latex)
        var cur = 0
        while cur < latex.count {
            let char = latex_array[cur]
            switch char {
            case "\\":
                 self.toks.append(Token.char(CharType.Escape, char))
            case "{":
                self.toks.append(Token.char(CharType.GroupStart, char))
            case "}":
                self.toks.append(Token.char(CharType.GroupEnd, char))
            case "$":
                self.toks.append(Token.char(CharType.MathShift, char))
            case "^":
                self.toks.append(Token.char(CharType.Superscript, char))
            case "_":
                self.toks.append(Token.char(CharType.Subscript, char))
            case " ":
                self.toks.append(Token.char(CharType.Space, char))
            case Character("A")...Character("Z"):
                self.toks.append(Token.char(CharType.Space, char))
            case Character("a")...Character("z"):
                self.toks.append(Token.char(CharType.Space, char))
            case "~":
                self.toks.append(Token.char(CharType.ActiveChar, char))
            case "%":
                self.toks.append(Token.char(CharType.CommentChar, char))
            default:
                self.toks.append(Token.char(CharType.OtherChar, char))
            }
            cur += 1
        }
    }
    
    var body: some View {
        Text(toks.description)
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
