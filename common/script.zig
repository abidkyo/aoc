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

pub fn main() !void {
    const year = 2024;
    const day = 11;

    std.log.info("AOC Script {d} Day {d:0>2}", .{ year, day });

    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    var writer = std.io.Writer.Allocating.init(allocator);
    defer writer.deinit();

    const session = try getSession();

    const url = try std.fmt.allocPrint(
        allocator,
        "https://adventofcode.com/{d}/day/{d}/input",
        .{ year, day },
    );

    try downloadInput(allocator, &writer.writer, url, session);

    const filename = try std.fmt.allocPrint(
        allocator,
        "{d}/input/day{d:0>2}.txt",
        .{ year, day },
    );
    try std.fs.cwd().writeFile(.{
        .sub_path = filename,
        .data = writer.written(),
    });
}

// EOF -------------------------------------------------------------------------
