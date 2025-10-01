// -----------------------------------------------------------------------------

const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const aoc = b.addModule("aoc", .{
        .root_source_file = b.path("common/aoc.zig"),
        .target = target,
    });

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
                    },
                }),
            });

            b.installArtifact(exe);

            const run_step = b.step(name, desc);
            const run_cmd = b.addRunArtifact(exe);
            run_step.dependOn(&run_cmd.step);
            run_cmd.step.dependOn(b.getInstallStep());

            run_step_year.dependOn(&run_cmd.step);

            if (b.args) |args| {
                run_cmd.addArgs(args);
            }
        }
    }

    const mod_tests = b.addTest(.{
        .root_module = aoc,
    });

    const run_mod_tests = b.addRunArtifact(mod_tests);
    const test_step = b.step("test", "Run AOC module tests");
    test_step.dependOn(&run_mod_tests.step);

    const exe = b.addExecutable(.{
        .name = "script",
        .root_module = b.createModule(.{
            .root_source_file = b.path("common/script.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "aoc", .module = aoc },
            },
        }),
    });

    b.installArtifact(exe);

    const run_step = b.step("script", "AOC Utility Script");
    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
}

// EOF -------------------------------------------------------------------------
