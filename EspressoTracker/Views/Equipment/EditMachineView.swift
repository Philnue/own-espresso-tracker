//
//  EditMachineView.swift
//  EspressoTracker
//
//  View for editing an existing espresso machine
//

import SwiftUI
import SwiftData
import PhotosUI

struct EditMachineView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    var machine: Machine

    @State private var name = ""
    @State private var brand = ""
    @State private var model = ""
    @State private var boilerType = "Single Boiler"
    @State private var groupHeadType = "Standard"
    @State private var pressure = ""
    @State private var notes = ""
    @State private var purchaseDate = Date()
    @State private var hasPurchaseDate = false
    @State private var selectedImage: PhotosPickerItem?
    @State private var imageData: Data?

    let boilerTypes = ["Single Boiler", "Double Boiler", "Heat Exchanger", "Dual Boiler"]
    let groupHeadTypes = ["Standard", "E61", "Saturated", "Semi-Saturated", "Other"]

    var body: some View {
        ZStack {
            Color.backgroundPrimary.ignoresSafeArea()

            Form {
                Section(header: Text("Basic Information").foregroundColor(.espressoBrown)) {
                    TextField("Name", text: $name)
                    TextField("Brand", text: $brand)
                    TextField("Model", text: $model)
                }
                .listRowBackground(Color.cardBackground)

                Section(header: Text("Specifications").foregroundColor(.espressoBrown)) {
                    Picker("Boiler Type", selection: $boilerType) {
                        ForEach(boilerTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }

                    Picker("Group Head", selection: $groupHeadType) {
                        ForEach(groupHeadTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }

                    HStack {
                        Text("Pressure (bar)")
                        Spacer()
                        TextField("9.0", text: $pressure)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                    }
                }
                .listRowBackground(Color.cardBackground)

                Section(header: Text("Purchase Information").foregroundColor(.espressoBrown)) {
                    Toggle("Track Purchase Date", isOn: $hasPurchaseDate)

                    if hasPurchaseDate {
                        DatePicker("Purchase Date", selection: $purchaseDate, displayedComponents: .date)
                    }
                }
                .listRowBackground(Color.cardBackground)

                Section(header: Text("Image").foregroundColor(.espressoBrown)) {
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

                            Text("Change Image")
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

                Section(header: Text("Notes").foregroundColor(.espressoBrown)) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                        .foregroundColor(.textPrimary)
                }
                .listRowBackground(Color.cardBackground)
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Edit Machine")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.textSecondary)
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    saveChanges()
                }
                .foregroundColor(.espressoBrown)
                .disabled(name.isEmpty)
            }
        }
        .onAppear {
            loadMachineData()
        }
    }

    private func loadMachineData() {
        name = machine.wrappedName
        brand = machine.wrappedBrand
        model = machine.model
        boilerType = machine.boilerType
        groupHeadType = machine.groupHeadType
        pressure = String(format: "%.1f", machine.pressureBar)
        notes = machine.wrappedNotes
        imageData = machine.imageData
        hasPurchaseDate = machine.purchaseDate != nil
        purchaseDate = machine.purchaseDate ?? Date()
    }

    private func saveChanges() {
        let pressureValue = Double(pressure) ?? 9.0
        let dataManager = DataManager(modelContext: modelContext)
        dataManager.updateMachine(
            machine,
            name: name,
            brand: brand,
            model: model,
            boilerType: boilerType,
            groupHeadType: groupHeadType,
            pressureBar: pressureValue,
            notes: notes,
            imageData: imageData,
            purchaseDate: hasPurchaseDate ? purchaseDate : nil
        )
        dismiss()
    }
}
