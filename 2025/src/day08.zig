// -----------------------------------------------------------------------------
// Finding Connections

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

const Point3d = @Vector(3, usize);
const State = struct { usize, usize, usize };

pub fn calcDist(a: Point3d, b: Point3d) usize {
    const _a: @Vector(3, isize) = @intCast(a);
    const _b: @Vector(3, isize) = @intCast(b);
    return @reduce(.Add, @abs(_a - _b) * @abs(_a - _b));
}

pub fn lessThan(_: void, a: State, b: State) bool {
    return a[2] < b[2];
}

pub fn solve(allocator: Allocator, data: []const u8, test_run: bool) !Result {
    var result: Result = .{ .p1 = 0, .p2 = 0 };

    var points: std.ArrayList(Point3d) = try .initCapacity(allocator, data.len);
    defer points.deinit(allocator);

    var it = std.mem.splitScalar(u8, data, '\n');
    while (it.next()) |line| {
        var _it = std.mem.tokenizeScalar(u8, line, ',');
        const p: Point3d = .{
            try std.fmt.parseUnsigned(u32, _it.next().?, 10),
            try std.fmt.parseUnsigned(u32, _it.next().?, 10),
            try std.fmt.parseUnsigned(u32, _it.next().?, 10),
        };
        points.appendAssumeCapacity(p);
    }
    const points_len = points.items.len;

    var states: std.ArrayList(State) = try .initCapacity(
        allocator,
        points_len * (points_len - 1) / 2,
    );
    defer states.deinit(allocator);

    for (0..points_len) |i| {
        for ((i + 1)..points_len) |j| {
            const dist = calcDist(points.items[i], points.items[j]);
            states.appendAssumeCapacity(.{ i, j, dist });
        }
    }
    std.mem.sort(State, states.items, {}, lessThan);

    var map = try allocator.alloc(usize, points_len);
    defer allocator.free(map);
    for (0..map.len) |i| map[i] = i;

    const target: usize = if (test_run) 10 else 1000;
    for (0.., states.items) |t, state| {
        if (t == target) {
            var counter: Counter = .init(allocator);
            defer counter.deinit();

            try counter.addFromSlice(map);
            counter.sortDesc();

            const largest: @Vector(3, usize) = counter.values()[0..3].*;
            result.p1 = @reduce(.Mul, largest);
        }

        const i, const j, _ = state;

        const ci, const cj = .{ map[i], map[j] };
        if (ci == cj) continue;

        const y = @min(i, j);
        for (0.., map) |x, c| {
            if (c == ci or c == cj) map[x] = y;
        }

        if (std.mem.allEqual(usize, map, map[0])) {
            result.p2 = (points.items[i][0] * points.items[j][0]);
            break;
        }
    }

    return result;
}

pub fn main() !void {
    var arena: std.heap.ArenaAllocator = .init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const solver: aoc.AOCSolver(Result) = .init(
        2025,
        8,
        solve,
        Result{ .p1 = 40, .p2 = 25272 },
        Result{ .p1 = 123234, .p2 = 9259958565 },
    );

    solver.info();

    try solver.run(allocator, true);
    try solver.run(allocator, false);
}

// EOF -------------------------------------------------------------------------
