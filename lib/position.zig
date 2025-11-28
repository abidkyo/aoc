// -----------------------------------------------------------------------------

const std = @import("std");

pub const origin: Point = .{ 0, 0 };

pub const Point = @Vector(2, i32);

test "point variable" {
    const a: Point = .{ 1, 2 };

    try std.testing.expectEqual(1, a[0]);
    try std.testing.expectEqual(2, a[1]);

    const b: Point = .{ 3, 4 };

    try std.testing.expectEqual(3, b[0]);
    try std.testing.expectEqual(4, b[1]);

    var c: Point = .{ 5, 6 };
    c[0] = 7;
    c[1] = 8;

    try std.testing.expectEqual(7, c[0]);
    try std.testing.expectEqual(8, c[1]);
}

test "point operation" {
    const a: Point = .{ 1, 2 };
    const b: Point = .{ 3, 4 };
    const n: Point = @splat(5);

    try std.testing.expectEqual(3, b[0]);
    try std.testing.expectEqual(4, b[1]);
    try std.testing.expectEqual(Point{ 4, 6 }, a + b);
    try std.testing.expectEqual(Point{ 2, 2 }, b - a);
    try std.testing.expectEqual(Point{ 3, 8 }, a * b);
    try std.testing.expectEqual(Point{ 3, 2 }, b / a);
    try std.testing.expectEqual(Point{ 3, 2 }, @divFloor(b, a));
    try std.testing.expectEqual(Point{ 5, 10 }, a * n);
}

pub const Direction = enum {
    up,
    right,
    down,
    left,
    upper_left,
    upper_right,
    down_right,
    down_left,

    pub fn fromString(d: []const u8) ?Point {
        const dir8_map = std.StaticStringMap(Point).initComptime(.{
            .{ "u", .{ 0, -1 } },
            .{ "r", .{ 1, 0 } },
            .{ "d", .{ 0, 1 } },
            .{ "l", .{ -1, 0 } },
            .{ "ul", .{ -1, -1 } },
            .{ "ur", .{ 1, -1 } },
            .{ "dr", .{ 1, 1 } },
            .{ "dl", .{ -1, 1 } },
        });

        return dir8_map.get(d);
    }

    pub fn fromEnum(d: Direction) Point {
        return switch (d) {
            .up => .{ 0, -1 },
            .right => .{ 1, 0 },
            .down => .{ 0, 1 },
            .left => .{ -1, 0 },
            .upper_left => .{ -1, -1 },
            .upper_right => .{ 1, -1 },
            .down_right => .{ 1, 1 },
            .down_left => .{ -1, 1 },
        };
    }
};

test "direction value" {
    try std.testing.expectEqual(.{ 1, 0 }, Direction.fromString("r"));
    try std.testing.expectEqual(.{ 1, -1 }, Direction.fromString("ur"));

    try std.testing.expectEqual(.{ 0, 1 }, Direction.fromEnum(.down));
    try std.testing.expectEqual(.{ -1, 1 }, Direction.fromEnum(.down_left));
}

pub const dir4 = [_]Direction{ .up, .right, .down, .left };

test "dir4 value" {
    const res = [_]Point{ .{ 0, -1 }, .{ 1, 0 }, .{ 0, 1 }, .{ -1, 0 } };

    for (res, dir4) |r, d| {
        try std.testing.expectEqual(r, d.fromEnum());
    }

    try std.testing.expectEqual(res[0], dir4[0].fromEnum());
    try std.testing.expectEqual(res[2], dir4[2].fromEnum());
}

pub fn manhattan_distance(a: Point, b: Point) u32 {
    return @abs(a[0] - b[0]) + @abs(a[1] - b[1]);
}

test "manhattan distance" {
    const a = origin;
    const b: Point = .{ 10, 4 };

    const c = manhattan_distance(a, b);

    try std.testing.expectEqual(14, c);
}

// pythagoras

// EOF -------------------------------------------------------------------------
