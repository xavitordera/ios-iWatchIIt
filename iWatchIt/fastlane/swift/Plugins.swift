import Foundation
/**
 Semaphore CI integration

 - parameter force: Force setup, even if not executed by Semaphore CI

 This plugin provides actions for setiing up Semaphore CI environment
*/
func setupSemaphore(force: Bool = false) {
  let command = RubyCommand(commandID: "", methodName: "setup_semaphore", className: nil, args: [RubyCommand.Argument(name: "force", value: force)])
  _ = runner.executeCommand(command)
}
