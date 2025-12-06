// -----------------------------------------------------------------------------
// Parsing Numbers

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

    const lines = try aoc.splitlines(allocator, data);
    defer allocator.free(lines);

    const num_lines = lines[0..(lines.len - 1)];
    const op_line = lines[lines.len - 1];

    var idx = try std.ArrayList(usize).initCapacity(allocator, op_line.len / 2);
    defer idx.deinit(allocator);

    var it = std.mem.tokenizeScalar(u8, op_line, ' ');
    while (it.next()) |_| idx.appendAssumeCapacity(it.index - 1);
    idx.appendAssumeCapacity(it.index + 1);

    for (0..(idx.items.len - 1)) |i| {
        const start = idx.items[i];
        const end = idx.items[i + 1] - 1;
        const op = op_line[start];

        {
            var res: usize = if (op == '*') 1 else 0;
            defer result.p1 += res;

            for (num_lines) |line| {
                const str = std.mem.trim(u8, line[start..end], " ");
                const num = try std.fmt.parseUnsigned(usize, str, 10);

                if (op == '+') res += num else if (op == '*') res *= num;
            }
        }
        {
            var res: usize = if (op == '*') 1 else 0;
            defer result.p2 += res;

            for (start..end) |j| {
                var num: usize = 0;
                for (num_lines) |line| {
                    if (line[j] == ' ') continue;
                    num = num * 10 + (line[j] - '0');
                }
                if (op == '+') res += num else if (op == '*') res *= num;
            }
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
        6,
        solve,
        Result{ .p1 = 4277556, .p2 = 3263827 },
        Result{ .p1 = 3785892992137, .p2 = 7669802156452 },
    );

    solver.info();

    try solver.run(allocator, true);
    try solver.run(allocator, false);
}

// EOF -------------------------------------------------------------------------
