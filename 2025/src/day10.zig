// -----------------------------------------------------------------------------

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

pub fn parseButtons(allocator: Allocator, data: [][]const u8) ![]usize {
    var buttons: std.ArrayList(usize) = try .initCapacity(allocator, data.len);
    defer buttons.deinit(allocator);

    for (data) |line| {
        var button: usize = 0;

        var it = std.mem.splitScalar(u8, line[1..(line.len - 1)], ',');
        while (it.next()) |c| {
            button += std.math.pow(usize, 2, c[0] - '0');
        }
        buttons.appendAssumeCapacity(button);
    }

    return try buttons.toOwnedSlice(allocator);
}

pub fn calcMinPress(buttons: []usize, target: usize) !usize {
    var min_press: usize = buttons.len;

    for (0..(std.math.pow(usize, 2, buttons.len))) |i| {
        var curr: usize = 0;
        var press: usize = 0;

        for (0.., buttons) |j, b| {
            if ((i >> @intCast(j)) % 2 == 0) continue;
            curr ^= b;
            press += 1;
        }

        if (target == curr) {
            min_press = @min(min_press, press);
        }
    }

    return min_press;
}

pub fn solve(allocator: Allocator, data: []const u8, test_run: bool) !Result {
    _ = test_run;

    var result: Result = .{ .p1 = 0, .p2 = 0 };
    result.p1 = 0;
    result.p2 = 0;

    var it = std.mem.splitScalar(u8, data, '\n');
    while (it.next()) |line| {
        const _line = try aoc.split(allocator, line, " ");
        defer allocator.free(_line);

        const buttons = try parseButtons(allocator, _line[1..(_line.len - 1)]);
        defer allocator.free(buttons);

        var target: usize = 0;
        for (0.., (_line[0][1..(_line[0].len - 1)])) |i, c| {
            if (c != '#') continue;
            target += std.math.pow(usize, 2, i);
        }

        result.p1 += try calcMinPress(buttons, target);
    }

    return result;
}

pub fn main() !void {
    var arena: std.heap.ArenaAllocator = .init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const solver: aoc.AOCSolver(Result) = .init(
        2025,
        10,
        solve,
        Result{ .p1 = 7, .p2 = 0 },
        Result{ .p1 = 415, .p2 = 0 },
    );

    solver.info();

    try solver.run(allocator, true);
    try solver.run(allocator, false);
}

// EOF -------------------------------------------------------------------------
