// -----------------------------------------------------------------------------

const std = @import("std");
const Allocator = std.mem.Allocator;

const aoc = @import("aoc");
const pos = @import("position");

pub const Result = struct {
    p1: u32,
    p2: u32,

    pub fn format(self: @This(), writer: *std.Io.Writer) std.Io.Writer.Error!void {
        return writer.print("p1 = {d}, p2 = {d}", .{ self.p1, self.p2 });
    }
};

pub fn solve(allocator: Allocator, data: []const u8, test_run: bool) !Result {
    _ = test_run;

    var result: Result = .{ .p1 = undefined, .p2 = undefined };

    const lines = try aoc.splitlines(allocator, data);

    for (lines) |line| {
        _ = line;
    }

    result.p1 = 0;
    result.p2 = 0;

    return result;
}

pub fn main() !void {
    var arena: std.heap.ArenaAllocator = .init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const solver: aoc.AOCSolver(Result) = .init(
        2014,
        1,
        solve,
        Result{ .p1 = undefined, .p2 = undefined },
        Result{ .p1 = undefined, .p2 = undefined },
    );

    solver.info();

    try solver.run(allocator, true);
    // try solver.run(allocator, false);
}

// EOF -------------------------------------------------------------------------
