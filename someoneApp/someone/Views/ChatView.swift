//
//  ChatView.swift
//  someone
//
//  Created by Christina Riabokon on 11/9/21.
//

import SwiftUI
import Combine
import Foundation


struct ChatView: View {
    @ObservedObject var viewModel: MessageViewModel
    @State var text = ""
    
    var body: some View {
        VStack(spacing:5) {
            Section {
                Text("SOMEONE").frame(minWidth: 0, maxWidth: 400, minHeight: 20).padding(10).background(Color(hexString: "#81b29a")).font(Font.headline.weight(.bold))
                //Rectangle().fill(Color.black).frame(maxWidth: 100, maxHeight: 2, alignment: .center).padding(.top, -7)
            }
            Spacer().frame(height:5).background(Color.clear)
            ScrollViewReader { scrollView in
                ScrollView() {
                    LazyVStack {
                            ForEach(viewModel.messages) { message in
                                HStack {
                                    if message.isUser {
                                        Spacer().frame(width: 10)
                                        MessageView(message: message)
                                        Spacer()
                                    } else {
                                        Spacer()
                                        MessageView(message: message)
                                        Spacer().frame(width: 10)
                                    }
                                }
                            }
                    }.frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
                .onAppear {
                    if viewModel.messages.count >= 1 {
                        scrollView.scrollTo(viewModel.messages[viewModel.messages.endIndex - 1])
                    }
                    
                }
            }
            HStack {
                MultilineTextField("Message.." ,text: $text)
                    .frame(minHeight: CGFloat(15), alignment: .bottomLeading)
                    .background(Color.white)
                    .foregroundColor(Color.black)
                    .cornerRadius(15)
                /*
                TextField("Message", text: $text)
                    .frame(minHeight: CGFloat(30), alignment: .bottomLeading)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minHeight: CGFloat(30))
                */
                Button("Send") {
                    let message = text.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
                    text = ""
                    viewModel.messages.append(Message(text:message, isUser:true))
                    viewModel.getMessageResponse(text:message, addMessage: false)
                }.padding()
                .background(Color(hexString: "#f2cc8f"))
                .foregroundColor(.black)
                .frame(maxHeight:40)
                .cornerRadius(15)
            }.frame(minHeight: CGFloat(50), alignment: .bottom).padding().background(Color(hexString: "#81b29a"))
        }.background(Color(hexString: "#f4f1de"))
        
    }
}

struct MessageView: View {

    var message:Message
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 15) {
        Text(message.text)
            .padding(10)
            .foregroundColor(message.isUser ? Color.black : Color.white)
            .background(message.isUser ? Color(hexString: "#e07a5f") : Color(hexString: "#3d405b"))
            .cornerRadius(10)
        }
    }
}

struct MultilineTextField: View {

    private var placeholder: String
    private var onCommit: (() -> Void)?

    @Binding private var text: String
    private var internalText: Binding<String> {
        Binding<String>(get: { self.text } ) {
            self.text = $0
            self.showingPlaceholder = $0.isEmpty
        }
    }

    @State private var dynamicHeight: CGFloat = 100
    @State private var showingPlaceholder = false

    init (_ placeholder: String = "", text: Binding<String>, onCommit: (() -> Void)? = nil) {
        self.placeholder = placeholder
        self.onCommit = onCommit
        self._text = text
        self._showingPlaceholder = State<Bool>(initialValue: self.text.isEmpty)
    }

    var body: some View {
        UITextViewWrapper(text: self.internalText, calculatedHeight: $dynamicHeight, onDone: onCommit)
            .frame(minHeight: dynamicHeight, maxHeight: dynamicHeight)
            .background(placeholderView, alignment: .topLeading)
    }

    var placeholderView: some View {
        Group {
            if showingPlaceholder {
                Text(placeholder).foregroundColor(.gray)
                    .padding(.leading, 4)
                    .padding(.top, 8)
            }
        }
    }
}

// Credit to https://stackoverflow.com/questions/56471973/how-do-i-create-a-multiline-textfield-in-swiftui
import UIKit

fileprivate struct UITextViewWrapper: UIViewRepresentable {
    typealias UIViewType = UITextView

    @Binding var text: String
    @Binding var calculatedHeight: CGFloat
    var onDone: (() -> Void)?

    func makeUIView(context: UIViewRepresentableContext<UITextViewWrapper>) -> UITextView {
        let textField = UITextView()
        textField.delegate = context.coordinator

        textField.isEditable = true
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.isSelectable = true
        textField.isUserInteractionEnabled = true
        textField.isScrollEnabled = false
        textField.backgroundColor = UIColor.clear
        if nil != onDone {
            textField.returnKeyType = .done
        }

        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
    }

    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<UITextViewWrapper>) {
        if uiView.text != self.text {
            uiView.text = self.text
        }
        if uiView.window != nil, !uiView.isFirstResponder {
            uiView.becomeFirstResponder()
        }
        UITextViewWrapper.recalculateHeight(view: uiView, result: $calculatedHeight)
    }

    fileprivate static func recalculateHeight(view: UIView, result: Binding<CGFloat>) {
        let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if result.wrappedValue != newSize.height {
            DispatchQueue.main.async {
                result.wrappedValue = newSize.height // !! must be called asynchronously
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, height: $calculatedHeight, onDone: onDone)
    }

    final class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<String>
        var calculatedHeight: Binding<CGFloat>
        var onDone: (() -> Void)?

        init(text: Binding<String>, height: Binding<CGFloat>, onDone: (() -> Void)? = nil) {
            self.text = text
            self.calculatedHeight = height
            self.onDone = onDone
        }

        func textViewDidChange(_ uiView: UITextView) {
            text.wrappedValue = uiView.text
            UITextViewWrapper.recalculateHeight(view: uiView, result: calculatedHeight)
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if let onDone = self.onDone, text == "\n" {
                textView.resignFirstResponder()
                onDone()
                return false
            }
            return true
        }
    }

}



import UIKit
import SwiftUI

// Credit https://stackoverflow.com/questions/36341358/how-to-convert-uicolor-to-string-and-string-to-uicolor-using-swift#answer-62192394
extension Color {

    init?(hexString: String) {

        let rgbaData = getrgbaData(hexString: hexString)

        if(rgbaData != nil){

            self.init(
                        .sRGB,
                        red:     Double(rgbaData!.r),
                        green:   Double(rgbaData!.g),
                        blue:    Double(rgbaData!.b),
                        opacity: Double(rgbaData!.a)
                    )
            return
        }
        return nil
    }
}

extension UIColor {

    public convenience init?(hexString: String) {

        let rgbaData = getrgbaData(hexString: hexString)

        if(rgbaData != nil){
            self.init(
                        red:   rgbaData!.r,
                        green: rgbaData!.g,
                        blue:  rgbaData!.b,
                        alpha: rgbaData!.a)
            return
        }
        return nil
    }
}

private func getrgbaData(hexString: String) -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)? {

    var rgbaData : (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)? = nil

    if hexString.hasPrefix("#") {

        let start = hexString.index(hexString.startIndex, offsetBy: 1)
        let hexColor = String(hexString[start...]) // Swift 4

        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0

        if scanner.scanHexInt64(&hexNumber) {

            rgbaData = { // start of a closure expression that returns a Vehicle
                switch hexColor.count {
                case 8:

                    return ( r: CGFloat((hexNumber & 0xff000000) >> 24) / 255,
                             g: CGFloat((hexNumber & 0x00ff0000) >> 16) / 255,
                             b: CGFloat((hexNumber & 0x0000ff00) >> 8)  / 255,
                             a: CGFloat( hexNumber & 0x000000ff)        / 255
                           )
                case 6:

                    return ( r: CGFloat((hexNumber & 0xff0000) >> 16) / 255,
                             g: CGFloat((hexNumber & 0x00ff00) >> 8)  / 255,
                             b: CGFloat((hexNumber & 0x0000ff))       / 255,
                             a: 1.0
                           )
                default:
                    return nil
                }
            }()

        }
    }

    return rgbaData
}

