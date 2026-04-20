//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

<<<<<<< HEAD
import path_provider_foundation

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
=======
import file_picker
import path_provider_foundation

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  FilePickerPlugin.register(with: registry.registrar(forPlugin: "FilePickerPlugin"))
>>>>>>> 49ac350 (update)
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
}
