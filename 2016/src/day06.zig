// -----------------------------------------------------------------------------

const std = @import("std");
const Allocator = std.mem.Allocator;

const aoc = @import("aoc");

const Counter = @import("counter").Counter(u8);

pub const Result = struct {
    p1: []const u8,
    p2: []const u8,

    pub fn format(self: @This(), writer: *std.Io.Writer) std.Io.Writer.Error!void {
        return writer.print("p1 = {s}, p2 = {s}", .{ self.p1, self.p2 });
    }
};

pub fn solve(allocator: Allocator, data: []const u8, test_run: bool) !Result {
    _ = test_run;

    var result: Result = .{ .p1 = undefined, .p2 = undefined };

    const lines = try aoc.splitlines(allocator, data);
    defer allocator.free(lines);

    var most: std.ArrayList(u8) = try .initCapacity(allocator, lines.len);
    var least: std.ArrayList(u8) = try .initCapacity(allocator, lines.len);
    defer most.deinit(allocator);
    defer least.deinit(allocator);

    for (0..lines[0].len) |c| {
        var count: Counter = .init(allocator);
        defer count.deinit();

        for (lines) |line| {
            try count.increment(line[c], 1);
        }

        count.sortDesc();
        const keys = count.keys();

        most.appendAssumeCapacity(keys[0]);
        least.appendAssumeCapacity(keys[keys.len - 1]);
    }

    result.p1 = try most.toOwnedSlice(allocator);
    result.p2 = try least.toOwnedSlice(allocator);

    return result;
}

pub fn main() !void {
    var arena: std.heap.ArenaAllocator = .init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const solver: aoc.AOCSolver(Result) = .init(
        2016,
        6,
        solve,
        Result{ .p1 = "easter", .p2 = "advent" },
        Result{ .p1 = "nabgqlcw", .p2 = "ovtrjcjh" },
    );

    solver.info();

    try solver.run(allocator, true);
    try solver.run(allocator, false);
}

// EOF -------------------------------------------------------------------------
