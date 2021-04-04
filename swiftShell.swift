//#!/usr/bin/swift
import Foundation

enum PromptShellColor: String {

    case red = "\\033[31m"
    case green = "\\033[32m"
    case yellow = "\\033[33m"
    case blue = "\\033[34m"
    case rest = "\\033[0m"

    static func prompt(color: PromptShellColor, text: String = "") -> String {
        return shell("echo \"\(color.rawValue)\(text)\"")
    }
}


extension Process {
    public func shell(_ command: String, type: String = "zsh") -> String {
        let pipe = Pipe()
        standardOutput = pipe
        standardError = pipe
        arguments = ["-c", command]
        launchPath = "/bin/\(type)"
        launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
    
        return output
    }
    
}

func shell(_ command: String) -> String {
    let task = Process()
    let pipe = Pipe()
    
    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = ["-c", command]
    task.launchPath = "/bin/zsh"
    task.launch()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!
    
    return output
}

func userPrompt() -> String {
    let currentDir = shell("pwd").dropLast()
    let currentUser = shell("whoami").dropLast()

    let coloredCurrentDir = PromptShellColor.prompt(color: .red, text: "[\(currentDir)]").dropLast()
    let coloredCurrentUser = PromptShellColor.prompt(color: .green, text: String(currentUser)).dropLast()
    let rest = PromptShellColor.prompt(color: .rest, text: "").dropLast()

    return "\n\(coloredCurrentDir)\n\(coloredCurrentUser) -> \(rest)"
}

func runMain() {
    let ascii="""
                    | 
____________    __ -+-  ____________ 
\\_____     /   /_ \\ |   \\     _____/
 \\_____    \\____/  \\____/    _____/
  \\_____                    _____/
     \\___________  ___________/
               /____\\
"""

    print("\(ascii) \n")
    print("\n\(PromptShellColor.prompt(color: .blue, text:shell("cal")))")
}

func changeDir(_ str: String) {
    let fm = FileManager()
    let path = String(str.split(separator: " ")[1])
    fm.changeCurrentDirectoryPath("\(path)")
}

runMain()

while(true) {
    print("\(userPrompt())", terminator: "")
    if let cmds = readLine() {
        if cmds.contains("cd ") {
            changeDir(cmds)
        }
        print(shell(cmds))
    } else {
        print("none")
    }
}

