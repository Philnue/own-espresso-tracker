//
//  AddBatchView.swift
//  EspressoTracker
//
//  View for adding a new batch of an existing bean
//

import SwiftUI
import SwiftData

struct AddBatchView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let existingBean: Bean

    @State private var roastDate = Date()
    @State private var purchaseDate = Date()
    @State private var weight = "250"
    @State private var price = ""

    var body: some View {
        ZStack {
            Color.backgroundPrimary.ignoresSafeArea()

            Form {
                // Bean info (read-only)
                Section(header: Text("Bean Details").foregroundColor(.espressoBrown)) {
                    HStack {
                        Text("Name")
                        Spacer()
                        Text(existingBean.wrappedName)
                            .foregroundColor(.textSecondary)
                    }

                    HStack {
                        Text("Roaster")
                        Spacer()
                        Text(existingBean.wrappedRoaster)
                            .foregroundColor(.textSecondary)
                    }

                    HStack {
                        Text("Origin")
                        Spacer()
                        Text(existingBean.wrappedOrigin)
                            .foregroundColor(.textSecondary)
                    }

                    HStack {
                        Text("Roast Level")
                        Spacer()
                        Text(existingBean.roastLevel)
                            .foregroundColor(.textSecondary)
                    }

                    HStack {
                        Text("Process")
                        Spacer()
                        Text(existingBean.process)
                            .foregroundColor(.textSecondary)
                    }
                }
                .listRowBackground(Color.cardBackground)

                // Batch-specific info
                Section(header: Text("New Batch Details").foregroundColor(.espressoBrown)) {
                    DatePicker("Roast Date", selection: $roastDate, displayedComponents: .date)

                    DatePicker("Purchase Date", selection: $purchaseDate, displayedComponents: .date)

                    HStack {
                        Text("Weight (g)")
                        Spacer()
                        TextField("250", text: $weight)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                    }

                    HStack {
                        Text("Price ($)")
                        Spacer()
                        TextField(String(format: "%.2f", existingBean.price), text: $price)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                    }
                }
                .listRowBackground(Color.cardBackground)

                // Info section
                Section {
                    HStack {
                        Image(systemName: "info.circle")
                            .foregroundColor(.espressoBrown)
                        Text("This will create a new batch with its own inventory tracking. The original bean will remain unchanged.")
                            .font(.caption)
                            .foregroundColor(.textSecondary)
                    }
                }
                .listRowBackground(Color.cardBackground)
            }
            .scrollContentBackground(.hidden)
            }
            .navigationTitle("New Batch")
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
                        saveBatch()
                    }
                    .foregroundColor(.espressoBrown)
                }
            }
            .onAppear {
                // Pre-fill with existing bean's price
                price = String(format: "%.2f", existingBean.price)
            }
    }

    private func saveBatch() {
        let weightValue = Double(weight) ?? 250.0
        let priceValue = Double(price) ?? existingBean.price

        let dataManager = DataManager(modelContext: modelContext)
        dataManager.createBatchFromBean(
            existingBean,
            weight: weightValue,
            roastDate: roastDate,
            purchaseDate: purchaseDate,
            price: priceValue
        )
        dismiss()
    }
}

#Preview {
    AddBatchView(existingBean: Bean(name: "Test Bean", roaster: "Test Roaster"))
        .modelContainer(for: Bean.self, inMemory: true)
}
