// -----------------------------------------------------------------------------
// Finding Routes

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

const KV = std.StringArrayHashMap([][]const u8);
const Cache = std.StringArrayHashMap(usize);

pub fn p1(map: KV, key: []const u8) usize {
    if (std.mem.eql(u8, key, "out")) return 1;

    var res: usize = 0;
    for (map.get(key).?) |k| {
        res += p1(map, k);
    }
    return res;
}

pub fn p2(map: KV, key: []const u8, dac: bool, fft: bool, cache: *Cache) !usize {
    if (std.mem.eql(u8, key, "out")) {
        return if (dac and fft) 1 else 0;
    }

    var buf: [5]u8 = undefined;
    const ck = try std.fmt.bufPrint(
        &buf,
        "{s}{d}{d}",
        .{ key, @intFromBool(dac), @intFromBool(fft) },
    );

    if (cache.get(ck)) |res| return res;

    var res: usize = 0;
    for (map.get(key).?) |k| {
        const _dac = dac or std.mem.eql(u8, k, "dac");
        const _fft = fft or std.mem.eql(u8, k, "fft");

        res += try p2(map, k, _dac, _fft, cache);
    }

    cache.putAssumeCapacityNoClobber(ck, res);

    return res;
}

pub fn solve(allocator: Allocator, data: []const u8, test_run: bool) !Result {
    var result: Result = .{ .p1 = 0, .p2 = 0 };

    var map: KV = .init(allocator);
    defer map.deinit();

    var cache: Cache = .init(allocator);
    defer cache.deinit();
    try cache.ensureTotalCapacity(std.math.pow(u32, 2, 13));

    var it = std.mem.splitScalar(u8, data, '\n');
    while (it.next()) |line| {
        var _it = std.mem.tokenizeAny(u8, line, ": ");

        const k = _it.next().?;
        const v = try aoc.iterator2slice([]const u8, allocator, &_it, line.len);

        try map.put(k, v);
    }

    result.p1 = p1(map, "you");
    if (!test_run) result.p2 = try p2(map, "svr", false, false, &cache);

    return result;
}

pub fn main() !void {
    var arena: std.heap.ArenaAllocator = .init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    const solver: aoc.AOCSolver(Result) = .init(
        2025,
        11,
        solve,
        Result{ .p1 = 5, .p2 = 0 },
        Result{ .p1 = 788, .p2 = 316291887968000 },
    );

    solver.info();

    try solver.run(allocator, true);
    try solver.run(allocator, false);
}

// EOF -------------------------------------------------------------------------
