import Foundation

struct HelpFAQItem: Identifiable {
    let question: String
    let answer: String
    var id: String { question }

    static let all: [HelpFAQItem] = [
        HelpFAQItem(question: "How do I start a project?",
                    answer: "Open Projects, tap + and enter a project name. Open the project, then add one or more rooms."),
        HelpFAQItem(question: "How are wall areas calculated?",
                    answer: "For each rectangular room, gross wall area is 2 × (length + width) × height. Door and window areas are subtracted, with a floor of zero."),
        HelpFAQItem(question: "How is floor area calculated?",
                    answer: "Floor area is length × width. Ceiling area uses the same dimensions for a standard flat ceiling."),
        HelpFAQItem(question: "How is baseboard length measured?",
                    answer: "Baseboard length uses the room perimeter minus the combined door widths. Window widths are not subtracted."),
        HelpFAQItem(question: "How does the waste allowance work?",
                    answer: "The calculated surface or length is multiplied by the number of coats and a waste factor. HomeMeasure then rounds up to full packages according to usable coverage per package."),
        HelpFAQItem(question: "Why do paint and wallpaper use coverage?",
                    answer: "Paint, wallpaper, tile and flooring manufacturers report different usable coverage. Enter the coverage from your chosen product packaging, allowing for pattern repeats and installation conditions."),
        HelpFAQItem(question: "Can I change the quantity to purchase?",
                    answer: "Yes. Edit a material and enable Override calculated packages. The manual package count will be used in your shopping list and cost estimate."),
        HelpFAQItem(question: "How can I mark items as purchased?",
                    answer: "Open Shopping and tap the circle beside any material. The status is shared with its source project."),
        HelpFAQItem(question: "How do I save a PDF?",
                    answer: "Open a project, choose Preview & Export PDF, then Save PDF. Choose a location using the iOS file exporter."),
        HelpFAQItem(question: "How do I transfer projects?",
                    answer: "Settings > Export Backup saves a JSON file. Transfer the file using Files or a share method of your choice, then use Import Backup on another device. Room images are not included in the JSON backup."),
        HelpFAQItem(question: "Does HomeMeasure work without internet?",
                    answer: "Yes. Measuring, budgeting, shopping lists, local backups and PDF generation all work offline."),
        HelpFAQItem(question: "What measurement units are used?",
                    answer: "Lengths are in meters and areas in square meters. Coverage is entered in square meters per package, meters per piece, or units as labeled."),
        HelpFAQItem(question: "How do I remove my data?",
                    answer: "Delete an individual project from Projects, or remove the entire project library under Settings > Delete All Projects. Exported files are outside the app and must be deleted separately.")
    ]
}
