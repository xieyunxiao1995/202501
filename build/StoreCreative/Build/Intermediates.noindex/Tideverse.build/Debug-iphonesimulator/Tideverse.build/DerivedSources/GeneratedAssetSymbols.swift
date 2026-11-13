import Foundation
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ColorResource {

}

// MARK: - Image Symbols -

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension DeveloperToolsSupport.ImageResource {

    /// The "ada_avatar" asset catalog image resource.
    static let adaAvatar = DeveloperToolsSupport.ImageResource(name: "ada_avatar", bundle: resourceBundle)

    /// The "ada_portrait" asset catalog image resource.
    static let adaPortrait = DeveloperToolsSupport.ImageResource(name: "ada_portrait", bundle: resourceBundle)

    /// The "ada_scene" asset catalog image resource.
    static let adaScene = DeveloperToolsSupport.ImageResource(name: "ada_scene", bundle: resourceBundle)

    /// The "amara_avatar" asset catalog image resource.
    static let amaraAvatar = DeveloperToolsSupport.ImageResource(name: "amara_avatar", bundle: resourceBundle)

    /// The "amara_portrait" asset catalog image resource.
    static let amaraPortrait = DeveloperToolsSupport.ImageResource(name: "amara_portrait", bundle: resourceBundle)

    /// The "amara_scene" asset catalog image resource.
    static let amaraScene = DeveloperToolsSupport.ImageResource(name: "amara_scene", bundle: resourceBundle)

    /// The "anika_avatar" asset catalog image resource.
    static let anikaAvatar = DeveloperToolsSupport.ImageResource(name: "anika_avatar", bundle: resourceBundle)

    /// The "anika_portrait" asset catalog image resource.
    static let anikaPortrait = DeveloperToolsSupport.ImageResource(name: "anika_portrait", bundle: resourceBundle)

    /// The "anika_scene" asset catalog image resource.
    static let anikaScene = DeveloperToolsSupport.ImageResource(name: "anika_scene", bundle: resourceBundle)

    /// The "bastien_avatar" asset catalog image resource.
    static let bastienAvatar = DeveloperToolsSupport.ImageResource(name: "bastien_avatar", bundle: resourceBundle)

    /// The "bastien_portrait" asset catalog image resource.
    static let bastienPortrait = DeveloperToolsSupport.ImageResource(name: "bastien_portrait", bundle: resourceBundle)

    /// The "bastien_scene" asset catalog image resource.
    static let bastienScene = DeveloperToolsSupport.ImageResource(name: "bastien_scene", bundle: resourceBundle)

    /// The "celia_avatar" asset catalog image resource.
    static let celiaAvatar = DeveloperToolsSupport.ImageResource(name: "celia_avatar", bundle: resourceBundle)

    /// The "celia_portrait" asset catalog image resource.
    static let celiaPortrait = DeveloperToolsSupport.ImageResource(name: "celia_portrait", bundle: resourceBundle)

    /// The "celia_scene" asset catalog image resource.
    static let celiaScene = DeveloperToolsSupport.ImageResource(name: "celia_scene", bundle: resourceBundle)

    /// The "daria_avatar" asset catalog image resource.
    static let dariaAvatar = DeveloperToolsSupport.ImageResource(name: "daria_avatar", bundle: resourceBundle)

    /// The "daria_portrait" asset catalog image resource.
    static let dariaPortrait = DeveloperToolsSupport.ImageResource(name: "daria_portrait", bundle: resourceBundle)

    /// The "daria_scene" asset catalog image resource.
    static let dariaScene = DeveloperToolsSupport.ImageResource(name: "daria_scene", bundle: resourceBundle)

    /// The "dimitri_avatar" asset catalog image resource.
    static let dimitriAvatar = DeveloperToolsSupport.ImageResource(name: "dimitri_avatar", bundle: resourceBundle)

    /// The "dimitri_portrait" asset catalog image resource.
    static let dimitriPortrait = DeveloperToolsSupport.ImageResource(name: "dimitri_portrait", bundle: resourceBundle)

    /// The "dimitri_scene" asset catalog image resource.
    static let dimitriScene = DeveloperToolsSupport.ImageResource(name: "dimitri_scene", bundle: resourceBundle)

    /// The "elara_avatar" asset catalog image resource.
    static let elaraAvatar = DeveloperToolsSupport.ImageResource(name: "elara_avatar", bundle: resourceBundle)

    /// The "elara_portrait" asset catalog image resource.
    static let elaraPortrait = DeveloperToolsSupport.ImageResource(name: "elara_portrait", bundle: resourceBundle)

    /// The "elara_scene" asset catalog image resource.
    static let elaraScene = DeveloperToolsSupport.ImageResource(name: "elara_scene", bundle: resourceBundle)

    /// The "ellis_avatar" asset catalog image resource.
    static let ellisAvatar = DeveloperToolsSupport.ImageResource(name: "ellis_avatar", bundle: resourceBundle)

    /// The "ellis_portrait" asset catalog image resource.
    static let ellisPortrait = DeveloperToolsSupport.ImageResource(name: "ellis_portrait", bundle: resourceBundle)

    /// The "ellis_scene" asset catalog image resource.
    static let ellisScene = DeveloperToolsSupport.ImageResource(name: "ellis_scene", bundle: resourceBundle)

    /// The "felix_avatar" asset catalog image resource.
    static let felixAvatar = DeveloperToolsSupport.ImageResource(name: "felix_avatar", bundle: resourceBundle)

    /// The "felix_portrait" asset catalog image resource.
    static let felixPortrait = DeveloperToolsSupport.ImageResource(name: "felix_portrait", bundle: resourceBundle)

    /// The "felix_scene" asset catalog image resource.
    static let felixScene = DeveloperToolsSupport.ImageResource(name: "felix_scene", bundle: resourceBundle)

    /// The "freya_avatar" asset catalog image resource.
    static let freyaAvatar = DeveloperToolsSupport.ImageResource(name: "freya_avatar", bundle: resourceBundle)

    /// The "freya_portrait" asset catalog image resource.
    static let freyaPortrait = DeveloperToolsSupport.ImageResource(name: "freya_portrait", bundle: resourceBundle)

    /// The "freya_scene" asset catalog image resource.
    static let freyaScene = DeveloperToolsSupport.ImageResource(name: "freya_scene", bundle: resourceBundle)

    /// The "hugo_avatar" asset catalog image resource.
    static let hugoAvatar = DeveloperToolsSupport.ImageResource(name: "hugo_avatar", bundle: resourceBundle)

    /// The "hugo_portrait" asset catalog image resource.
    static let hugoPortrait = DeveloperToolsSupport.ImageResource(name: "hugo_portrait", bundle: resourceBundle)

    /// The "hugo_scene" asset catalog image resource.
    static let hugoScene = DeveloperToolsSupport.ImageResource(name: "hugo_scene", bundle: resourceBundle)

    /// The "idris_avatar" asset catalog image resource.
    static let idrisAvatar = DeveloperToolsSupport.ImageResource(name: "idris_avatar", bundle: resourceBundle)

    /// The "idris_portrait" asset catalog image resource.
    static let idrisPortrait = DeveloperToolsSupport.ImageResource(name: "idris_portrait", bundle: resourceBundle)

    /// The "idris_scene" asset catalog image resource.
    static let idrisScene = DeveloperToolsSupport.ImageResource(name: "idris_scene", bundle: resourceBundle)

    /// The "ines_avatar" asset catalog image resource.
    static let inesAvatar = DeveloperToolsSupport.ImageResource(name: "ines_avatar", bundle: resourceBundle)

    /// The "ines_portrait" asset catalog image resource.
    static let inesPortrait = DeveloperToolsSupport.ImageResource(name: "ines_portrait", bundle: resourceBundle)

    /// The "ines_scene" asset catalog image resource.
    static let inesScene = DeveloperToolsSupport.ImageResource(name: "ines_scene", bundle: resourceBundle)

    /// The "jonah_avatar" asset catalog image resource.
    static let jonahAvatar = DeveloperToolsSupport.ImageResource(name: "jonah_avatar", bundle: resourceBundle)

    /// The "jonah_portrait" asset catalog image resource.
    static let jonahPortrait = DeveloperToolsSupport.ImageResource(name: "jonah_portrait", bundle: resourceBundle)

    /// The "jonah_scene" asset catalog image resource.
    static let jonahScene = DeveloperToolsSupport.ImageResource(name: "jonah_scene", bundle: resourceBundle)

    /// The "kai_avatar" asset catalog image resource.
    static let kaiAvatar = DeveloperToolsSupport.ImageResource(name: "kai_avatar", bundle: resourceBundle)

    /// The "kai_portrait" asset catalog image resource.
    static let kaiPortrait = DeveloperToolsSupport.ImageResource(name: "kai_portrait", bundle: resourceBundle)

    /// The "kai_scene" asset catalog image resource.
    static let kaiScene = DeveloperToolsSupport.ImageResource(name: "kai_scene", bundle: resourceBundle)

    /// The "leonie_avatar" asset catalog image resource.
    static let leonieAvatar = DeveloperToolsSupport.ImageResource(name: "leonie_avatar", bundle: resourceBundle)

    /// The "leonie_portrait" asset catalog image resource.
    static let leoniePortrait = DeveloperToolsSupport.ImageResource(name: "leonie_portrait", bundle: resourceBundle)

    /// The "leonie_scene" asset catalog image resource.
    static let leonieScene = DeveloperToolsSupport.ImageResource(name: "leonie_scene", bundle: resourceBundle)

    /// The "lucian_avatar" asset catalog image resource.
    static let lucianAvatar = DeveloperToolsSupport.ImageResource(name: "lucian_avatar", bundle: resourceBundle)

    /// The "lucian_portrait" asset catalog image resource.
    static let lucianPortrait = DeveloperToolsSupport.ImageResource(name: "lucian_portrait", bundle: resourceBundle)

    /// The "lucian_scene" asset catalog image resource.
    static let lucianScene = DeveloperToolsSupport.ImageResource(name: "lucian_scene", bundle: resourceBundle)

    /// The "luna_avatar" asset catalog image resource.
    static let lunaAvatar = DeveloperToolsSupport.ImageResource(name: "luna_avatar", bundle: resourceBundle)

    /// The "luna_portrait" asset catalog image resource.
    static let lunaPortrait = DeveloperToolsSupport.ImageResource(name: "luna_portrait", bundle: resourceBundle)

    /// The "luna_scene" asset catalog image resource.
    static let lunaScene = DeveloperToolsSupport.ImageResource(name: "luna_scene", bundle: resourceBundle)

    /// The "maeve_avatar" asset catalog image resource.
    static let maeveAvatar = DeveloperToolsSupport.ImageResource(name: "maeve_avatar", bundle: resourceBundle)

    /// The "maeve_portrait" asset catalog image resource.
    static let maevePortrait = DeveloperToolsSupport.ImageResource(name: "maeve_portrait", bundle: resourceBundle)

    /// The "maeve_scene" asset catalog image resource.
    static let maeveScene = DeveloperToolsSupport.ImageResource(name: "maeve_scene", bundle: resourceBundle)

    /// The "malik_avatar" asset catalog image resource.
    static let malikAvatar = DeveloperToolsSupport.ImageResource(name: "malik_avatar", bundle: resourceBundle)

    /// The "malik_portrait" asset catalog image resource.
    static let malikPortrait = DeveloperToolsSupport.ImageResource(name: "malik_portrait", bundle: resourceBundle)

    /// The "malik_scene" asset catalog image resource.
    static let malikScene = DeveloperToolsSupport.ImageResource(name: "malik_scene", bundle: resourceBundle)

    /// The "mateo_avatar" asset catalog image resource.
    static let mateoAvatar = DeveloperToolsSupport.ImageResource(name: "mateo_avatar", bundle: resourceBundle)

    /// The "mateo_portrait" asset catalog image resource.
    static let mateoPortrait = DeveloperToolsSupport.ImageResource(name: "mateo_portrait", bundle: resourceBundle)

    /// The "mateo_scene" asset catalog image resource.
    static let mateoScene = DeveloperToolsSupport.ImageResource(name: "mateo_scene", bundle: resourceBundle)

    /// The "mira_avatar" asset catalog image resource.
    static let miraAvatar = DeveloperToolsSupport.ImageResource(name: "mira_avatar", bundle: resourceBundle)

    /// The "mira_portrait" asset catalog image resource.
    static let miraPortrait = DeveloperToolsSupport.ImageResource(name: "mira_portrait", bundle: resourceBundle)

    /// The "mira_scene" asset catalog image resource.
    static let miraScene = DeveloperToolsSupport.ImageResource(name: "mira_scene", bundle: resourceBundle)

    /// The "nico_avatar" asset catalog image resource.
    static let nicoAvatar = DeveloperToolsSupport.ImageResource(name: "nico_avatar", bundle: resourceBundle)

    /// The "nico_portrait" asset catalog image resource.
    static let nicoPortrait = DeveloperToolsSupport.ImageResource(name: "nico_portrait", bundle: resourceBundle)

    /// The "nico_scene" asset catalog image resource.
    static let nicoScene = DeveloperToolsSupport.ImageResource(name: "nico_scene", bundle: resourceBundle)

    /// The "noel_avatar" asset catalog image resource.
    static let noelAvatar = DeveloperToolsSupport.ImageResource(name: "noel_avatar", bundle: resourceBundle)

    /// The "noel_portrait" asset catalog image resource.
    static let noelPortrait = DeveloperToolsSupport.ImageResource(name: "noel_portrait", bundle: resourceBundle)

    /// The "noel_scene" asset catalog image resource.
    static let noelScene = DeveloperToolsSupport.ImageResource(name: "noel_scene", bundle: resourceBundle)

    /// The "nora_avatar" asset catalog image resource.
    static let noraAvatar = DeveloperToolsSupport.ImageResource(name: "nora_avatar", bundle: resourceBundle)

    /// The "nora_portrait" asset catalog image resource.
    static let noraPortrait = DeveloperToolsSupport.ImageResource(name: "nora_portrait", bundle: resourceBundle)

    /// The "nora_scene" asset catalog image resource.
    static let noraScene = DeveloperToolsSupport.ImageResource(name: "nora_scene", bundle: resourceBundle)

    /// The "owen_avatar" asset catalog image resource.
    static let owenAvatar = DeveloperToolsSupport.ImageResource(name: "owen_avatar", bundle: resourceBundle)

    /// The "owen_portrait" asset catalog image resource.
    static let owenPortrait = DeveloperToolsSupport.ImageResource(name: "owen_portrait", bundle: resourceBundle)

    /// The "owen_scene" asset catalog image resource.
    static let owenScene = DeveloperToolsSupport.ImageResource(name: "owen_scene", bundle: resourceBundle)

    /// The "petra_avatar" asset catalog image resource.
    static let petraAvatar = DeveloperToolsSupport.ImageResource(name: "petra_avatar", bundle: resourceBundle)

    /// The "petra_portrait" asset catalog image resource.
    static let petraPortrait = DeveloperToolsSupport.ImageResource(name: "petra_portrait", bundle: resourceBundle)

    /// The "petra_scene" asset catalog image resource.
    static let petraScene = DeveloperToolsSupport.ImageResource(name: "petra_scene", bundle: resourceBundle)

    /// The "rhea_avatar" asset catalog image resource.
    static let rheaAvatar = DeveloperToolsSupport.ImageResource(name: "rhea_avatar", bundle: resourceBundle)

    /// The "rhea_portrait" asset catalog image resource.
    static let rheaPortrait = DeveloperToolsSupport.ImageResource(name: "rhea_portrait", bundle: resourceBundle)

    /// The "rhea_scene" asset catalog image resource.
    static let rheaScene = DeveloperToolsSupport.ImageResource(name: "rhea_scene", bundle: resourceBundle)

    /// The "rowan_avatar" asset catalog image resource.
    static let rowanAvatar = DeveloperToolsSupport.ImageResource(name: "rowan_avatar", bundle: resourceBundle)

    /// The "rowan_portrait" asset catalog image resource.
    static let rowanPortrait = DeveloperToolsSupport.ImageResource(name: "rowan_portrait", bundle: resourceBundle)

    /// The "rowan_scene" asset catalog image resource.
    static let rowanScene = DeveloperToolsSupport.ImageResource(name: "rowan_scene", bundle: resourceBundle)

    /// The "sana_avatar" asset catalog image resource.
    static let sanaAvatar = DeveloperToolsSupport.ImageResource(name: "sana_avatar", bundle: resourceBundle)

    /// The "sana_portrait" asset catalog image resource.
    static let sanaPortrait = DeveloperToolsSupport.ImageResource(name: "sana_portrait", bundle: resourceBundle)

    /// The "sana_scene" asset catalog image resource.
    static let sanaScene = DeveloperToolsSupport.ImageResource(name: "sana_scene", bundle: resourceBundle)

    /// The "seraphine_avatar" asset catalog image resource.
    static let seraphineAvatar = DeveloperToolsSupport.ImageResource(name: "seraphine_avatar", bundle: resourceBundle)

    /// The "seraphine_portrait" asset catalog image resource.
    static let seraphinePortrait = DeveloperToolsSupport.ImageResource(name: "seraphine_portrait", bundle: resourceBundle)

    /// The "seraphine_scene" asset catalog image resource.
    static let seraphineScene = DeveloperToolsSupport.ImageResource(name: "seraphine_scene", bundle: resourceBundle)

    /// The "silas_avatar" asset catalog image resource.
    static let silasAvatar = DeveloperToolsSupport.ImageResource(name: "silas_avatar", bundle: resourceBundle)

    /// The "silas_portrait" asset catalog image resource.
    static let silasPortrait = DeveloperToolsSupport.ImageResource(name: "silas_portrait", bundle: resourceBundle)

    /// The "silas_scene" asset catalog image resource.
    static let silasScene = DeveloperToolsSupport.ImageResource(name: "silas_scene", bundle: resourceBundle)

    /// The "sylvie_avatar" asset catalog image resource.
    static let sylvieAvatar = DeveloperToolsSupport.ImageResource(name: "sylvie_avatar", bundle: resourceBundle)

    /// The "sylvie_portrait" asset catalog image resource.
    static let sylviePortrait = DeveloperToolsSupport.ImageResource(name: "sylvie_portrait", bundle: resourceBundle)

    /// The "sylvie_scene" asset catalog image resource.
    static let sylvieScene = DeveloperToolsSupport.ImageResource(name: "sylvie_scene", bundle: resourceBundle)

    /// The "tessa_avatar" asset catalog image resource.
    static let tessaAvatar = DeveloperToolsSupport.ImageResource(name: "tessa_avatar", bundle: resourceBundle)

    /// The "tessa_portrait" asset catalog image resource.
    static let tessaPortrait = DeveloperToolsSupport.ImageResource(name: "tessa_portrait", bundle: resourceBundle)

    /// The "tessa_scene" asset catalog image resource.
    static let tessaScene = DeveloperToolsSupport.ImageResource(name: "tessa_scene", bundle: resourceBundle)

    /// The "theo_avatar" asset catalog image resource.
    static let theoAvatar = DeveloperToolsSupport.ImageResource(name: "theo_avatar", bundle: resourceBundle)

    /// The "theo_portrait" asset catalog image resource.
    static let theoPortrait = DeveloperToolsSupport.ImageResource(name: "theo_portrait", bundle: resourceBundle)

    /// The "theo_scene" asset catalog image resource.
    static let theoScene = DeveloperToolsSupport.ImageResource(name: "theo_scene", bundle: resourceBundle)

    /// The "vera_avatar" asset catalog image resource.
    static let veraAvatar = DeveloperToolsSupport.ImageResource(name: "vera_avatar", bundle: resourceBundle)

    /// The "vera_portrait" asset catalog image resource.
    static let veraPortrait = DeveloperToolsSupport.ImageResource(name: "vera_portrait", bundle: resourceBundle)

    /// The "vera_scene" asset catalog image resource.
    static let veraScene = DeveloperToolsSupport.ImageResource(name: "vera_scene", bundle: resourceBundle)

    /// The "vincent_avatar" asset catalog image resource.
    static let vincentAvatar = DeveloperToolsSupport.ImageResource(name: "vincent_avatar", bundle: resourceBundle)

    /// The "vincent_portrait" asset catalog image resource.
    static let vincentPortrait = DeveloperToolsSupport.ImageResource(name: "vincent_portrait", bundle: resourceBundle)

    /// The "vincent_scene" asset catalog image resource.
    static let vincentScene = DeveloperToolsSupport.ImageResource(name: "vincent_scene", bundle: resourceBundle)

    /// The "yara_avatar" asset catalog image resource.
    static let yaraAvatar = DeveloperToolsSupport.ImageResource(name: "yara_avatar", bundle: resourceBundle)

    /// The "yara_portrait" asset catalog image resource.
    static let yaraPortrait = DeveloperToolsSupport.ImageResource(name: "yara_portrait", bundle: resourceBundle)

    /// The "yara_scene" asset catalog image resource.
    static let yaraScene = DeveloperToolsSupport.ImageResource(name: "yara_scene", bundle: resourceBundle)

    /// The "zane_avatar" asset catalog image resource.
    static let zaneAvatar = DeveloperToolsSupport.ImageResource(name: "zane_avatar", bundle: resourceBundle)

    /// The "zane_portrait" asset catalog image resource.
    static let zanePortrait = DeveloperToolsSupport.ImageResource(name: "zane_portrait", bundle: resourceBundle)

    /// The "zane_scene" asset catalog image resource.
    static let zaneScene = DeveloperToolsSupport.ImageResource(name: "zane_scene", bundle: resourceBundle)

}

