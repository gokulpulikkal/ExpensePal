//
//  SettingsView.swift
//  ExpensePal
//
//  Created by Gokul P on 09/06/24.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isLightMode") var isLightMode = true
    var body: some View {
        VStack(alignment: .leading) {
            pageTitle
                .padding(.vertical)
            VStack {
                Section {
                    darkModeToggleView
                } header: {
                    sectionTitle(title: "General")
                }

                Section {
//                    reportBug
                    sendFeedBack
                } header: {
                    sectionTitle(title: "Support")
                }
            }
            .padding(.horizontal, 3)

            Spacer()
        }
        .padding(.horizontal)
    }

    var pageTitle: some View {
        HStack {
            Text("Settings")
                .font(.system(size: 32))
                .fontWeight(.bold)
                .bold()
            Spacer()
        }
    }

    func sectionTitle(title: String) -> some View {
        HStack {
            Text(title)
                .bold()
                .font(.title3)
            Spacer()
        }
    }

    var darkModeToggleView: some View {
        HStack {
            Image(systemName: "sun.max")
                .resizable()
                .frame(width: 25, height: 25)
            Text("Light Mode")
            Spacer()
            Toggle("", isOn: $isLightMode)
                .tint(Color(AppColors.primaryAccent.rawValue))
        }
        .padding()
//        .background {
//            RoundedRectangle(cornerRadius: 10)
//                .stroke(lineWidth: 1)
//        }
    }

    var reportBug: some View {
        HStack {
            Image(systemName: "ladybug.circle")
                .resizable()
                .frame(width: 25, height: 25)
            Text("Report a bug")
            Spacer()
        }
        .padding()
//        .background {
//            RoundedRectangle(cornerRadius: 10)
//                .stroke(lineWidth: 1)
//        }
    }

    var sendFeedBack: some View {
        HStack {
            Image(systemName: "arrow.up.message")
                .resizable()
                .frame(width: 25, height: 25)
            Text("Send feedback")
            Spacer()
        }
        .onTapGesture {
            openMail()
        }
        .padding()
//        .background {
//            RoundedRectangle(cornerRadius: 10)
//                .stroke(lineWidth: 1)
//        }
    }

    func openMail() {
        let url = URL(string: "mailto: gokulplkl@gmail.com")
        if let url {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}

#Preview {
    SettingsView()
}
