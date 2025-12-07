// -----------------------------------------------------------------------------

const std = @import("std");
const Allocator = std.mem.Allocator;

const aoc = @import("aoc");
const pos = @import("position");

pub const Result = struct {
    p1: usize,
    p2: usize,

    pub fn format(self: @This(), writer: *std.Io.Writer) std.Io.Writer.Error!void {
        return writer.print("p1 = {d}, p2 = {d}", .{ self.p1, self.p2 });
    }
};

pub fn solve(allocator: Allocator, data: []const u8, test_run: bool) !Result {
    _ = test_run;

    var result: Result = .{ .p1 = 0, .p2 = 0 };

    const lines = try aoc.splitlines(allocator, data);
    defer allocator.free(lines);

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
        "{{year}}",
        "{{day}}",
        solve,
        Result{ .p1 = 0, .p2 = 0 },
        Result{ .p1 = 0, .p2 = 0 },
    );

    solver.info();

    try solver.run(allocator, true);
    // try solver.run(allocator, false);
}

// EOF -------------------------------------------------------------------------
