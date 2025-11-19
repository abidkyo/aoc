// -----------------------------------------------------------------------------

const std = @import("std");
const Allocator = std.mem.Allocator;

const aoc = @import("aoc");
const pos = @import("position");

pub const Result = struct {
    p1: u8,
    p2: u8,

    pub fn format(self: @This(), writer: *std.Io.Writer) std.Io.Writer.Error!void {
        return writer.print("p1 = {d}, p2 = {d}", .{ self.p1, self.p2 });
    }
};

pub fn solve(allocator: Allocator, data: []const u8, test_run: bool) !Result {
    _ = test_run;

    var result: Result = .{ .p1 = 0, .p2 = 0 };

    var it = std.mem.splitSequence(u8, data, ", ");

    var curr: pos.Point = pos.origin;

    var d: u2 = pos.dir4.len - 1;
    var n: u8 = 0;

    var seen = std.AutoArrayHashMap(pos.Point, void).init(allocator);
    defer seen.deinit();

    try seen.ensureTotalCapacity(data.len);

    while (it.next()) |instr| {
        d = switch (instr[0]) {
            'R' => d +% 1,
            'L' => d -% 1,
            else => unreachable,
        };
        n = try std.fmt.parseInt(u8, instr[1..], 10);

        for (0..n) |_| {
            curr = curr + pos.dir4[d].fromEnum();

            if (seen.contains(curr) and result.p2 == 0) {
                result.p2 = @intCast(pos.manhattan_distance(curr, pos.origin));
            }

            try seen.put(curr, {});
        }
    }

    result.p1 = @intCast(pos.manhattan_distance(curr, pos.origin));

    return result;
}

pub fn main() !void {
    var arena: std.heap.ArenaAllocator = .init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const solver: aoc.AOCSolver(Result) = .init(
        2016,
        1,
        allocator,
        solve,
        Result{ .p1 = 8, .p2 = 4 },
        Result{ .p1 = 246, .p2 = 124 },
    );

    solver.info();

    _ = try solver.run(true);
    _ = try solver.run(false);
}

// EOF -------------------------------------------------------------------------
