// -----------------------------------------------------------------------------
// Counting Adjacents

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

const PointSet = std.AutoArrayHashMap(pos.Point, void);

pub fn removePaper(allocator: Allocator, paper: *PointSet) !usize {
    var removable = try std.ArrayList(pos.Point).initCapacity(allocator, 512);
    defer removable.deinit(allocator);

    var it = paper.iterator();
    while (it.next()) |e| {
        const p = e.key_ptr.*;

        var cnt: u8 = 0;
        for (pos.dir8_map.values()) |d|
            cnt += @intFromBool(paper.contains(p + d));

        if (cnt < 4) try removable.append(allocator, p);
    }

    for (removable.items) |p| _ = paper.swapRemove(p);

    return removable.items.len;
}

pub fn solve(allocator: Allocator, data: []const u8, test_run: bool) !Result {
    _ = test_run;

    var result: Result = .{ .p1 = 0, .p2 = 0 };

    var paper: PointSet = .init(allocator);
    defer paper.deinit();
    try paper.ensureTotalCapacity(@intCast(data.len));

    const lines = try aoc.splitlines(allocator, data);
    defer allocator.free(lines);

    for (0.., lines) |y, r| {
        for (0.., r) |x, c| {
            if (c != '@') continue;

            const p: pos.Point = .{ @intCast(x), @intCast(y) };
            try paper.put(p, {});
        }
    }

    while (true) {
        const res = try removePaper(allocator, &paper);
        if (res == 0) break;

        result.p2 += res;
        if (result.p1 == 0) result.p1 = res;
    }

    return result;
}

pub fn main() !void {
    var arena: std.heap.ArenaAllocator = .init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const solver: aoc.AOCSolver(Result) = .init(
        2025,
        4,
        solve,
        Result{ .p1 = 13, .p2 = 43 },
        Result{ .p1 = 1551, .p2 = 9784 },
    );

    solver.info();

    try solver.run(allocator, true);
    try solver.run(allocator, false);
}

// EOF -------------------------------------------------------------------------
