//
//  TutorialView.swift
//  EspressoTracker
//
//  Guided tour showing app features
//

import SwiftUI

struct TutorialView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentPage = 0

    let pages: [TutorialPage] = [
        TutorialPage(
            icon: "cup.and.saucer.fill",
            title: "welcome_to_brew_diary",
            description: "tutorial_welcome_desc",
            color: .espressoBrown
        ),
        TutorialPage(
            icon: "leaf.fill",
            title: "tutorial_beans_title",
            description: "tutorial_beans_desc",
            color: .green
        ),
        TutorialPage(
            icon: "wrench.and.screwdriver.fill",
            title: "tutorial_equipment_title",
            description: "tutorial_equipment_desc",
            color: .blue
        ),
        TutorialPage(
            icon: "timer",
            title: "tutorial_brewing_title",
            description: "tutorial_brewing_desc",
            color: .orange
        ),
        TutorialPage(
            icon: "cup.and.saucer.fill",
            title: "tutorial_methods_title",
            description: "tutorial_methods_desc",
            color: .purple
        ),
        TutorialPage(
            icon: "clock.fill",
            title: "tutorial_history_title",
            description: "tutorial_history_desc",
            color: .red
        ),
        TutorialPage(
            icon: "book.fill",
            title: "tutorial_calculator_title",
            description: "tutorial_calculator_desc",
            color: .cyan
        ),
        TutorialPage(
            icon: "checkmark.circle.fill",
            title: "tutorial_ready_title",
            description: "tutorial_ready_desc",
            color: .espressoBrown
        )
    ]

    var body: some View {
        ZStack {
            Color.backgroundPrimary.ignoresSafeArea()

            VStack(spacing: 0) {
                // Skip button
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Text(LocalizedString.get("skip"))
                            .font(.subheadline)
                            .foregroundColor(.textSecondary)
                            .padding()
                    }
                }

                // Page content
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        TutorialPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))

                // Navigation buttons
                HStack(spacing: 20) {
                    if currentPage > 0 {
                        Button(action: { currentPage -= 1 }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text(LocalizedString.get("previous"))
                            }
                            .font(.headline)
                            .foregroundColor(.espressoBrown)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(Color.cardBackground)
                            .cornerRadius(10)
                        }
                    } else {
                        Spacer()
                    }

                    Spacer()

                    if currentPage < pages.count - 1 {
                        Button(action: { currentPage += 1 }) {
                            HStack {
                                Text(LocalizedString.get("next"))
                                Image(systemName: "chevron.right")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(Color.espressoBrown)
                            .cornerRadius(10)
                        }
                    } else {
                        Button(action: { dismiss() }) {
                            Text(LocalizedString.get("get_started"))
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(Color.espressoBrown)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct TutorialPage {
    let icon: String
    let title: String
    let description: String
    let color: Color
}

struct TutorialPageView: View {
    let page: TutorialPage

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            // Icon
            Image(systemName: page.icon)
                .font(.system(size: 80))
                .foregroundColor(page.color)

            // Title
            Text(LocalizedString.get(page.title))
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.textPrimary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // Description
            Text(LocalizedString.get(page.description))
                .font(.body)
                .foregroundColor(.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()
        }
    }
}

#Preview {
    TutorialView()
}
