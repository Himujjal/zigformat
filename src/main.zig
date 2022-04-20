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

    var iter = try std.process.argsWithAllocator(a);
    defer iter.deinit();

    var i: u2 = 0;
    var filePath: ?[:0]u8 = undefined;
    while (iter.next(a)) |arg| : (i += 1) {
        if (i == 1) {
            filePath = try arg;
            break;
        }
    }

    if (filePath != null and filePath.?.len != 0) {
        // open file and get info
        var file = try std.fs.cwd().openFile(filePath.?, .{});
        defer file.close();

        const stat = try file.stat();
        var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        defer arena.deinit();
        var allocator = arena.allocator();

        var memory = try allocator.alloc(u8, stat.size + 1);
        memory[stat.size] = 0;

        try file.seekTo(0);
        _ = try file.readAll(memory);

        var memory2: [:0]u8 = memory[0..stat.size:0];

        for (memory) |b, j| {
            memory2[j] = b;
        }

        if (stat.size != 0) {
            var out = try format(a, memory2);
            std.debug.print("{s}", .{out});
        }
    }
}
