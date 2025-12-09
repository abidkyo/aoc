// -----------------------------------------------------------------------------

const std = @import("std");
const Allocator = std.mem.Allocator;

const aoc = @import("aoc");
const pos = @import("position");

const PointList = std.ArrayList(pos.Point);

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

    var points: PointList = try .initCapacity(allocator, data.len);
    defer points.deinit(allocator);

    var it = std.mem.splitScalar(u8, data, '\n');
    while (it.next()) |line| {
        const sep = std.mem.indexOfScalar(u8, line, ',').?;
        points.appendAssumeCapacity(.{
            try std.fmt.parseUnsigned(i32, line[0..sep], 10),
            try std.fmt.parseUnsigned(i32, line[sep + 1 ..], 10),
        });
    }

    const ones: @Vector(2, u32) = @splat(1);
    const ps = points.items;

    var max_area: usize = 0;
    for (0..ps.len) |i| {
        for ((i + 1)..ps.len) |j| {
            const p = @abs(ps[i] - ps[j]) + ones;
            const area: usize = std.math.mulWide(u32, p[0], p[1]);

            max_area = @max(max_area, area);
        }
    }

    result.p1 = max_area;
    result.p2 = 0;

    return result;
}

pub fn main() !void {
    var arena: std.heap.ArenaAllocator = .init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const solver: aoc.AOCSolver(Result) = .init(
        2025,
        9,
        solve,
        Result{ .p1 = 50, .p2 = 0 },
        Result{ .p1 = 4741451444, .p2 = 0 },
    );

    solver.info();

    try solver.run(allocator, true);
    try solver.run(allocator, false);
}

// EOF -------------------------------------------------------------------------
