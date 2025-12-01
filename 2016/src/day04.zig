// -----------------------------------------------------------------------------

const std = @import("std");
const Allocator = std.mem.Allocator;

const aoc = @import("aoc");
const Counter = @import("counter").Counter;
const pos = @import("position");

pub const Result = struct {
    p1: u32,
    p2: u32,

    pub fn format(self: @This(), writer: *std.Io.Writer) std.Io.Writer.Error!void {
        return writer.print("p1 = {d}, p2 = {d}", .{ self.p1, self.p2 });
    }
};

pub fn rotateChars(allocator: Allocator, chars: []const u8, count: u16) ![]const u8 {
    var result = try std.ArrayList(u8).initCapacity(allocator, chars.len);
    defer result.deinit(allocator);

    const range = 'z' - 'a' + 1;

    for (chars) |c| {
        const n: u8 = @intCast(((c - 'a' + count) % range) + 'a');
        try result.appendBounded(n);
    }
    return result.toOwnedSlice(allocator);
}

pub fn solve(allocator: Allocator, data: []const u8, test_run: bool) !Result {
    _ = test_run;

    var result: Result = .{ .p1 = 0, .p2 = 0 };

    const lines = try aoc.splitlines(allocator, data);

    for (lines) |line| {
        var it = std.mem.tokenizeAny(u8, line, "-[]");
        const slice = try aoc.iterator2slice([]const u8, allocator, &it, 128);

        const chars = try std.mem.concat(allocator, u8, slice[0..(slice.len - 2)]);
        const id = try std.fmt.parseUnsigned(u16, slice[slice.len - 2], 10);
        const checksum = slice[slice.len - 1];

        var counter = Counter(u8).init(allocator);
        defer counter.deinit();

        try counter.addFromSlice(chars);
        counter.sortDesc();

        const frequents = counter.keys()[0..5];
        if (std.mem.eql(u8, frequents, checksum)) {
            result.p1 += id;
        }

        const rotated = try rotateChars(allocator, chars, id);
        if (std.mem.startsWith(u8, rotated, "northpole")) {
            result.p2 = id;
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
        4,
        solve,
        Result{ .p1 = 1514, .p2 = 0 },
        Result{ .p1 = 361724, .p2 = 482 },
    );

    solver.info();

    try solver.run(allocator, true);
    try solver.run(allocator, false);
}

// EOF -------------------------------------------------------------------------
