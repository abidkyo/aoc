// -----------------------------------------------------------------------------
// Merging Ranges

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

pub const Range = struct {
    lb: usize,
    ub: usize,

    const Self = @This();

    pub fn compareFn(x: usize, self: Self) std.math.Order {
        if (x < self.lb) return .lt;
        if (x > self.ub) return .gt;
        return .eq;
    }

    pub fn lessThan(_: void, a: Self, b: Self) bool {
        return a.lb < b.lb;
    }

    pub fn overlaps(self: Self, other: Self) bool {
        return @max(self.lb, other.lb) <= @min(self.ub, other.ub);
    }

    pub fn merges(self: *Self, other: Self) void {
        self.lb = @min(self.lb, other.lb);
        self.ub = @max(self.ub, other.ub);
    }
};

pub fn parseRanges(allocator: Allocator, data: []const u8) ![]Range {
    var ranges: std.ArrayList(Range) = try .initCapacity(allocator, 256);
    defer ranges.deinit(allocator);

    var data_it = std.mem.splitScalar(u8, data, '\n');
    while (data_it.next()) |range| {
        var it = std.mem.splitScalar(u8, range, '-');

        const lb = try std.fmt.parseUnsigned(usize, it.next().?, 10);
        const ub = try std.fmt.parseUnsigned(usize, it.next().?, 10);

        ranges.appendAssumeCapacity(.{ .lb = lb, .ub = ub });
    }

    std.mem.sort(Range, ranges.items, {}, Range.lessThan);

    var pr = ranges.items.ptr;
    for (ranges.items[1..]) |r| {
        if (pr[0].overlaps(r)) {
            pr[0].merges(r);
        } else {
            pr += 1;
            pr[0] = r;
        }
    }
    ranges.shrinkRetainingCapacity(pr - ranges.items.ptr + 1);

    return try ranges.toOwnedSlice(allocator);
}

pub fn solve(allocator: Allocator, data: []const u8, test_run: bool) !Result {
    _ = test_run;

    var result: Result = .{ .p1 = 0, .p2 = 0 };

    const _data = try aoc.split(allocator, data, "\n\n");
    defer allocator.free(_data);

    const ranges = try parseRanges(allocator, _data[0]);
    defer allocator.free(ranges);

    var it = std.mem.splitScalar(u8, _data[1], '\n');
    while (it.next()) |id| {
        const x = try std.fmt.parseUnsigned(usize, id, 10);

        if (std.sort.binarySearch(Range, ranges, x, Range.compareFn)) |_| {
            result.p1 += 1;
        }
    }

    for (ranges) |r| {
        result.p2 += r.ub - r.lb + 1;
    }

    return result;
}

pub fn main() !void {
    var arena: std.heap.ArenaAllocator = .init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const solver: aoc.AOCSolver(Result) = .init(
        2025,
        5,
        solve,
        Result{ .p1 = 3, .p2 = 14 },
        Result{ .p1 = 865, .p2 = 352556672963116 },
    );

    solver.info();

    try solver.run(allocator, true);
    try solver.run(allocator, false);
}

// EOF -------------------------------------------------------------------------
