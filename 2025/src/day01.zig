// -----------------------------------------------------------------------------
// Rotating Dials

const std = @import("std");
const Allocator = std.mem.Allocator;

const aoc = @import("aoc");

pub const Result = struct {
    p1: u32,
    p2: u32,

    pub fn format(self: @This(), writer: *std.Io.Writer) std.Io.Writer.Error!void {
        return writer.print("p1 = {d}, p2 = {d}", .{ self.p1, self.p2 });
    }
};

pub fn solve(allocator: Allocator, data: []const u8, test_run: bool) !Result {
    _ = test_run;
    _ = allocator;

    var result: Result = .{ .p1 = 0, .p2 = 0 };

    var dial: u8 = 50;

    var it = std.mem.splitScalar(u8, data, '\n');

    while (it.next()) |line| {
        const d = line[0];
        const n = try std.fmt.parseUnsigned(u16, line[1..], 10);

        for (0..n) |_| {
            if (d == 'R') {
                dial += 1;
                if (dial == 100) dial = 0;
            } else {
                if (dial == 0) dial = 100;
                dial -= 1;
            }
            if (dial == 0) result.p2 += 1;
        }
        if (dial == 0) result.p1 += 1;
    }

    return result;
}

pub fn main() !void {
    var arena: std.heap.ArenaAllocator = .init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const solver: aoc.AOCSolver(Result) = .init(
        2025,
        1,
        solve,
        Result{ .p1 = 3, .p2 = 6 },
        Result{ .p1 = 1123, .p2 = 6695 },
    );

    solver.info();

    try solver.run(allocator, true);
    try solver.run(allocator, false);
}

// EOF -------------------------------------------------------------------------
