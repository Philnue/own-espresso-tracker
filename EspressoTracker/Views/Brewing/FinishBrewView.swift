//
//  FinishBrewView.swift
//  EspressoTracker
//
//  View for finishing and saving a brewing session
//

import SwiftUI
import SwiftData
import PhotosUI

struct FinishBrewView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: BrewingViewModel

    let brewMethod: String
    let grinder: Grinder?
    let machine: Machine?
    let bean: Bean?

    @State private var yieldOut: String = ""
    @State private var doseIn: String = ""
    @State private var brewTime: String = ""
    @State private var rating: Int = 3
    @State private var notes: String = ""
    @State private var selectedImage: PhotosPickerItem?
    @State private var imageData: Data?

    // Taste parameters
    @State private var acidity: Int = 3
    @State private var sweetness: Int = 3
    @State private var bitterness: Int = 3
    @State private var bodyWeight: Int = 3
    @State private var aftertaste: Int = 3

    // Puck preparation techniques
    @State private var puckPrepWDT: Bool = false
    @State private var puckPrepRDT: Bool = false

    // Focus state for keyboard
    @FocusState private var focusedField: Field?

    enum Field {
        case yield, dose, brewTime
    }

    var actualRatio: Double {
        guard let dose = Double(doseIn),
              let yield = Double(yieldOut),
              dose > 0 else { return 0 }
        return yield / dose
    }

    var canSave: Bool {
        !yieldOut.isEmpty && !doseIn.isEmpty
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundPrimary.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Quick summary header
                    HStack(spacing: 20) {
                        // Dose
                        VStack(spacing: 4) {
                            Text(doseIn.isEmpty ? "--" : doseIn)
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(.espressoBrown)
                            Text("g in")
                                .font(.caption2)
                                .foregroundColor(.textSecondary)
                        }

                        Image(systemName: "arrow.right")
                            .foregroundColor(.textTertiary)

                        // Time
                        VStack(spacing: 4) {
                            Text(brewTime.isEmpty ? "--" : brewTime)
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(.textPrimary)
                            Text("sec")
                                .font(.caption2)
                                .foregroundColor(.textSecondary)
                        }

                        Image(systemName: "arrow.right")
                            .foregroundColor(.textTertiary)

                        // Yield
                        VStack(spacing: 4) {
                            Text(yieldOut.isEmpty ? "--" : yieldOut)
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(.espressoBrown)
                            Text("g out")
                                .font(.caption2)
                                .foregroundColor(.textSecondary)
                        }

                        // Ratio badge
                        if !yieldOut.isEmpty && !doseIn.isEmpty && actualRatio > 0 {
                            VStack(spacing: 4) {
                                Text(String(format: "1:%.1f", actualRatio))
                                    .font(.system(size: 18, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(actualRatio >= 1.5 && actualRatio <= 3.0 ? Color.successGreen : Color.warningOrange)
                                    .cornerRadius(8)
                                Text(LocalizedString.get("ratio"))
                                    .font(.caption2)
                                    .foregroundColor(.textSecondary)
                            }
                        }
                    }
                    .padding()
                    .background(Color.cardBackground)
                    .cornerRadius(16)
                    .padding(.horizontal)
                    .padding(.top, 8)

                Form {
                    // Editable brew parameters section
                    Section(header: Text(LocalizedString.get("brew_summary")).foregroundColor(.espressoBrown)) {
                        // Dose In - editable
                        HStack {
                            Image(systemName: "scalemass")
                                .foregroundColor(.espressoBrown)
                                .frame(width: 24)
                            Text(LocalizedString.get("dose_in"))
                                .foregroundColor(.textPrimary)
                            Spacer()
                            TextField("18", text: $doseIn)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 80)
                                .focused($focusedField, equals: .dose)
                            Text("g")
                                .foregroundColor(.textSecondary)
                        }

                        // Brew Time - editable
                        HStack {
                            Image(systemName: "timer")
                                .foregroundColor(.espressoBrown)
                                .frame(width: 24)
                            Text(LocalizedString.get("brew_time"))
                                .foregroundColor(.textPrimary)
                            Spacer()
                            TextField("25", text: $brewTime)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 80)
                                .focused($focusedField, equals: .brewTime)
                            Text("s")
                                .foregroundColor(.textSecondary)
                        }

                        // Yield Out - editable
                        HStack {
                            Image(systemName: "drop.fill")
                                .foregroundColor(.espressoBrown)
                                .frame(width: 24)
                            Text(LocalizedString.get("yield_out_g"))
                                .foregroundColor(.textPrimary)
                            Spacer()
                            TextField(viewModel.targetYieldString, text: $yieldOut)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 80)
                                .focused($focusedField, equals: .yield)
                            Text("g")
                                .foregroundColor(.textSecondary)
                        }

                        // Calculated ratio
                        if !yieldOut.isEmpty && !doseIn.isEmpty {
                            HStack {
                                Image(systemName: "percent")
                                    .foregroundColor(.espressoBrown)
                                    .frame(width: 24)
                                Text(LocalizedString.get("actual_ratio"))
                                    .foregroundColor(.textPrimary)
                                Spacer()
                                Text(String(format: "1:%.2f", actualRatio))
                                    .fontWeight(.semibold)
                                    .foregroundColor(actualRatio >= 1.5 && actualRatio <= 3.0 ? .successGreen : .warningOrange)
                            }
                        }

                        Text("ℹ️ \(LocalizedString.get("espresso_info"))")
                            .font(.caption2)
                            .foregroundColor(.textTertiary)
                            .italic()
                    }
                    .listRowBackground(Color.cardBackground)

                // Rating
                Section(header: Text(LocalizedString.get("rating")).foregroundColor(.espressoBrown)) {
                    HStack {
                        Text(LocalizedString.get("quality"))
                            .foregroundColor(.textPrimary)
                        Spacer()
                        HStack(spacing: 8) {
                            ForEach(1...5, id: \.self) { star in
                                Button(action: {
                                    rating = star
                                }) {
                                    Image(systemName: star <= rating ? "star.fill" : "star")
                                        .font(.title3)
                                        .foregroundColor(star <= rating ? .espressoBrown : .textTertiary)
                                }
                            }
                        }
                    }
                }
                .listRowBackground(Color.cardBackground)

                // Taste Profile
                Section(header: Text(LocalizedString.get("taste_profile")).foregroundColor(.espressoBrown)) {
                    TasteSlider(label: LocalizedString.get("acidity"), value: $acidity, icon: "sparkles")
                    Divider()
                    TasteSlider(label: LocalizedString.get("sweetness"), value: $sweetness, icon: "heart.fill")
                    Divider()
                    TasteSlider(label: LocalizedString.get("bitterness"), value: $bitterness, icon: "flame.fill")
                    Divider()
                    TasteSlider(label: LocalizedString.get("body"), value: $bodyWeight, icon: "drop.fill")
                    Divider()
                    TasteSlider(label: LocalizedString.get("aftertaste"), value: $aftertaste, icon: "star.fill")
                }
                .listRowBackground(Color.cardBackground)

                // Equipment used
                Section(header: Text(LocalizedString.get("equipment_used")).foregroundColor(.espressoBrown)) {
                    if let grinder = grinder {
                        HStack {
                            Image(systemName: "slider.horizontal.3")
                                .foregroundColor(.espressoBrown)
                            Text(grinder.wrappedName)
                                .foregroundColor(.textPrimary)
                        }
                    }

                    if let machine = machine {
                        HStack {
                            Image(systemName: "refrigerator")
                                .foregroundColor(.espressoBrown)
                            Text(machine.wrappedName)
                                .foregroundColor(.textPrimary)
                        }
                    }

                    if let bean = bean {
                        HStack {
                            Image(systemName: "leaf.fill")
                                .foregroundColor(.espressoBrown)
                            Text(bean.wrappedName)
                                .foregroundColor(.textPrimary)
                        }
                    }
                }
                .listRowBackground(Color.cardBackground)

                // Puck Preparation Techniques
                Section(header: Text(LocalizedString.get("puck_prep_techniques")).foregroundColor(.espressoBrown)) {
                    VStack(spacing: 16) {
                        // WDT Toggle
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Image(systemName: "wand.and.stars")
                                        .foregroundColor(.espressoBrown)
                                    Text(LocalizedString.get("wdt"))
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.textPrimary)
                                }
                                Text(LocalizedString.get("wdt_full"))
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                            }

                            Spacer()

                            Toggle("", isOn: $puckPrepWDT)
                                .tint(.espressoBrown)
                        }

                        Divider()
                            .background(Color.dividerColor)

                        // RDT Toggle
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Image(systemName: "drop.triangle")
                                        .foregroundColor(.espressoBrown)
                                    Text(LocalizedString.get("rdt"))
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.textPrimary)
                                }
                                Text(LocalizedString.get("rdt_full"))
                                    .font(.caption)
                                    .foregroundColor(.textSecondary)
                            }

                            Spacer()

                            Toggle("", isOn: $puckPrepRDT)
                                .tint(.espressoBrown)
                        }
                    }
                }
                .listRowBackground(Color.cardBackground)

                // Photo
                Section(header: Text(LocalizedString.get("shot_photo")).foregroundColor(.espressoBrown)) {
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
                                Image(systemName: "camera")
                                    .font(.title2)
                                    .foregroundColor(.textSecondary)
                                    .frame(width: 60, height: 60)
                                    .background(Color.backgroundSecondary)
                                    .cornerRadius(8)
                            }

                            Text(LocalizedString.get("add_photo"))
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

                // Notes
                Section(header: Text(LocalizedString.get("tasting_notes")).foregroundColor(.espressoBrown)) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                        .foregroundColor(.textPrimary)
                }
                .listRowBackground(Color.cardBackground)

                // Spacer section for save button
                Section {
                    EmptyView()
                }
                .listRowBackground(Color.clear)
                .frame(height: 80)
            }
                .scrollContentBackground(.hidden)

                    // Sticky save button at bottom
                    VStack(spacing: 0) {
                        Divider()
                        Button(action: { saveBrewingSession() }) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text(LocalizedString.get("save"))
                                    .fontWeight(.semibold)
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(canSave ? Color.espressoBrown : Color.textTertiary)
                            .cornerRadius(16)
                        }
                        .disabled(!canSave)
                        .padding()
                        .background(Color.backgroundPrimary)
                    }
                }
            }
            .navigationTitle(LocalizedString.get("finish_shot"))
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
                        saveBrewingSession()
                    }
                    .foregroundColor(.espressoBrown)
                    .fontWeight(.semibold)
                    .disabled(yieldOut.isEmpty || doseIn.isEmpty)
                }

                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button(LocalizedString.get("done")) {
                            focusedField = nil
                        }
                        .foregroundColor(.espressoBrown)
                        .fontWeight(.semibold)
                    }
                }
            }
            .onAppear {
                doseIn = viewModel.doseIn
                brewTime = String(format: "%.1f", viewModel.elapsedTime)
            }
        }
    }

    private func saveBrewingSession() {
        guard let yield = Double(yieldOut),
              let dose = Double(doseIn) else { return }

        let brewTimeValue = Double(brewTime) ?? viewModel.elapsedTime
        let waterTemp = Double(viewModel.waterTemp) ?? 93.0
        let pressure = Double(viewModel.pressure) ?? 9.0

        let dataManager = DataManager(modelContext: modelContext)
        dataManager.createBrewingSession(
            grinder: grinder,
            machine: machine,
            bean: bean,
            brewMethod: brewMethod,
            grindSetting: viewModel.grindSetting,
            doseIn: dose,
            yieldOut: yield,
            brewTime: brewTimeValue,
            waterTemp: waterTemp,
            pressure: pressure,
            rating: rating,
            notes: notes,
            imageData: imageData,
            acidity: acidity,
            sweetness: sweetness,
            bitterness: bitterness,
            bodyWeight: bodyWeight,
            aftertaste: aftertaste,
            puckPrepWDT: puckPrepWDT,
            puckPrepRDT: puckPrepRDT
        )

        // Reset the view model
        viewModel.resetTimer()
        viewModel.doseIn = "18"
        viewModel.grindSetting = ""

        dismiss()
    }
}

struct TasteSlider: View {
    let label: String
    @Binding var value: Int
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.espressoBrown)
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(.textPrimary)
                Spacer()
                Text("\(value)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.espressoBrown)
            }

            HStack(spacing: 8) {
                ForEach(1...5, id: \.self) { level in
                    Circle()
                        .fill(level <= value ? Color.espressoBrown : Color.backgroundSecondary)
                        .frame(width: 30, height: 30)
                        .overlay(
                            Text("\(level)")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(level <= value ? .white : .textSecondary)
                        )
                        .onTapGesture {
                            value = level
                        }
                }
            }
        }
        .padding(.vertical, 4)
    }
}
