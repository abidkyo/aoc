// -----------------------------------------------------------------------------

const std = @import("std");
const Allocator = std.mem.Allocator;

fn test_solve(_: Allocator, _: []const u8, _: bool) !TestResult {
    const result: TestResult = .{ .p1 = 1234, .p2 = "solving" };
    return result;
}

pub const TestResult = struct {
    p1: u32,
    p2: []const u8,

    pub fn format(self: @This(), writer: *std.Io.Writer) std.Io.Writer.Error!void {
        return writer.print("p1 = {d}, p2 = \"{s}\"", .{ self.p1, self.p2 });
    }
};

pub fn AOCSolver(comptime T: type) type {
    return struct {
        year: u16,
        day: u8,
        allocator: Allocator,
        solve: *const fn (Allocator, []const u8, bool) anyerror!T,
        expected_test: T,
        expected_real: T,

        const Self = @This();

        pub fn init(
            year: u16,
            day: u8,
            allocator: Allocator,
            solve: *const fn (Allocator, []const u8, bool) anyerror!T,
            expected_test: T,
            expected_real: T,
        ) Self {
            return .{
                .year = year,
                .day = day,
                .allocator = allocator,
                .solve = solve,
                .expected_test = expected_test,
                .expected_real = expected_real,
            };
        }

        pub fn info(self: Self) void {
            std.log.info("AOC {d} Day {d:0>2}", .{ self.year, self.day });
        }

        pub fn run(self: Self, test_run: bool) !void {
            const filename = try self.input_filename(test_run);
            defer self.allocator.free(filename);

            const data = try self.read_input(filename);
            defer self.allocator.free(data);

            var timer = try std.time.Timer.start();

            const result = try self.solve(self.allocator, data, test_run);
            const duration = timer.lap();

            const prefix = if (test_run) "test" else "real";
            std.log.info("{s}: {f}, t = {D}", .{ prefix, result, duration });

            const expected_result = if (test_run) self.expected_test else self.expected_real;
            if (!std.meta.eql(result, expected_result)) {
                std.log.err("expected: {f}", .{expected_result});
                return error.WrongResult;
            }

            return;
        }

        pub fn input_filename(self: Self, test_run: bool) ![]const u8 {
            const test_str = if (test_run) "_test" else "";

            const filename = try std.fmt.allocPrint(
                self.allocator,
                "{d}/input/day{d:0>2}{s}.txt",
                .{ self.year, self.day, test_str },
            );
            return filename;
        }

        pub fn read_input(self: Self, filename: []const u8) ![]const u8 {
            const data = try std.fs.cwd().readFileAlloc(
                self.allocator,
                filename,
                std.math.maxInt(usize),
            );
            return std.mem.trimEnd(u8, data, "\n");
        }
    };
}

test "input filename" {
    var arena: std.heap.ArenaAllocator = .init(std.testing.allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const solver: AOCSolver(TestResult) = .init(
        2024,
        1,
        allocator,
        test_solve,
        TestResult{ .p1 = 1234, .p2 = "solving" },
        TestResult{ .p1 = 1234, .p2 = "solving" },
    );

    const filename_test = try solver.input_filename(true);

    try std.testing.expectEqualStrings("2024/input/day01_test.txt", filename_test);

    const filename = try solver.input_filename(false);

    try std.testing.expectEqualStrings("2024/input/day01.txt", filename);
}

test "read input" {
    var arena: std.heap.ArenaAllocator = .init(std.testing.allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const solver: AOCSolver(TestResult) = .init(
        2024,
        1,
        allocator,
        test_solve,
        TestResult{ .p1 = 1234, .p2 = "solving" },
        TestResult{ .p1 = 1234, .p2 = "solving" },
    );

    const filename_test = try solver.input_filename(true);
    const data = try solver.read_input(filename_test);

    try std.testing.expect(data.len != 0);
    try std.testing.expect(data[data.len - 1] != '\n');
}

test "call solve" {
    var arena: std.heap.ArenaAllocator = .init(std.testing.allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const solver: AOCSolver(TestResult) = .init(
        2024,
        1,
        allocator,
        test_solve,
        TestResult{ .p1 = 1234, .p2 = "solving" },
        TestResult{ .p1 = 1234, .p2 = "solving" },
    );

    const res = try solver.solve(allocator, "", true);
    try std.testing.expectEqual(res.p1, 1234);
    try std.testing.expectEqualStrings(res.p2, "solving");
}

test "call run" {
    var arena: std.heap.ArenaAllocator = .init(std.testing.allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const solver: AOCSolver(TestResult) = .init(
        2024,
        1,
        allocator,
        test_solve,
        TestResult{ .p1 = 1234, .p2 = "solving" },
        TestResult{ .p1 = 1234, .p2 = "solving" },
    );

    _ = try solver.run(true);
    _ = try solver.run(false);
}

// EOF -------------------------------------------------------------------------
