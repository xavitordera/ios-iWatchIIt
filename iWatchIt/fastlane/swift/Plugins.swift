import Foundation
/**
 Semaphore CI integration

 - parameter force: Force setup, even if not executed by Semaphore CI

 This plugin provides actions for setiing up Semaphore CI environment
*/
public func setupSemaphore(force: OptionalConfigValue<Bool> = .fastlaneDefault(false)) {
let forceArg = force.asRubyArgument(name: "force", type: nil)
let array: [RubyCommand.Argument?] = [forceArg]
let args: [RubyCommand.Argument] = array
.filter { $0?.value != nil }
.compactMap { $0 }
let command = RubyCommand(commandID: "", methodName: "setup_semaphore", className: nil, args: args)
  _ = runner.executeCommand(command)
}
