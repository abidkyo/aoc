// -----------------------------------------------------------------------------

const std = @import("std");
const Allocator = std.mem.Allocator;

const aoc = @import("aoc");

pub const Result = struct {
    p1: u32,
    p2: u32,
};

pub fn solve(allocator: Allocator, data: []const u8, test_run: bool) !Result {
    _ = allocator;
    _ = data;
    _ = test_run;

    var result: Result = .{ .p1 = 0, .p2 = 0 };

    result.p1 = 0;
    result.p2 = 0;

    return result;
}

pub fn main() !void {
    var arena: std.heap.ArenaAllocator = .init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const solver: aoc.AOCSolver(Result) = .init(
        2024,
        1,
        allocator,
        solve,
    );

    solver.info();

    _ = try solver.run(true);
    // _ = try solver.run(false);
}

// EOF -------------------------------------------------------------------------
