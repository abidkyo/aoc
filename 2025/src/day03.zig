// -----------------------------------------------------------------------------
// Finding Largest Numbers

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

pub fn getMax(line: []const u8, comptime n: usize) usize {
    var val: [n]u8 = undefined;
    @memcpy(&val, line[line.len - n ..]);

    var i = line.len - n;

    while (i > 0) : (i -= 1) {
        var c = line[i - 1];

        for (&val) |*v| {
            if (c >= v.*) {
                const tmp = v.*;
                v.* = c;
                c = tmp;
            } else break;
        }
    }

    return std.fmt.parseUnsigned(usize, &val, 10) catch 0;
}

pub fn solve(allocator: Allocator, data: []const u8, test_run: bool) !Result {
    _ = test_run;
    _ = allocator;

    var result: Result = .{ .p1 = 0, .p2 = 0 };

    var it = std.mem.splitScalar(u8, data, '\n');

    while (it.next()) |line| {
        result.p1 += getMax(line, 2);
        result.p2 += getMax(line, 12);
    }

    return result;
}

pub fn main() !void {
    var arena: std.heap.ArenaAllocator = .init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const solver: aoc.AOCSolver(Result) = .init(
        2025,
        3,
        solve,
        Result{ .p1 = 357, .p2 = 3121910778619 },
        Result{ .p1 = 17087, .p2 = 169019504359949 },
    );

    solver.info();

    try solver.run(allocator, true);
    try solver.run(allocator, false);
}

// EOF -------------------------------------------------------------------------
