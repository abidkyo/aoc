// -----------------------------------------------------------------------------

const std = @import("std");
const Allocator = std.mem.Allocator;

const aoc = @import("aoc");
const pos = @import("position");

const PointMap = std.AutoHashMap(pos.Point, u8);

pub const Result = struct {
    p1: []const u8,
    p2: []const u8,

    pub fn format(self: @This(), writer: *std.Io.Writer) std.Io.Writer.Error!void {
        return writer.print("p1 = \"{s}\", p2 = \"{s}\"", .{ self.p1, self.p2 });
    }
};

const p1_keypad_str =
    \\123
    \\456
    \\789
;

const p2_keypad_str =
    \\  1
    \\ 234
    \\56789
    \\ ABC
    \\  D
;

pub fn getKeypadMap(allocator: Allocator, keypad_str: []const u8) !PointMap {
    // comptime map/allocator would be nice here
    var keypad: PointMap = .init(allocator);
    try keypad.ensureTotalCapacity(@intCast(keypad_str.len));

    const keypad_lines = try aoc.splitlines(allocator, keypad_str);

    for (0.., keypad_lines) |y, line| {
        for (0.., line) |x, c| {
            if (c == ' ') continue;

            const p: pos.Point = .{ @intCast(x), @intCast(y) };
            keypad.putAssumeCapacity(p, c);
        }
    }

    return keypad;
}

pub fn getCode(allocator: Allocator, lines: [][]const u8, keypad: PointMap, start: pos.Point) ![]const u8 {
    var res = try std.ArrayList(u8).initCapacity(allocator, 8);
    defer res.deinit(allocator);

    var current = start;

    for (lines) |line| {
        for (line) |c| {
            const dir = pos.Direction.fromString(&.{std.ascii.toLower(c)}).?;
            const np = current + dir;

            if (keypad.contains(np)) {
                current = np;
            }
        }

        try res.print(allocator, "{c}", .{keypad.get(current).?});
    }

    return res.toOwnedSlice(allocator);
}

pub fn solve(allocator: Allocator, data: []const u8, test_run: bool) !Result {
    _ = test_run;

    var result: Result = .{ .p1 = undefined, .p2 = undefined };

    const lines = try aoc.splitlines(allocator, data);

    var p1_keypad = try getKeypadMap(allocator, p1_keypad_str);
    defer p1_keypad.deinit();

    var p2_keypad = try getKeypadMap(allocator, p2_keypad_str);
    defer p2_keypad.deinit();

    // start at '5'
    const p1_start: pos.Point = .{ 1, 1 };
    const p2_start: pos.Point = .{ 0, 2 };

    result.p1 = try getCode(allocator, lines, p1_keypad, p1_start);
    result.p2 = try getCode(allocator, lines, p2_keypad, p2_start);

    return result;
}

pub fn main() !void {
    var arena: std.heap.ArenaAllocator = .init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const solver: aoc.AOCSolver(Result) = .init(
        2016,
        2,
        solve,
        Result{ .p1 = "1985", .p2 = "5DB3" },
        Result{ .p1 = "82958", .p2 = "B3DB8" },
    );

    solver.info();

    try solver.run(allocator, true);
    try solver.run(allocator, false);
}

// EOF -------------------------------------------------------------------------
