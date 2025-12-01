// -----------------------------------------------------------------------------

const std = @import("std");
const Allocator = std.mem.Allocator;

const aoc = @import("aoc");
const pos = @import("position");

pub const Result = struct {
    p1: u16,
    p2: u16,

    pub fn format(self: @This(), writer: *std.Io.Writer) std.Io.Writer.Error!void {
        return writer.print("p1 = {d}, p2 = {d}", .{ self.p1, self.p2 });
    }
};

pub fn solve(allocator: Allocator, data: []const u8, test_run: bool) !Result {
    _ = test_run;

    var result: Result = .{ .p1 = 0, .p2 = 0 };

    result.p1 = @intFromBool(false);

    const lines = try aoc.splitlines(allocator, data);

    var a: [3]u16 = .{ 0, 0, 0 };
    var b: [3]u16 = .{ 0, 0, 0 };
    var c: [3]u16 = .{ 0, 0, 0 };
    var d: [3]u16 = .{ 0, 0, 0 };

    var i: u2 = 0;
    for (lines) |line| {
        var it = std.mem.tokenizeScalar(u8, line, ' ');

        const n1 = try std.fmt.parseUnsigned(u16, it.next().?, 10);
        const n2 = try std.fmt.parseUnsigned(u16, it.next().?, 10);
        const n3 = try std.fmt.parseUnsigned(u16, it.next().?, 10);

        a = .{ n1, n2, n3 };
        b[i], c[i], d[i] = a;

        i += 1;

        std.mem.sort(u16, &a, {}, std.sort.asc(u16));
        result.p1 += @intFromBool(a[0] + a[1] > a[2]);

        if (i == 3) {
            std.mem.sort(u16, &b, {}, std.sort.asc(u16));
            std.mem.sort(u16, &c, {}, std.sort.asc(u16));
            std.mem.sort(u16, &d, {}, std.sort.asc(u16));

            result.p2 += @intFromBool(b[0] + b[1] > b[2]);
            result.p2 += @intFromBool(c[0] + c[1] > c[2]);
            result.p2 += @intFromBool(d[0] + d[1] > d[2]);

            i = 0;
        }
    }

    return result;
}

pub fn main() !void {
    var arena: std.heap.ArenaAllocator = .init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const solver: aoc.AOCSolver(Result) = .init(
        2016,
        3,
        solve,
        Result{ .p1 = 3, .p2 = 6 },
        Result{ .p1 = 983, .p2 = 1836 },
    );

    solver.info();

    try solver.run(allocator, true);
    try solver.run(allocator, false);
}

// EOF -------------------------------------------------------------------------
