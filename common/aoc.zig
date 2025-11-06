// -----------------------------------------------------------------------------

const std = @import("std");
const Allocator = std.mem.Allocator;

fn test_solve(_: Allocator, _: []const u8, _: bool) []const u8 {
    return "solving";
}

pub const AOCSolver = struct {
    allocator: Allocator,
    year: u16,
    day: u8,
    solve: *const fn (
        allocator: Allocator,
        data: []const u8,
        test_run: bool,
    ) []const u8,

    pub fn info(self: AOCSolver) void {
        std.log.info("AOC {d} Day {d:0>2}", .{ self.year, self.day });
    }

    pub fn run(self: AOCSolver) []const u8 {
        var test_run = true;

        var filename = self.input_filename(test_run);
        var data = self.read_input(filename);

        var timer = std.time.Timer.start() catch unreachable;

        const res_test = self.solve(self.allocator, data, true);
        const time_test = timer.lap() / std.time.ns_per_ms;

        test_run = false;

        filename = self.input_filename(test_run);
        data = self.read_input(filename);

        _ = timer.reset();

        const res_real = self.solve(self.allocator, data, false);
        const time_real = timer.lap() / std.time.ns_per_ms;

        const res = std.fmt.allocPrint(
            self.allocator,
            \\result
            \\      test: {s}, t = {d} ms
            \\      real: {s}, t = {d} ms
        ,
            .{ res_test, time_test, res_real, time_real },
        ) catch unreachable;

        std.log.info("{s}", .{res});

        return res;
    }

    pub fn input_filename(
        self: AOCSolver,
        test_run: bool,
    ) []const u8 {
        const test_str = if (test_run) "_test" else "";

        const filename = std.fmt.allocPrint(
            self.allocator,
            "{d}/input/day{d:0>2}{s}.txt",
            .{ self.year, self.day, test_str },
        ) catch unreachable;
        return filename;
    }

    pub fn read_input(
        self: AOCSolver,
        filename: []const u8,
    ) []const u8 {
        const data = std.fs.cwd().readFileAlloc(
            self.allocator,
            filename,
            std.math.maxInt(usize),
        ) catch {
            @panic("ERROR: reading file");
        };

        return std.mem.trimEnd(u8, data, "\n");
    }
};

test "input filename" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const solver = AOCSolver{
        .year = 2024,
        .day = 1,
        .allocator = allocator,
        .solve = test_solve,
    };

    const filename_test = solver.input_filename(true);

    try std.testing.expectEqualStrings("2024/input/day01_test.txt", filename_test);

    const filename = solver.input_filename(false);

    try std.testing.expectEqualStrings("2024/input/day01.txt", filename);
}

test "read input" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const solver = AOCSolver{
        .year = 2024,
        .day = 1,
        .allocator = allocator,
        .solve = test_solve,
    };

    const filename_test = solver.input_filename(true);
    const data = solver.read_input(filename_test);

    try std.testing.expect(data.len != 0);
    try std.testing.expect(data[data.len - 1] != '\n');
}

test "call solve" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const solver = AOCSolver{
        .year = 2024,
        .day = 1,
        .allocator = allocator,
        .solve = test_solve,
    };

    const res = solver.solve(allocator, "", true);
    try std.testing.expectEqualStrings(res, "solving");
}

test "call run" {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const solver = AOCSolver{
        .year = 2024,
        .day = 1,
        .allocator = allocator,
        .solve = test_solve,
    };

    const res = solver.run();
    try std.testing.expectStringStartsWith(res, "result");
}

// EOF -------------------------------------------------------------------------
