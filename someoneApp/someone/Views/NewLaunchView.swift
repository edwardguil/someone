import SwiftUI
import Combine

struct NewLaunchView: View {
    
    @ObservedObject var viewModel: MessageViewModel
    @Binding var hasLaunched : Bool
    @State var mainDescription = ""
    @State var adjectives = ""
    @State var currentView = "first"
    @State var firstName = ""
    
    
    var body: some View {
        if(!hasLaunched) {
            VStack {
                if (currentView == "first" && !hasLaunched) {
                    View1(currentView: $currentView.animation(), firstName: $firstName)
                } else if (currentView == "second") {
                    View2(currentView: $currentView.animation(), mainDescription: $mainDescription)
                } else {
                    View3(viewModel: viewModel, currentView: $currentView.animation(), hasLaunched: $hasLaunched, adjectives: $adjectives, firstName : $firstName, mainDescription : $mainDescription)
                }
            }
        }
    }
}

struct View1: View {

    @Binding var currentView: String
    @Binding var firstName: String
    
    let textLimit = 12

    var body: some View {
        ZStack {
            Rectangle().fill(Color.red)
            VStack {
                Text("So,")
                TextField("name", text: $firstName)
                    .frame(width: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .onReceive(Just(firstName)) { _ in limitText(textLimit) }
                    .multilineTextAlignment(.center)
                Text("you want to talk to someone..?")
                Button("yes") {
                    self.currentView = "second"
                }.padding()
                .background(Color.purple)
                .cornerRadius(40)
                .foregroundColor(.white)
                .padding(10)
            }

        }.transition(.opacity)
    }
    //Function to keep text length in limits
    func limitText(_ upper: Int) {
        if firstName.count > upper {
            firstName = String(firstName.prefix(upper))
        }
    }
}

struct View2: View {
    @Binding var currentView: String
    @Binding var mainDescription: String
    
    let textLimit = 12

    var body: some View {
        ZStack {
            Rectangle().fill(Color.yellow)
            VStack {
                Text("And you want this someone to be a...")
                TextField("philosopher..", text: $mainDescription)
                    .frame(width: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .onReceive(Just(mainDescription)) { _ in limitText(textLimit) }
                    .multilineTextAlignment(.center)
                Button("and") {
                    self.currentView = "third"
                }.padding()
                .background(Color.purple)
                .cornerRadius(40)
                .foregroundColor(.white)
                .padding(10)
            }

        }
        .transition(.opacity)
    }
    
    //Function to keep text length in limits
    func limitText(_ upper: Int) {
        if mainDescription.count > upper {
            mainDescription = String(mainDescription.prefix(upper))
        }
    }
}

struct View3: View {

    @ObservedObject var viewModel: MessageViewModel
    @StateObject var loginVM = LoginViewModel()
    @Binding var currentView: String
    @Binding var hasLaunched : Bool
    @Binding var adjectives : String
    @Binding var firstName : String
    @Binding var mainDescription : String
    
    let textLimit = 40

    var body: some View {
        ZStack {
            Rectangle().fill(Color.pink)
            VStack {
                Text("this someone is...")
                TextField("kind, funnny..", text: $adjectives)
                    .frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .onReceive(Just(adjectives)) { _ in limitText(textLimit) }
                    .multilineTextAlignment(.center)
                Button("Talk With Someone") {
                    let text = generateHeader(adjectives, mainDescription)
                    loginVM.login(firstName:firstName, text:text, viewModel:viewModel)
                    //viewModel.getMessageResponse(text: text)
                    UserDefaults.standard.setValue(true, forKey: "hasLaunched")
                    self.currentView = "first"
                    self.hasLaunched = true
                }.padding()
                .background(Color.purple)
                .cornerRadius(40)
                .foregroundColor(.white)
                .padding(10)
            }
        }
        .transition(.opacity)
    }
    
    //Function to keep text length in limits
    func limitText(_ upper: Int) {
        if adjectives.count > upper {
            adjectives = String(adjectives.prefix(upper))
        }
    }
    
    
    func generateHeader(_ adjectives: String,_ mainDescription : String) -> String {
        let header = "The following is a conversation with a " + mainDescription
            + ". " + "This " + mainDescription + " is" + adjectives + "."
        return header
    }
}
