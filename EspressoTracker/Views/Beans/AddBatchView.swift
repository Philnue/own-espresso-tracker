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
    @FocusState private var isInputFocused: Bool

    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()

                Form {
                    // Bean info (read-only)
                    Section(header: Text(LocalizedString.get("bean_details")).foregroundColor(.espressoBrown)) {
                        HStack {
                            Text(LocalizedString.get("name"))
                        Spacer()
                        Text(existingBean.wrappedName)
                            .foregroundColor(.textSecondary)
                    }

                    HStack {
                            Text(LocalizedString.get("roaster"))
                            Spacer()
                            Text(existingBean.wrappedRoaster)
                                .foregroundColor(.textSecondary)
                        }

                        HStack {
                            Text(LocalizedString.get("origin"))
                            Spacer()
                            Text(existingBean.wrappedOrigin)
                                .foregroundColor(.textSecondary)
                        }

                        HStack {
                            Text(LocalizedString.get("roast_level"))
                            Spacer()
                            Text(existingBean.roastLevel)
                                .foregroundColor(.textSecondary)
                        }

                        HStack {
                            Text(LocalizedString.get("process"))
                            Spacer()
                            Text(existingBean.process)
                                .foregroundColor(.textSecondary)
                        }
                    }
                    .listRowBackground(Color.cardBackground)

                    // Batch-specific info
                    Section(header: Text(LocalizedString.get("new_batch_details")).foregroundColor(.espressoBrown)) {
                        DatePicker(LocalizedString.get("roast_date"), selection: $roastDate, displayedComponents: .date)

                        DatePicker(LocalizedString.get("purchase_date"), selection: $purchaseDate, displayedComponents: .date)

                        HStack {
                            Text(LocalizedString.get("weight_g"))
                            Spacer()
                            TextField("250", text: $weight)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 100)
                                .focused($isInputFocused)
                        }

                        HStack {
                            Text(LocalizedString.get("price_currency"))
                            Spacer()
                            TextField(String(format: "%.2f", existingBean.price), text: $price)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 100)
                                .focused($isInputFocused)
                        }
                    }
                    .listRowBackground(Color.cardBackground)

                    // Info section
                    Section {
                        HStack {
                            Image(systemName: "info.circle")
                                .foregroundColor(.espressoBrown)
                            Text(LocalizedString.get("new_batch_info"))
                                .font(.caption)
                                .foregroundColor(.textSecondary)
                        }
                    }
                    .listRowBackground(Color.cardBackground)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle(LocalizedString.get("new_batch"))
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
                        saveBatch()
                    }
                    .foregroundColor(.espressoBrown)
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
                // Pre-fill with existing bean's price
                price = String(format: "%.2f", existingBean.price)
            }
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
