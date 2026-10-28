import Foundation

enum ProjectEditError: LocalizedError {
    case changed, missingRoom
    var errorDescription: String? {
        switch self {
        case .changed: "This item was changed or deleted elsewhere. Close the editor and reopen it to see the latest data."
        case .missingRoom: "The selected room no longer exists. Close the editor and choose an available room."
        }
    }
}
