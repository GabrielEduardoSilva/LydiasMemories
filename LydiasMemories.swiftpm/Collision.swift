import Foundation

struct Collision {
    static var noCollision: UInt32 = 0
    static var character: UInt32 = 1 << 1
    static var platform: UInt32 = 1 << 2
    static var projectile: UInt32 = 1 << 3
    static var collectibleMemory: UInt32 = 1 << 4
}
