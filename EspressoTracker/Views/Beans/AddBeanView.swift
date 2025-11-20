//
//  AddBeanView.swift
//  EspressoTracker
//
//  View for adding new coffee beans
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddBeanView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var roaster = ""
    @State private var origin = ""
    @State private var roastLevel = "Medium"
    @State private var roastDate = Date()
    @State private var process = "Washed"
    @State private var variety = "Arabica"
    @State private var tastingNotes = ""
    @State private var price = ""
    @State private var weight = "250"
    @State private var notes = ""
    @State private var selectedImage: PhotosPickerItem?
    @State private var imageData: Data?
    @State private var purchaseDate = Date()

    let roastLevels = ["Light", "Medium-Light", "Medium", "Medium-Dark", "Dark"]
    let processes = ["Washed", "Natural", "Honey", "Anaerobic", "Other"]
    let varieties = ["Arabica", "Robusta", "Blend", "Other"]

    var body: some View {
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

                    DatePicker("Purchase Date", selection: $purchaseDate, displayedComponents: .date)
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

                            Text("Select Image")
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
            .navigationTitle("Add Beans")
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
                        saveBean()
                    }
                    .foregroundColor(.espressoBrown)
                    .disabled(name.isEmpty)
                }
            }
    }

    private func saveBean() {
        let priceValue = Double(price) ?? 0.0
        let weightValue = Double(weight) ?? 250.0

        let dataManager = DataManager(modelContext: modelContext)
        dataManager.createBean(
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
            imageData: imageData,
            purchaseDate: purchaseDate
        )
        dismiss()
    }
}

#Preview {
    AddBeanView()
        .modelContainer(for: Bean.self, inMemory: true)
}
