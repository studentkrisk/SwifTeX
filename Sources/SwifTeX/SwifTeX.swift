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
    case InternalVertical
    case Horizontal
    case RestrictedHorizontal
    case Math
}

struct TeX: View {
    
    init(_ latex: String) {
        let latex_array = Array(latex)
        var cur = 0
        var toks: [Token] = []
        while cur < latex.count {
            let char = latex_array[cur]
            switch char {
            case "\\":
                cur += 1
                var toAdd = ""
                while cur < latex_array.count && latex_array[cur] != " " {
                    toAdd.append(latex_array[cur])
                    cur += 1
                }
                toks.append(Token.control(toAdd))
            case "{":
                toks.append(Token.char(CharType.GroupStart, char))
            case "}":
                toks.append(Token.char(CharType.GroupEnd, char))
            case "$":
                toks.append(Token.char(CharType.MathShift, char))
            case "^":
                toks.append(Token.char(CharType.Superscript, char))
            case "_":
                toks.append(Token.char(CharType.Subscript, char))
            case " ":
                toks.append(Token.char(CharType.Space, char))
            case Character("A")...Character("Z"):
                toks.append(Token.char(CharType.Space, char))
            case Character("a")...Character("z"):
                toks.append(Token.char(CharType.Space, char))
            case "~":
                toks.append(Token.char(CharType.ActiveChar, char))
            case "%":
                toks.append(Token.char(CharType.CommentChar, char))
            default:
                toks.append(Token.char(CharType.OtherChar, char))
            }
            cur += 1
        }
    }
    
    var body: some View {
        Canvas {context, size in
            if let font = CTFontCreateUIFontForLanguage(.system, 30, nil) {
                let ctline = CTLineCreateWithAttributedString(CFAttributedStringCreate(nil, "a" as CFString, CTFontCopyTraits(font)))
                let ctrun = unsafeBitCast(CFArrayGetValueAtIndex(CTLineGetGlyphRuns(ctline), 0)!, to: CTRun.self)
                context.withCGContext(content: {(ctx: CGContext) -> Void in
                    CTFontDrawGlyphs(font, CTRunGetGlyphsPtr(ctrun)!, CTRunGetPositionsPtr(ctrun)!, CTRunGetGlyphCount(ctrun), ctx)
                })
            }
        }
    }
}

struct Example: View {
    
    var body: some View {
        List {
            TeX("te{st} \\test")
            TeX("test")
        }
    }
}
#Preview {
    Example()
}
