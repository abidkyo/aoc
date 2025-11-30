// -----------------------------------------------------------------------------

const std = @import("std");
const Allocator = std.mem.Allocator;
const Md5 = std.crypto.hash.Md5;

const aoc = @import("aoc");
const pos = @import("position");

pub const Result = struct {
    p1: [8]u8,
    p2: [8]u8,

    pub fn format(self: @This(), writer: *std.Io.Writer) std.Io.Writer.Error!void {
        return writer.print("p1 = {s}, p2 = {s}", .{ self.p1, self.p2 });
    }
};

pub fn solve(allocator: Allocator, data: []const u8, test_run: bool) !Result {
    _ = test_run;

    var result: Result = .{ .p1 = .{0} ** 8, .p2 = .{0} ** 8 };

    var num: u32 = 0;
    var i: u8 = 0;
    var j: u8 = 0;

    while (i < 8 or j < 8) {
        const secret = try std.fmt.allocPrint(allocator, "{s}{d}", .{ data, num });
        const hash = Md5.hashResult(secret);

        if (i < 8 and hash[0] == 0 and hash[1] == 0 and hash[2] < 16) {
            result.p1[i] = std.fmt.digitToChar(hash[2], .lower);
            i += 1;
        }

        if (j < 8 and hash[0] == 0 and hash[1] == 0 and hash[2] < 8) {
            const k = hash[2];
            if (result.p2[k] == 0) {
                result.p2[k] = std.fmt.digitToChar(hash[3] >> 4, .lower);
                j += 1;
            }
        }

        num += 1;
    }

    return result;
}

pub fn main() !void {
    var arena: std.heap.ArenaAllocator = .init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const solver: aoc.AOCSolver(Result) = .init(
        2016,
        5,
        allocator,
        solve,
        Result{ .p1 = "18f47a30".*, .p2 = "05ace8e3".* },
        Result{ .p1 = "f77a0e6e".*, .p2 = "999828ec".* },
    );

    solver.info();

    try solver.run(true);
    try solver.run(false);
}

// EOF -------------------------------------------------------------------------
