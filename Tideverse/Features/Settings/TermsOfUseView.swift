import SwiftUI

struct TermsOfUseView: View {
    var body: some View {
        LegalArticleView(title: "EULA & Terms of Use", intro: "This End User License Agreement explains your permission to use Tideverse and the responsibilities that accompany its interactive stories and optional AI conversations. Review it before agreeing to enter the app.", sections: [
            ("1. About the service", "Tideverse provides original interactive fiction, offline story choices and optional third-party AI conversations. All AI characters are fictional and are not real people."),
            ("2. Your responsibilities", "Use the application lawfully and respectfully. Do not submit unlawful, abusive or privacy-infringing requests, or content you do not have permission to share. Do not attempt to misuse the AI service or circumvent security controls."),
            ("3. AI-generated content", "Responses are generated automatically and may be incomplete or inaccurate. They are part of an entertainment experience, not professional medical, legal, financial or emergency guidance. Do not rely on them for consequential decisions."),
            ("4. Personal data", "Your local conversations, saved memories and story choices remain on your device unless you choose to export them or enable online AI. Accepting this EULA does not authorize AI data transfers. A separate AI data notice and opt-in are required before online requests. You can decline that permission and still use offline stories. See the Privacy Policy for processing details."),
            ("5. Content and licenses", "Subject to these terms, the publisher grants you a personal, non-exclusive, non-transferable license to use the app on devices you own or control as permitted by the applicable store terms. App code, original story text, artwork and user interface elements may be subject to copyright and other intellectual property rights. You retain rights to content you lawfully contribute. Do not redistribute included assets as a competing product without permission."),
            ("6. Availability and changes", "Online features depend on service availability, network access and model-provider terms. Features may evolve as the application is updated. Any purchase features added later will be disclosed separately."),
            ("7. Safety and reporting", "Use Feedback & Suggestions to report inappropriate AI responses or product defects. Avoid sharing sensitive information with fictional AI characters."),
            ("8. Questions and support", "You can reopen this agreement in Settings. Developer Information lists the available publisher and support details. Use Feedback & Suggestions to prepare a product question or report, review what it contains, and share it using your chosen app. Sharing a report does not itself confirm delivery or a response.")
        ])
    }
}
