const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "sod",
        .target = target,
        .optimize = optimize,
    });
    lib.addCSourceFiles(
        &[_][]const u8{"src/sod.c"},
        &[_][]const u8{ "-Wall", "-std=c99" },
    );
    lib.addIncludePath("include");
    lib.linkLibC();
    b.installArtifact(lib);

    const main_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/tests.zig" },
        .target = target,
        .optimize = optimize,
    });
    main_tests.addIncludePath("include");
    main_tests.linkLibrary(lib);

    const run_main_tests = b.addRunArtifact(main_tests);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&run_main_tests.step);
}
