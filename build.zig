// -----------------------------------------------------------------------------

const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    if (optimize == .ReleaseFast) {
        b.exe_dir = b.getInstallPath(.{ .custom = "fast" }, "");
    }

    // -------------------------------------------------------------------------

    const aoc = b.addModule("aoc", .{
        .root_source_file = b.path("lib/aoc.zig"),
        .target = target,
    });

    const aoc_test = b.addTest(.{
        .name = "aoc",
        .root_module = aoc,
    });
    const run_aoc_test = b.addRunArtifact(aoc_test);

    // -------------------------------------------------------------------------

    const position = b.addModule("position", .{
        .root_source_file = b.path("lib/position.zig"),
        .target = target,
    });

    const position_test = b.addTest(.{
        .name = "position",
        .root_module = position,
    });
    const run_position_test = b.addRunArtifact(position_test);

    // -------------------------------------------------------------------------

    const counter = b.addModule("counter", .{
        .root_source_file = b.path("lib/counter.zig"),
        .target = target,
    });

    const counter_test = b.addTest(.{
        .name = "counter",
        .root_module = counter,
    });
    const run_counter_test = b.addRunArtifact(counter_test);

    // -------------------------------------------------------------------------

    const test_step = b.step("test", "Run module tests");
    test_step.dependOn(&run_aoc_test.step);
    test_step.dependOn(&run_position_test.step);
    test_step.dependOn(&run_counter_test.step);

    // -------------------------------------------------------------------------

    const run_step_all = b.step("all", "Run all AOC");
    for (2015..2026) |year| {
        const run_step_year = b.step(b.fmt("{d}", .{year}), b.fmt("Run AOC {d}", .{year}));

        for (1..26) |day| {
            const name = b.fmt("{d}_{d:0>2}", .{ year, day });
            const src = b.fmt("{d}/src/day{d:0>2}.zig", .{ year, day });
            const desc = b.fmt("Run AOC {d} Day {d:0>2}", .{ year, day });

            std.fs.cwd().access(src, .{ .mode = .read_only }) catch continue;

            const exe = b.addExecutable(.{
                .name = name,
                .root_module = b.createModule(.{
                    .root_source_file = b.path(src),
                    .target = target,
                    .optimize = optimize,
                    .imports = &.{
                        .{ .name = "aoc", .module = aoc },
                        .{ .name = "position", .module = position },
                        .{ .name = "counter", .module = counter },
                    },
                }),
            });

            b.installArtifact(exe);

            const run_step = b.step(name, desc);
            const run_cmd = b.addRunArtifact(exe);
            run_step.dependOn(&run_cmd.step);
            run_cmd.step.dependOn(b.getInstallStep());

            run_step_year.dependOn(&run_cmd.step);
            run_step_all.dependOn(&run_cmd.step);
        }
    }

    // -------------------------------------------------------------------------

    const script = b.addExecutable(.{
        .name = "script",
        .root_module = b.createModule(.{
            .root_source_file = b.path("util/script.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    b.installArtifact(script);

    const run_script_step = b.step("script", "AOC Utility Script");
    const run_script_cmd = b.addRunArtifact(script);
    run_script_step.dependOn(&run_script_cmd.step);
    run_script_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_script_cmd.addArgs(args);
    }

    // -------------------------------------------------------------------------
}

// EOF -------------------------------------------------------------------------
