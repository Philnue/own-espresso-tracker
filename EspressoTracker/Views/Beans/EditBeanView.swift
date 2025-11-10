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
    @ObservedObject var bean: Bean

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

    let roastLevels = ["Light", "Medium-Light", "Medium", "Medium-Dark", "Dark"]
    let processes = ["Washed", "Natural", "Honey", "Anaerobic", "Other"]
    let varieties = ["Arabica", "Robusta", "Blend", "Other"]

    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()

                Form {
                    Section(header: Text("Basic Information").foregroundColor(.espressoBrown)) {
                        TextField("Name", text: $name)
                        TextField("Roaster", text: $roaster)
                        TextField("Origin", text: $origin)
                    }
                    .listRowBackground(Color.cardBackground)

                    Section(header: Text("Bean Details").foregroundColor(.espressoBrown)) {
                        Picker("Roast Level", selection: $roastLevel) {
                            ForEach(roastLevels, id: \.self) { level in
                                Text(level).tag(level)
                            }
                        }

                        DatePicker("Roast Date", selection: $roastDate, displayedComponents: .date)

                        Picker("Process", selection: $process) {
                            ForEach(processes, id: \.self) { proc in
                                Text(proc).tag(proc)
                            }
                        }

                        Picker("Variety", selection: $variety) {
                            ForEach(varieties, id: \.self) { v in
                                Text(v).tag(v)
                            }
                        }
                    }
                    .listRowBackground(Color.cardBackground)

                    Section(header: Text("Tasting Notes").foregroundColor(.espressoBrown)) {
                        TextField("e.g., Chocolate, Caramel, Citrus", text: $tastingNotes)
                    }
                    .listRowBackground(Color.cardBackground)

                    Section(header: Text("Purchase Details").foregroundColor(.espressoBrown)) {
                        HStack {
                            Text("Price ($)")
                            Spacer()
                            TextField("18.00", text: $price)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 100)
                        }

                        HStack {
                            Text("Weight (g)")
                            Spacer()
                            TextField("250", text: $weight)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 100)
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

                    Section(header: Text("Additional Notes").foregroundColor(.espressoBrown)) {
                        TextEditor(text: $notes)
                            .frame(height: 100)
                            .foregroundColor(.textPrimary)
                    }
                    .listRowBackground(Color.cardBackground)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Edit Bean")
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
                loadBeanData()
            }
        }
    }

    private func loadBeanData() {
        name = bean.wrappedName
        roaster = bean.wrappedRoaster
        origin = bean.wrappedOrigin
        roastLevel = bean.roastLevel ?? "Medium"
        roastDate = bean.roastDate ?? Date()
        process = bean.process ?? "Washed"
        variety = bean.variety ?? "Arabica"
        tastingNotes = bean.tastingNotes ?? ""
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
