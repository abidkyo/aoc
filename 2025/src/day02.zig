// -----------------------------------------------------------------------------
// Repeating Digits

const std = @import("std");
const Allocator = std.mem.Allocator;

const aoc = @import("aoc");

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

    var i: usize = 0;
    var j: usize = 0;
    var ranges = std.mem.splitScalar(u8, data, ',');

    while (ranges.next()) |line| {
        var it = std.mem.splitScalar(u8, line, '-');

        i = try std.fmt.parseUnsigned(usize, it.next().?, 10);
        j = try std.fmt.parseUnsigned(usize, it.next().?, 10);

        for (i..(j + 1)) |num| {
            const s = try std.fmt.allocPrint(allocator, "{d}", .{num});
            defer allocator.free(s);

            if (isSequenceRepeatedTwice(s)) result.p1 += num;
            if (isSequenceRepeated(s)) result.p2 += num;
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
        2,
        solve,
        Result{ .p1 = 1227775554, .p2 = 4174379265 },
        Result{ .p1 = 30599400849, .p2 = 46270373595 },
    );

    solver.info();

    try solver.run(allocator, true);
    try solver.run(allocator, false);
}

pub fn isSequenceRepeatedTwice(slice: []const u8) bool {
    if (slice.len % 2 != 0) return false;

    if (std.mem.eql(u8, slice[0..(slice.len / 2)], slice[(slice.len / 2)..])) {
        return true;
    }
    return false;
}

pub fn isSequenceRepeated(slice: []const u8) bool {
    for (1..slice.len) |k| {
        if (slice.len % k != 0) continue;

        if (std.mem.eql(u8, slice[0..(slice.len - k)], slice[k..])) {
            return true;
        }
    }
    return false;
}

// EOF -------------------------------------------------------------------------
