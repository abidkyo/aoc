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

pub fn downloadInput(
    allocator: Allocator,
    writer: *Writer,
    url: []const u8,
    session: []const u8,
) !void {
    const cookie = try std.fmt.allocPrint(allocator, "session={s}", .{session});

    const header = [_]std.http.Header{
        .{ .name = "Cookie", .value = cookie },
        .{ .name = "User-Agent", .value = "abidkyo @ github.com/abidkyo" },
    };

    var client = std.http.Client{
        .allocator = allocator,
    };
    defer client.deinit();

    const response = try client.fetch(.{
        .location = .{ .url = url },
        .method = .GET,
        .extra_headers = &header,
        .response_writer = writer,
    });

    if (response.status != .ok) {
        return error.DownloadInputFailed;
    }

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
    const year = 2025;
    const day = 11;

    std.log.info("AOC Script {d} Day {d:0>2}", .{ year, day });

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    // var writer = std.io.Writer.Allocating.init(allocator);
    // defer writer.deinit();
    //
    // const session = try getSession();
    //
    // const url = try std.fmt.allocPrint(
    //     allocator,
    //     "https://adventofcode.com/{d}/day/{d}/input",
    //     .{ year, day },
    // );
    //
    // try downloadInput(allocator, &writer.writer, url, session);
    //
    // const filename = try std.fmt.allocPrint(
    //     allocator,
    //     "{d}/input/day{d:0>2}.txt",
    //     .{ year, day },
    // );
    // try std.fs.cwd().writeFile(.{
    //     .sub_path = filename,
    //     .data = writer.written(),
    // });

    try generateFiles(allocator, year, day);
}

// EOF -------------------------------------------------------------------------
