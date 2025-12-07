// -----------------------------------------------------------------------------
// Counting Beams

const std = @import("std");
const Allocator = std.mem.Allocator;

const aoc = @import("aoc");

const Counter = @import("counter").Counter(usize);

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

    var beams: Counter = .init(allocator);
    defer beams.deinit();

    const start = std.mem.indexOfScalar(u8, lines[0], 'S').?;
    try beams.increment(start, 1);

    var j: usize = 2;
    while (j < lines.len) : (j += 2) {
        const line = lines[j];

        var new: Counter = .init(allocator);
        defer new.deinit();
        try new.map.ensureTotalCapacity(@intCast(line.len));

        for (beams.keys(), beams.values()) |i, n| {
            if (line[i] == '^') {
                result.p1 += 1;
                try new.increment(i - 1, n);
                try new.increment(i + 1, n);
            } else {
                try new.increment(i, n);
            }
        }
        beams = try new.clone();
    }

    result.p2 = beams.total();

    return result;
}

pub fn main() !void {
    var arena: std.heap.ArenaAllocator = .init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const solver: aoc.AOCSolver(Result) = .init(
        2025,
        7,
        solve,
        Result{ .p1 = 21, .p2 = 40 },
        Result{ .p1 = 1660, .p2 = 305999729392659 },
    );

    solver.info();

    try solver.run(allocator, true);
    try solver.run(allocator, false);
}

// EOF -------------------------------------------------------------------------
