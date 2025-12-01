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

pub fn dfs(allocator: Allocator, grid: std.AutoHashMap(pos.Point, u8), start: pos.Point, p1: bool) !u32 {
    var stack = try std.ArrayList(pos.Point).initCapacity(allocator, 8);
    defer stack.deinit(allocator);
    try stack.appendBounded(start);

    var seen: std.AutoHashMap(pos.Point, void) = .init(allocator);
    defer seen.deinit();
    try seen.ensureTotalCapacity(grid.count());

    var n: u32 = 0;
    while (stack.pop()) |p| {
        if (p1 and seen.contains(p)) {
            continue;
        }
        try seen.put(p, {});

        if (grid.get(p).? == 9) {
            n += 1;
            continue;
        }

        for (pos.dir4) |d| {
            const np = p + d.fromEnum();

            if (grid.contains(np) and grid.get(np).? -| grid.get(p).? == 1) {
                try stack.appendBounded(np);
            }
        }
    }

    return n;
}

pub fn solve(allocator: Allocator, data: []const u8, test_run: bool) !Result {
    _ = test_run;

    var result: Result = .{ .p1 = 0, .p2 = 0 };

    var start = try std.ArrayList(pos.Point).initCapacity(allocator, 512);
    defer start.deinit(allocator);

    var grid: std.AutoHashMap(pos.Point, u8) = .init(allocator);
    defer grid.deinit();
    try grid.ensureTotalCapacity(@intCast(data.len));

    const lines = try aoc.splitlines(allocator, data);
    defer allocator.free(lines);

    for (0.., lines) |y, r| {
        for (0.., r) |x, c| {
            const p: pos.Point = .{ @intCast(x), @intCast(y) };
            const n: u8 = try std.fmt.charToDigit(c, 10);

            try grid.put(p, n);

            if (n == 0) {
                try start.appendBounded(p);
            }
        }
    }

    for (start.items) |s| {
        result.p1 += try dfs(allocator, grid, s, true);
        result.p2 += try dfs(allocator, grid, s, false);
    }

    return result;
}

pub fn main() !void {
    var arena: std.heap.ArenaAllocator = .init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const solver: aoc.AOCSolver(Result) = .init(
        2024,
        10,
        solve,
        Result{ .p1 = 36, .p2 = 81 },
        Result{ .p1 = 816, .p2 = 1960 },
    );

    solver.info();

    try solver.run(allocator, true);
    try solver.run(allocator, false);
}

// EOF -------------------------------------------------------------------------
