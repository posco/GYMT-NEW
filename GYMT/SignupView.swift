//
//  SignupView.swift
//  GYMT
//
//  Created by James Orbell on 31/03/2020.
//  Copyright © 2020 James Orbell. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseFirestoreSwift

struct SignupView: View {

    @ObservedObject var viewRouter: ViewRouter
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    let facebook_color = UIColor(red: 59, green: 89, blue: 152, alpha: 1)
    
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var error: String = ""
    @State var user: String = ""
    @State var uid: String = ""
    @EnvironmentObject var session: SessionStore
    
    func signUp() {

        session.signUp(email: email, password: password) { (result, error) in
            if let error = error {
                self.error = error.localizedDescription
            } else {
                
                // Provided no authentication errors, will generate a new document within the 'Users' collection.
                let db = Firestore.firestore()
                db.collection("Users").document(String((result?.user.uid)!)).setData([
                    "FirstName" : self.firstName,
                    "LastName" : self.lastName,
                    "Email" : self.email,
                    "Coins" : 0,
                    "AccountCreationDate" : FieldValue.serverTimestamp(),
                    "GymLocation" : ""
                ]) { error in
                    if let error = error {
                        print("Error writing document: \(error)")
                    } else {
                        print("Document successfully written!")
                    }
                }
                
                self.email = ""
                self.password = ""
                
                self.viewRouter.currentPage = "page2"
            }
        }
        
    }

    var body: some View {
        NavigationView {
            VStack {
                Image(colorScheme == .light ? "GYMT-logo" : "GYMT-logo-white")
                .resizable()
                .scaledToFit()
                .frame(width: 200.0,height:200)
                .padding(.top, -100)
                
                Text("Sign up to get started")
                
                // Input fields.
                VStack {
                    TextField("First name", text: $firstName)
                        .font(.system(size: 14))
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color(UIColor.systemGray),lineWidth: 1))
                    
                    TextField("Last name", text: $lastName)
                    .font(.system(size: 14))
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color(UIColor.systemGray),lineWidth: 1))
                    .padding(.bottom, 20)
                    
                    TextField("Email address", text: $email)
                        .font(.system(size: 14))
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color(UIColor.systemGray),lineWidth: 1))
                    
                    SecureField("Password", text: $password)
                        .font(.system(size: 14))
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color(UIColor.systemGray),lineWidth: 1))
                }
                .padding()
                
                Button(action: signUp) {
                    Text("Create account")
                        .frame(minWidth: 0, maxWidth: 300)
                        .frame(height: 50)
                        .foregroundColor(.white)
                        .font(.system(size: 14, weight: .bold))
                        .background(Color(UIColor.systemBlue))
                        .cornerRadius(5)
                }
                .padding()
                
                if (error != "") {
                    Text(error)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.red)
                        .padding()
                }
                
                Spacer()
                
                HStack {
                    Text("I have an existing account.")
                    Button(action: {self.viewRouter.currentPage = "page2"}) {
                        Text("Log in")
                            .fontWeight(.bold)
                    }
                }
            }
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView(viewRouter: ViewRouter())
    }
}
