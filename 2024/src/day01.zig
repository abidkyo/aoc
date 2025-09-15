// -----------------------------------------------------------------------------

const std = @import("std");
const Allocator = std.mem.Allocator;

const aoc = @import("aoc");

pub fn solve(allocator: Allocator, _: []const u8, _: bool) []const u8 {
    const p1 = 0;
    const p2 = 0;

    const result = std.fmt.allocPrint(
        allocator,
        "p1 = {d}, p2 = {d}",
        .{ p1, p2 },
    ) catch unreachable;
    return result;
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

    _ = solver.run();
}

// EOF -------------------------------------------------------------------------
