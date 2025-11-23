//
//  EditBeanView.swift
//  EspressoTracker
//
//  View for editing an existing coffee bean
//

import SwiftUI
import SwiftData
import PhotosUI

struct EditBeanView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    var bean: Bean

    @State private var name = ""
    @State private var roaster = ""
    @State private var origin = ""
    @State private var roastLevel = "Medium"
    @State private var roastDate = Date()
    @State private var process = "Washed"
    @State private var variety = "Arabica"
    @State private var tastingNotes = ""
    @State private var price = ""
    @State private var weight = ""
    @State private var notes = ""
    @State private var selectedImage: PhotosPickerItem?
    @State private var imageData: Data?
    @FocusState private var isInputFocused: Bool

    let roastLevels = ["Light", "Medium-Light", "Medium", "Medium-Dark", "Dark"]
    let processes = ["Washed", "Natural", "Honey", "Anaerobic", "Other"]
    let varieties = ["Arabica", "Robusta", "Blend", "Other"]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()

                Form {
                    Section(header: Text(LocalizedString.get("basic_information")).foregroundColor(.espressoBrown)) {
                        TextField(LocalizedString.get("name"), text: $name)
                        TextField(LocalizedString.get("roaster"), text: $roaster)
                        TextField(LocalizedString.get("origin"), text: $origin)
                    }
                    .listRowBackground(Color.cardBackground)

                    Section(header: Text(LocalizedString.get("bean_details")).foregroundColor(.espressoBrown)) {
                        Picker(LocalizedString.get("roast_level"), selection: $roastLevel) {
                            ForEach(roastLevels, id: \.self) { level in
                                Text(level).tag(level)
                            }
                        }

                        DatePicker(LocalizedString.get("roast_date"), selection: $roastDate, displayedComponents: .date)

                        Picker(LocalizedString.get("process"), selection: $process) {
                            ForEach(processes, id: \.self) { proc in
                                Text(proc).tag(proc)
                            }
                        }

                        Picker(LocalizedString.get("variety"), selection: $variety) {
                            ForEach(varieties, id: \.self) { v in
                                Text(v).tag(v)
                            }
                        }
                    }
                    .listRowBackground(Color.cardBackground)

                    Section(header: Text(LocalizedString.get("tasting_notes")).foregroundColor(.espressoBrown)) {
                        TextField(LocalizedString.get("tasting_notes_placeholder"), text: $tastingNotes)
                    }
                    .listRowBackground(Color.cardBackground)

                    Section(header: Text(LocalizedString.get("purchase_details")).foregroundColor(.espressoBrown)) {
                        HStack {
                            Text(LocalizedString.get("price_currency"))
                            Spacer()
                            TextField("18.00", text: $price)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 100)
                                .focused($isInputFocused)
                        }

                        HStack {
                            Text(LocalizedString.get("weight_g"))
                            Spacer()
                            TextField("250", text: $weight)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 100)
                                .focused($isInputFocused)
                        }
                    }
                    .listRowBackground(Color.cardBackground)

                    Section(header: Text(LocalizedString.get("image")).foregroundColor(.espressoBrown)) {
                        PhotosPicker(selection: $selectedImage, matching: .images) {
                            HStack {
                                if let imageData = imageData,
                                   let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(8)
                                } else {
                                    Image(systemName: "photo")
                                        .font(.title2)
                                        .foregroundColor(.textSecondary)
                                        .frame(width: 60, height: 60)
                                        .background(Color.backgroundSecondary)
                                        .cornerRadius(8)
                                }

                                Text(LocalizedString.get("change_image"))
                                    .foregroundColor(.espressoBrown)

                                Spacer()
                            }
                        }
                        .onChange(of: selectedImage) { oldValue, newValue in
                            Task {
                                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                                    imageData = data
                                }
                            }
                        }
                    }
                    .listRowBackground(Color.cardBackground)

                    Section(header: Text(LocalizedString.get("additional_notes")).foregroundColor(.espressoBrown)) {
                        TextEditor(text: $notes)
                            .frame(height: 100)
                            .foregroundColor(.textPrimary)
                    }
                    .listRowBackground(Color.cardBackground)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle(LocalizedString.get("edit_bean"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(LocalizedString.get("cancel")) {
                        dismiss()
                    }
                    .foregroundColor(.textSecondary)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(LocalizedString.get("save")) {
                        saveChanges()
                    }
                    .foregroundColor(.espressoBrown)
                    .disabled(name.isEmpty)
                }

                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button(LocalizedString.get("done")) {
                            isInputFocused = false
                        }
                        .foregroundColor(.espressoBrown)
                        .fontWeight(.semibold)
                    }
                }
            }
            .onAppear {
                loadBeanData()
            }
        }
    }

    private func loadBeanData() {
        name = bean.wrappedName
        roaster = bean.wrappedRoaster
        origin = bean.wrappedOrigin
        roastLevel = bean.roastLevel
        roastDate = bean.roastDate
        process = bean.process
        variety = bean.variety
        tastingNotes = bean.tastingNotes
        price = String(format: "%.2f", bean.price)
        weight = String(format: "%.0f", bean.weight)
        notes = bean.wrappedNotes
        imageData = bean.imageData
    }

    private func saveChanges() {
        let priceValue = Double(price) ?? 0.0
        let weightValue = Double(weight) ?? 250.0

        let dataManager = DataManager(modelContext: modelContext)
        dataManager.updateBean(
            bean,
            name: name,
            roaster: roaster,
            origin: origin,
            roastLevel: roastLevel,
            roastDate: roastDate,
            process: process,
            variety: variety,
            tastingNotes: tastingNotes,
            price: priceValue,
            weight: weightValue,
            notes: notes,
            imageData: imageData
        )
        dismiss()
    }
}
