// -----------------------------------------------------------------------------

const std = @import("std");
const Allocator = std.mem.Allocator;

const aoc = @import("aoc");

pub fn solve(_: Allocator, _: []const u8) []const u8 {
    return "done";
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const solver = aoc.AOCSolver{
        .year = 2024,
        .day = 1,
        .allocator = allocator,
        .solve = solve,
    };

    solver.info();

    const res = solver.run();
    std.log.info("{s}", .{res});
}

// EOF -------------------------------------------------------------------------
