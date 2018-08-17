import Cocoa

let delegate = AppDelegate()
NSApplication.shared.delegate = delegate
let errorCode = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
exit(errorCode)
