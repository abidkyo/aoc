// -----------------------------------------------------------------------------

const std = @import("std");
const Allocator = std.mem.Allocator;

const aoc = @import("aoc");

pub fn solve(allocator: Allocator, data: []const u8, test_run: bool) ![]const u8 {
    var p1: u32 = 0;
    var p2: u32 = 0;

    if (!test_run) return "";
    // _ = test_run;
    _ = data;

    p1 = 0;
    p2 = 0;

    const result = try std.fmt.allocPrint(
        allocator,
        "p1 = {d}, p2 = {d}",
        .{ p1, p2 },
    );
    return result;
}

pub fn main() !void {
    var arena: std.heap.ArenaAllocator = .init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const solver: aoc.AOCSolver = .{
        .year = "{{year}}",
        .day = "{{day}}",
        .allocator = allocator,
        .solve = solve,
    };

    solver.info();

    _ = try solver.run();
}

// EOF -------------------------------------------------------------------------
