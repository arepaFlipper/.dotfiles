// Usage: dimscreen 0.5 [invert]   (1 = normal brightness). Ctrl+C restores the screen.
// Scales (and optionally inverts) the display gamma table; macOS resets it when this process exits.
import CoreGraphics
import Foundation

let args = CommandLine.arguments.dropFirst()
let level = Float(args.first ?? "0.5") ?? 0.5
let invert = args.contains("invert")

let size = 256
let table: [CGGammaValue] = (0..<size).map { i in
    let v = Float(i) / Float(size - 1)
    return (invert ? 1 - v : v) * level
}

var ids = [CGDirectDisplayID](repeating: 0, count: 8)
var count: UInt32 = 0
CGGetActiveDisplayList(8, &ids, &count)
for id in ids.prefix(Int(count)) {
    CGSetDisplayTransferByTable(id, UInt32(size), table, table, table)
}

signal(SIGINT) { _ in exit(0) }
dispatchMain()
