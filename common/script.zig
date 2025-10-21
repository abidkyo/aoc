// -----------------------------------------------------------------------------

const std = @import("std");
const Allocator = std.mem.Allocator;
const Writer = std.io.Writer;

pub fn getSession() ![]const u8 {
    const aoc_session = std.posix.getenv("AOC_SESSION");

    if (aoc_session) |session| {
        return session;
    } else {
        return error.EnvVariableNotFound;
    }
}

pub fn checkInputAvailable(allocator: Allocator, year: u16, day: u8) !void {
    const date_str = try std.fmt.allocPrint(
        allocator,
        "{d}-12-{d} 06:00",
        .{ year, day },
    );

    const res = try std.process.Child.run(.{
        .allocator = allocator,
        .argv = &[_][]const u8{ "date", "-d", date_str, "+%s" },
    });

    const epoch_aoc = try std.fmt.parseInt(
        i64,
        std.mem.trimEnd(u8, res.stdout, "\n"),
        10,
    );
    const epoch_now = std.time.timestamp();

    if (epoch_aoc > epoch_now) {
        return error.InputNotYetAvailable;
    }
}

pub fn downloadInputToFile(allocator: Allocator, year: u16, day: u8) !void {
    try checkInputAvailable(allocator, year, day);

    const session = try getSession();
    const cookie = try std.fmt.allocPrint(allocator, "session={s}", .{session});

    const url = try std.fmt.allocPrint(
        allocator,
        "https://adventofcode.com/{d}/day/{d}/input",
        .{ year, day },
    );
    const header = [_]std.http.Header{
        .{ .name = "Cookie", .value = cookie },
        .{ .name = "User-Agent", .value = "abidkyo @ github.com/abidkyo" },
    };

    var writer = std.io.Writer.Allocating.init(allocator);
    defer writer.deinit();

    var client = std.http.Client{
        .allocator = allocator,
    };
    defer client.deinit();

    const response = try client.fetch(.{
        .location = .{ .url = url },
        .method = .GET,
        .extra_headers = &header,
        .response_writer = &writer.writer,
    });

    if (response.status != .ok) {
        return error.DownloadInputFailed;
    }

    const filename = try std.fmt.allocPrint(
        allocator,
        "{d}/input/day{d:0>2}.txt",
        .{ year, day },
    );
    try std.fs.cwd().writeFile(.{
        .sub_path = filename,
        .data = writer.written(),
    });

    std.log.info("download input successful", .{});
}

pub fn generateFiles(allocator: Allocator, year: u16, day: u8) !void {
    const src_dirname = try std.fmt.allocPrint(
        allocator,
        "{d}/src",
        .{year},
    );
    const input_dirname = try std.fmt.allocPrint(
        allocator,
        "{d}/input",
        .{year},
    );
    const src_name = try std.fmt.allocPrint(
        allocator,
        "{d}/src/day{d:0>2}.zig",
        .{ year, day },
    );
    const input_name = try std.fmt.allocPrint(
        allocator,
        "{d}/input/day{d:0>2}.txt",
        .{ year, day },
    );
    const testinput_name = try std.fmt.allocPrint(
        allocator,
        "{d}/input/day{d:0>2}_test.txt",
        .{ year, day },
    );

    var template = try std.fs.cwd().readFileAlloc(
        allocator,
        "common/template.zig",
        std.math.maxInt(usize),
    );

    template = try std.mem.replaceOwned(
        u8,
        allocator,
        template,
        "\"{{year}}\"",
        try std.fmt.allocPrint(allocator, "{d}", .{year}),
    );
    template = try std.mem.replaceOwned(
        u8,
        allocator,
        template,
        "\"{{day}}\"",
        try std.fmt.allocPrint(allocator, "{d}", .{day}),
    );

    _ = try std.fs.cwd().makePath(src_dirname);
    _ = try std.fs.cwd().makePath(input_dirname);

    const input_file = try std.fs.cwd().createFile(input_name, .{});
    defer input_file.close();

    const testinput_file = try std.fs.cwd().createFile(testinput_name, .{});
    defer testinput_file.close();

    _ = try std.fs.cwd().writeFile(.{
        .sub_path = src_name,
        .data = template,
    });

    std.log.info("generate files successful", .{});
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    var args = try std.process.argsWithAllocator(allocator);
    defer args.deinit();

    _ = args.skip();

    var year: u16 = 2025;
    var day: u8 = 1;

    if (args.next()) |arg| {
        year = try std.fmt.parseInt(u16, arg, 10);
    }
    if (args.next()) |arg| {
        day = try std.fmt.parseInt(u8, arg, 10);
    }

    std.log.info("AOC Script {d} Day {d:0>2}", .{ year, day });

    while (args.next()) |arg| {
        switch (arg[0]) {
            'c' => try generateFiles(allocator, year, day),
            'i' => try downloadInputToFile(allocator, year, day),
            else => return,
        }
    }
}

// EOF -------------------------------------------------------------------------
