// -----------------------------------------------------------------------------

const std = @import("std");
const Allocator = std.mem.Allocator;
const test_allocator = std.testing.allocator;

pub fn Counter(comptime K: type) type {
    return struct {
        map: resolveType(K),

        const Self = @This();

        pub fn init(allocator: Allocator) Self {
            return .{ .map = .init(allocator) };
        }

        pub fn deinit(self: *Self) void {
            self.map.deinit();
        }

        pub fn clone(self: Self) !Self {
            const new_map = try self.map.clone();
            return .{ .map = new_map };
        }

        pub fn get(self: Self, item: K) usize {
            return self.map.get(item) orelse 0;
        }

        pub fn keys(self: Self) []K {
            return self.map.keys();
        }

        pub fn values(self: Self) []usize {
            return self.map.values();
        }

        pub fn total(self: Self) usize {
            var sum: usize = 0;
            for (self.map.values()) |val| sum += val;
            return sum;
        }

        pub fn increment(self: *Self, item: K, n: usize) !void {
            const val = self.map.get(item) orelse 0;
            try self.map.put(item, val + n);
        }

        pub fn addFromSlice(self: *Self, slice: []const K) !void {
            try self.map.ensureUnusedCapacity(slice.len);

            for (slice) |item| try self.increment(item, 1);
        }

        pub fn addFromIterator(self: *Self, it: anytype) !void {
            try self.map.ensureUnusedCapacity(it.buffer.len);
            while (it.next()) |item| try self.increment(item, 1);
        }

        pub fn sortAsc(self: *Self) void {
            self.sort(false);
        }

        pub fn sortDesc(self: *Self) void {
            self.sort(true);
        }

        const SortContext = struct {
            keys: []K,
            values: []usize,
            // reversed = false : ascending values
            // reversed = true  : descending values
            reversed: bool = false,

            pub fn lessThan(ctx: @This(), a_index: usize, b_index: usize) bool {
                if (ctx.values[a_index] == ctx.values[b_index]) {
                    // ascending keys
                    return ctx.keys[a_index] < ctx.keys[b_index];
                }
                const less_than: bool = ctx.values[a_index] < ctx.values[b_index];

                if (ctx.reversed) return !less_than;
                return less_than;
            }
        };

        pub fn sort(self: *Self, reversed: bool) void {
            const sort_ctx = SortContext{
                .keys = self.map.keys(),
                .values = self.map.values(),
                .reversed = reversed,
            };
            self.map.sort(sort_ctx);
        }
    };
}

test "increment/get item" {
    var counter = Counter([]const u8).init(test_allocator);
    defer counter.deinit();

    try std.testing.expectEqual(counter.get("abc"), 0);

    try counter.increment("abc");
    try std.testing.expectEqual(counter.get("abc"), 1);

    try counter.increment("abc");
    try std.testing.expectEqual(counter.get("abc"), 2);
}

test "addFromSlice" {
    var counter = Counter(u8).init(test_allocator);
    defer counter.deinit();

    const slice: []const u8 = "aaabbc";
    try counter.addFromSlice(slice);

    try std.testing.expectEqual(counter.get('a'), 3);
    try std.testing.expectEqual(counter.get('b'), 2);
    try std.testing.expectEqual(counter.get('c'), 1);
}

test "addFromIterator" {
    var counter = Counter([]const u8).init(test_allocator);
    defer counter.deinit();

    const words: []const u8 = "my cat is a cat";

    var it = std.mem.tokenizeScalar(u8, words, ' ');
    try counter.addFromIterator(&it);

    try std.testing.expectEqual(counter.get("my"), 1);
    try std.testing.expectEqual(counter.get("cat"), 2);
    try std.testing.expectEqual(counter.get("is"), 1);
    try std.testing.expectEqual(counter.get("a"), 1);
}

test "sort asc/desc" {
    var counter = Counter(u8).init(test_allocator);
    defer counter.deinit();

    const slice: []const u8 = "bbbdaaacczzzz";
    try counter.addFromSlice(slice);

    counter.sortAsc();

    var expected_keys: []const u8 = &.{ 'd', 'c', 'a', 'b', 'z' };
    var expected_values: []const usize = &.{ 1, 2, 3, 3, 4 };

    for (
        counter.keys(),
        counter.values(),
        expected_keys,
        expected_values,
    ) |k, v, ek, ev| {
        try std.testing.expectEqual(k, ek);
        try std.testing.expectEqual(v, ev);
    }

    counter.sortDesc();

    expected_keys = &.{ 'z', 'a', 'b', 'c', 'd' };
    expected_values = &.{ 4, 3, 3, 2, 1 };

    for (
        counter.keys(),
        counter.values(),
        expected_keys,
        expected_values,
    ) |k, v, ek, ev| {
        try std.testing.expectEqual(k, ek);
        try std.testing.expectEqual(v, ev);
    }
}

test "total" {
    var counter = Counter(u8).init(test_allocator);
    defer counter.deinit();

    const slice: []const u8 = "bbbdaaacczzzz";
    try counter.addFromSlice(slice);

    try std.testing.expectEqual(counter.total(), slice.len);
}

fn resolveType(comptime T: type) type {
    // rely on compile error for other types
    if (T == []const u8) return std.StringArrayHashMap(usize);
    return std.AutoArrayHashMap(T, usize);
}

test "resolveType" {
    try std.testing.expectEqual(
        resolveType(u8),
        std.AutoArrayHashMap(u8, usize),
    );

    try std.testing.expectEqual(
        resolveType([]const u8),
        std.StringArrayHashMap(usize),
    );
}

// EOF -------------------------------------------------------------------------
