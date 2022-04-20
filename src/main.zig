const std = @import("std");
const warn = std.debug.warn;

fn format(allocator: std.mem.Allocator, source: [:0]const u8) ![]u8 {
    var tree = try std.zig.parse(allocator, source);
    defer tree.deinit(allocator);

    if (tree.errors.len != 0) {
        return error.ParseError;
    }
    return try tree.render(allocator);
}

pub fn main() anyerror!void {
    var a = std.testing.allocator;

    var arena = std.heap.ArenaAllocator.init(a);
    defer arena.deinit();
    var allocator = arena.allocator();

    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    // max 50 mb file
    const fileContent = try stdin.readAllAlloc(allocator, 50 * 1024 * 1024);
    const len = (fileContent.len - 1);
    fileContent[len] = 0;
    var fileContent2: [:0]u8 = fileContent[0..len:0];

    const out = try format(a, fileContent2);
    try stdout.print("{s}", .{out});
}
