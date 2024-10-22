//
//  SettingsView.swift
//  ExpensePal
//
//  Created by Gokul P on 09/06/24.
//

import ExpensePalModels
import SwiftData
import SwiftUI

struct SettingsView: View {
    @AppStorage("isLightMode") var isLightMode = true
    @Environment(\.modelContext) var modelContext
    @State var showDeleteAllDataAlert = false
    @Query private var items: [Expense]

    @AppStorage("localeIdentifier") var localeIdentifier = Locales.USA.localeIdentifier

    private let localeIdentifiers = [
        Locales.USA.localeIdentifier,
        Locales.EUROPE.localeIdentifier,
        Locales.CANADA.localeIdentifier,
        Locales.INDIA.localeIdentifier
    ]

    var body: some View {
        VStack(alignment: .leading) {
            pageTitle
                .padding(.vertical)
            VStack {
                Section {
                    darkModeToggleView
                    currencySelector
                } header: {
                    sectionTitle(title: "General")
                }

                Section {
//                    reportBug
                    sendFeedBack
                    deleteAllData
                } header: {
                    sectionTitle(title: "Support")
                }
            }
            .padding(.horizontal, 3)

            Spacer()
        }
        .padding(.horizontal)
        .alert("Are You Sure!", isPresented: $showDeleteAllDataAlert, actions: {
            Button("Yes", role: .destructive, action: {
                deleteAllExpenses()
            })
        }, message: {
            Text("All expense data will be deleted permanently")
        })
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
    
    var currencySelector: some View {
        HStack {
            Image(systemName: "dollarsign.circle")
                .resizable()
                .frame(width: 25, height: 25)
            Text("Currency")
            Spacer()
            Picker(selection: $localeIdentifier) {
                ForEach(localeIdentifiers, id: \.self) {
                    let locale = Locale(identifier: $0)
                    if let cc = locale.currency?.identifier, let sym = locale.currencySymbol {
                        Text("\(cc) \(sym)")
                    }
                }
            } label: {}
                .tint(.primary)
        }
        .padding([.leading, .bottom])
        
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
        Button(action: {
            openMail()
        }, label: {
            HStack {
                Image(systemName: "arrow.up.message")
                    .resizable()
                    .frame(width: 25, height: 25)
                Text("Send feedback")
                Spacer()
            }
        })
        .tint(.primary)
        .padding()
//        .background {
//            RoundedRectangle(cornerRadius: 10)
//                .stroke(lineWidth: 1)
//        }
    }

    var deleteAllData: some View {
        Button(action: {
            showDeleteAllDataAlert = true
        }, label: {
            HStack {
                Image(systemName: "trash")
                    .resizable()
                    .frame(width: 25, height: 25)
                Text("Delete All Data")
                Spacer()
            }
        })
        .tint(.primary)
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

    func deleteAllExpenses() {
        // Other options are not working reliably
        for item in items {
            modelContext.delete(item)
        }
    }
}

#Preview {
    SettingsView()
}

extension ModelContext {
    func deleteAll<T>(model: T.Type) where T: PersistentModel {
        do {
            let p = #Predicate<T> { _ in true }
            try delete(model: T.self, where: p, includeSubclasses: false)
            print("All of \(model.self) cleared !")
        } catch {
            print("error: \(error)")
        }
    }
}
