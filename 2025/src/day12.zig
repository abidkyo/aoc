// -----------------------------------------------------------------------------
// Setting-Up Presents

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
    var result: Result = .{ .p1 = 0, .p2 = 0 };

    if (test_run) return result;

    const _data = try aoc.split(allocator, data, "\n\n");
    defer allocator.free(_data);

    const presents = _data[0..(_data.len - 1)];
    const regions = _data[_data.len - 1];

    var p_sizes = try allocator.alloc(usize, presents.len);
    for (0.., presents) |i, line| {
        p_sizes[i] = std.mem.count(u8, line, "#");
    }

    var it = std.mem.splitScalar(u8, regions, '\n');
    while (it.next()) |line| {
        var _it = std.mem.tokenizeAny(u8, line, "x: ");
        const r_size =
            try std.fmt.parseUnsigned(usize, _it.next().?, 10) *
            try std.fmt.parseUnsigned(usize, _it.next().?, 10);

        var p_size: usize = 0;
        for (p_sizes) |s| {
            const ss = try std.fmt.parseUnsigned(usize, _it.next().?, 10);
            p_size += s * ss;
        }

        const ps: f32 = @floatFromInt(p_size);
        p_size = @intFromFloat(ps * 1.25);

        if (p_size <= r_size) result.p1 += 1;
    }

    return result;
}

pub fn main() !void {
    var arena: std.heap.ArenaAllocator = .init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const solver: aoc.AOCSolver(Result) = .init(
        2025,
        12,
        solve,
        Result{ .p1 = 0, .p2 = 0 },
        Result{ .p1 = 583, .p2 = 0 },
    );

    solver.info();

    try solver.run(allocator, true);
    try solver.run(allocator, false);
}

// EOF -------------------------------------------------------------------------
